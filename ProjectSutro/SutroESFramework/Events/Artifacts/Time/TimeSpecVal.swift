//
//  TimeSpecVal.swift
//  SutroESFramework
//
//  Created by Brandon Dalton on 3/16/25.
//

import Foundation


/// Description: represents a simple calendar time, or an elapsed time, with sub-second resolution.
/// https://www.gnu.org/software/libc/manual/html_node/Time-Types.html
// Ensure TimeSpec conforms to Codable and Equatable
public struct TimeSpec: Identifiable, Codable, Equatable, Hashable {
    public var id = UUID()
    
    public var tv_sec, tv_nsec: Int
    
    public init(from spec: Darwin.timespec) {
        self.tv_sec = spec.tv_sec
        self.tv_nsec = spec.tv_nsec
    }
    
    /// Returns the time as an ISO 8601 formatted string with nanosecond precision.
    public func humanFormat() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(tv_sec))
        let nanoseconds = String(format: "%09d", tv_nsec)
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let baseString = formatter.string(from: date)
        return baseString.replacingOccurrences(of: "Z", with: ".\(nanoseconds)Z")
    }
}

/// An older type for representing a simple calendar time, or an elapsed time, with sub-second resolution. It is almost the same as struct timespec, but provides only microsecond resolution.
/// https://www.gnu.org/software/libc/manual/html_node/Time-Types.html
// Ensure TimeVal conforms to Codable and Equatable
public struct TimeVal: Identifiable, Codable, Equatable, Hashable {
    public var id = UUID()
    
    public var tv_sec, tv_usec: Int
    
    public init(from val: Darwin.timeval) {
        self.tv_sec = val.tv_sec
        self.tv_usec = Int(val.tv_usec)
    }
    
    /// Returns the time as an ISO 8601 formatted string with microsecond precision.
    public func humanFormat() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(tv_sec))
        let microseconds = String(format: "%06d", tv_usec) // Ensures 6-digit microsecond precision
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let baseString = formatter.string(from: date)
        return baseString.replacingOccurrences(of: "Z", with: ".\(microseconds)Z")
    }
}
