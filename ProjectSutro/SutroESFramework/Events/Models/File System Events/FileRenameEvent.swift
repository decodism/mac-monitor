//
//  FileRenameEvent.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 2/17/23.
//

import Foundation
import EndpointSecurity
import OSLog


// @note this function performs a deep search of a directory to include resource forks and the like.
func deepSearch(directoryPath: String) -> [String] {
    var filePaths = [String]()
    let dir = opendir(directoryPath)
    
    guard dir != nil else {
        os_log("Error enumerating \(directoryPath)")
        return []
    }
    
    defer {
        closedir(dir)
    }
    
    while let entry = readdir(dir) {
        let fileName = withUnsafePointer(to: &entry.pointee.d_name) { ptr in
            return ptr.withMemoryRebound(to: CChar.self, capacity: Int(entry.pointee.d_namlen)) {
                return String(cString: $0)
            }
        }
        
        if fileName != "." && fileName != ".." {
            let filePath = "\(directoryPath)/\(fileName)"
            filePaths.append(filePath)
        }
    }
    
    return filePaths
}


// https://developer.apple.com/documentation/endpointsecurity/es_event_rename_t
public struct FileRenameEvent: Identifiable, Codable, Hashable {
    public var id: UUID = UUID()
    
    public var destination_path, source_path, file_name, type: String?
    public var archive_files_not_quarantined: String?
    public var is_quarantined: Int16
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(source_path)
        hasher.combine(destination_path)
    }
    
    public static func == (lhs: FileRenameEvent, rhs: FileRenameEvent) -> Bool {
        if lhs.destination_path == rhs.destination_path && lhs.source_path == rhs.source_path {
            return true
        }
        
        return false
    }
    
    // @note files_not_quarantined should be a list of sub paths
    init(from rawMessage: UnsafePointer<es_message_t>, files_not_quarantined: [String] = []) {
        let fileRenameEvent: es_event_rename_t = rawMessage.pointee.event.rename
        
        self.source_path = String(cString: fileRenameEvent.source.pointee.path.data)
        if fileRenameEvent.destination_type == ES_DESTINATION_TYPE_EXISTING_FILE {
            self.type = "EXISTING_FILE"
            self.destination_path = String(cString: fileRenameEvent.destination.existing_file.pointee.path.data)
            self.file_name = NSURL(fileURLWithPath: String(cString: fileRenameEvent.destination.existing_file.pointee.path.data)).lastPathComponent
            self.is_quarantined = Int16(ProcessHelpers.isFileQuarantined(filePath: String(cString: fileRenameEvent.destination.existing_file.pointee.path.data)))
        } else {
            self.type = "NEW_PATH"
            self.destination_path = String(cString: fileRenameEvent.destination.new_path.dir.pointee.path.data)
            self.file_name = String(cString: fileRenameEvent.destination.new_path.filename.data)
            self.is_quarantined = Int16(ProcessHelpers.isFileQuarantined(filePath: "\(String(cString: fileRenameEvent.destination.existing_file.pointee.path.data))/\(String(cString: fileRenameEvent.destination.new_path.filename.data))"))
        }
        
        
        // MARK: - File Quarantine bypass checks
        var fullUnQuarantinedPaths: [String] = []
        // @note check if the top level is quarantined. If so the rest should be as well.
        let homeDir: String = String(FileManager.default.consoleUserHome!.absoluteString.trimmingPrefix("file://"))
        let libHomeDir: String = String(FileManager.default.consoleUserHome!.appending(path: "Library").absoluteString.trimmingPrefix("file://"))
        if destination_path!.hasPrefix(homeDir) && !destination_path!.hasPrefix(libHomeDir) {
            // Check if the source path came from `com.apple.desktopservices.ArchiveService` meanining the rename was likely the result of an unarchive operation.
            if source_path!.contains("com.apple.desktopservices.ArchiveService") {
                let topLevel: URL = URL(filePath: self.destination_path!).appending(path: self.file_name!)
                if topLevel.isDirectory {
                    if self.is_quarantined == 1 {
                        //                os_log("[DOWNLOAD DIRECTORY] IS Quarantined!")
                        for file in deepSearch(directoryPath: self.destination_path!.appending("/\(self.file_name!)")) {
                            //                    os_log("Checking file............. \(file)")
                            // Check if file is quarantined.
                            if ProcessHelpers.isFileQuarantined(filePath: String(file.trimmingPrefix("file://"))) == 0 {
                                //                        os_log("[DETECTION] File Quarantine violation! ===> \(file)")
                                fullUnQuarantinedPaths.append(file)
                            }
                        }
                    }
                }
            }
            
        }
        
        self.archive_files_not_quarantined = fullUnQuarantinedPaths.joined(separator: "[::]")
    }
}
