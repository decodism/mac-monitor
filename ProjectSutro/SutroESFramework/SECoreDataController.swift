//
//  SECoreDataController.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 2/8/23.
//

import Foundation
import CoreData
import OSLog
import AppleArchive
import System

// @discussion The Core Data stack we're using here is based on: https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack
// Additionally, we used the following for compression:
// https://developer.apple.com/documentation/accelerate/compressing_file_system_directories

var psc: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "BatchedEvents")
    let fileManager = FileManager.default
    let applicationSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .systemDomainMask).first!
    let cdEventBatchesURL = applicationSupportURL.appending(path: "com.swiftlydetecting.securityextension").appending(path: "event_batches")
    container.persistentStoreDescriptions[0].url = cdEventBatchesURL
    container.loadPersistentStores { description, error in
        if let error = error {
            fatalError("Unable to load `BatchedEvents` persistent stores: \(error)")
        }
    }
    return container
}()

var eventEmitCount: Int = 0
var packageMembers: Int = 0
let telemetryFilesPerPackage: Int = 1
let batchEventLimit: Int = 7200
let completePackageLimit: Int = 10

let fileManagerDir = FileManager.default
let applicationSupportURL = fileManagerDir.urls(for: .applicationSupportDirectory, in: .systemDomainMask).first!
let telemetryPackageTempURL = applicationSupportURL.appending(path: "com.swiftlydetecting.securityextension").appending(path: "telemetry_package_tmp")


func numberOfFiles(at url: URL) -> Int {
    let contents = try? FileManager.default.contentsOfDirectory(atPath: url.path)
    return contents?.count ?? 0
}


func deleteTempPackage() {
    do {
        try FileManager.default.removeItem(at: telemetryPackageTempURL)
    } catch {
        os_log("Error deleting the temporary package directory \(error.localizedDescription)")
    }
}

func deleteCompletePakagaes() {
    do {
        try FileManager.default.removeItem(at: telemetryPackageTempURL.deletingLastPathComponent().appending(path: "telemetry_packages"))
    } catch {
        os_log("Error deleting the temporary package directory \(error.localizedDescription)")
    }
}

func compressEvents() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    let packageName = "rc_mac_edr,\(dateFormatter.string(from: Date())).aar"
    
    let fileManager = FileManager.default
    let applicationSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .systemDomainMask).first!
    let urlToSave = applicationSupportURL.appending(path: "com.swiftlydetecting.securityextension").appending(path: "telemetry_packages").appending(path: packageName)
    
    do {
        try FileManager.default.createDirectory(at: urlToSave.deletingLastPathComponent(), withIntermediateDirectories: true)
    } catch {
        os_log("Unable to create completed telemetry packages directory! \(error.localizedDescription)")
    }
    

    guard let writeFileStream = ArchiveByteStream.fileStream(
            path: FilePath(urlToSave)!,
            mode: .writeOnly,
            options: [ .create ],
            permissions: FilePermissions(rawValue: 0o644)) else {
        return
    }
    defer {
        try? writeFileStream.close()
    }
    
    guard let compressStream = ArchiveByteStream.compressionStream(
            using: .lzfse,
            writingTo: writeFileStream) else {
        return
    }
    defer {
        try? compressStream.close()
    }
    guard let encodeStream = ArchiveStream.encodeStream(writingTo: compressStream) else {
        return
    }
    defer {
        try? encodeStream.close()
    }
    
    guard let keySet = ArchiveHeader.FieldKeySet("TYP,PAT,LNK,DEV,DAT,UID,GID,MOD,FLG,MTM,BTM,CTM") else {
        return
    }
    
    // TODO: Here is where we're compressing events
    
    let source = FilePath(telemetryPackageTempURL)!

    do {
        try encodeStream.writeDirectoryContents(
            archiveFrom: source,
            keySet: keySet)
    } catch {
        fatalError("Write directory contents failed.")
    }
}


func getPackagedEvents(with limit: Int) -> String? {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EmittedEvent")
    request.returnsObjectsAsFaults = false
    request.fetchLimit = limit
    let byTimeStamp = NSSortDescriptor(key: "timestamp", ascending: true)
    request.sortDescriptors = [byTimeStamp]
    
    do {
        let emittedEvents = try psc.viewContext.fetch(request) as! [EmittedEvent]
        let eventString: String = emittedEvents.map({ $0.event_json ?? "UNKNOWN" }).joined(separator: "\n")
//        let compressedData = try (eventString.data(using: .utf8)! as NSData).compressed(using: .zlib)
        
        return eventString
    } catch {
        print("Error fetching events from Core Data! \(error.localizedDescription)")
    }
//    return "".data(using: .utf8)! as NSData
    return nil
}


// @note Clears the oldest `events` number of events from the EmittedEvents table.
// @discussion we're not needing to keep track of any additional information. Why?
//             because we're sorting by timestamp and removing only the oldest
//             events for our defined limit.
public func clearLast(events: Int) {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EmittedEvent")
    request.returnsObjectsAsFaults = false
    request.fetchLimit = events
    let byTimeStamp = NSSortDescriptor(key: "timestamp", ascending: true)
    request.sortDescriptors = [byTimeStamp]
    
    // Implement batch deleting here
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
    deleteRequest.resultType = .resultTypeStatusOnly
    
    do {
        _ = try psc.viewContext.execute(deleteRequest)
    } catch {
        os_log("Error batch deleting from Core Data")
    }
}

// @note events live on-disk for a very very short amount of time
public func batchEvent(jsonEvent: String) {
    // TODO: Hook up to the UI
    return
    
//    if jsonEvent.isEmpty {
//        return
//    }
    
    eventEmitCount += 1
    
    psc.viewContext.performAndWait {
        _ = EmittedEvent(fromJSON: jsonEvent, insertIntoManagedObjectContext: psc.viewContext)
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//            let packageName: String =
    let telemetryFileName: String = "rc_mac_edr,\(dateFormatter.string(from: Date())).json"
    
    let fileManager = FileManager.default
    let applicationSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .systemDomainMask).first!
    let urlToSave = applicationSupportURL.appending(path: "com.swiftlydetecting.securityextension").appending(path: "telemetry_package_tmp").appending(path: telemetryFileName)
    
    if eventEmitCount == batchEventLimit {
        let eventString: String = getPackagedEvents(with: batchEventLimit) ?? ""
        do {
            // Once `save()` returns the events are saved to the store
            try psc.viewContext.save()
            
            // We then fetch the events form the store and `.zlib` compress them
//            let compressedTelemetryPackage: NSData = getPackagedEvents(with: batchEventLimit)
            do {
                try FileManager.default.createDirectory(at: urlToSave.deletingLastPathComponent(), withIntermediateDirectories: true)
                
                FileManager.default.createFile(atPath: urlToSave.path,
                                               contents: nil,
                                               attributes: nil)

                guard let destinationFileHandle = try? FileHandle(forWritingTo: urlToSave) else {
                    print("destinationFileHandle fail.")
                    return
                }
                
                destinationFileHandle.write(eventString.data(using: .utf8)!)
                destinationFileHandle.closeFile()
            } catch {
                os_log("Unable to write telemetry package to disk! \(error.localizedDescription)")
            }
            
            // Lastly, delete the selected events
            clearLast(events: batchEventLimit)
        } catch {
            os_log("Encountered an error while saving the batched events to disk \(error.localizedDescription)")
        }
        eventEmitCount = 0
    }
    
    if numberOfFiles(at: urlToSave.deletingLastPathComponent()) == telemetryFilesPerPackage {
        compressEvents()
        // Now we need to delete those files from the temp package
        deleteTempPackage()
    }
    
    if numberOfFiles(at: urlToSave.deletingLastPathComponent().deletingLastPathComponent().appending(path: "telemetry_packages")) == completePackageLimit {
        deleteCompletePakagaes()
    }
}
