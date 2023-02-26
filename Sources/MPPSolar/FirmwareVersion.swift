//
//  FirmwareVersion.swift
//  
//
//  Created by Alsey Coleman Miller on 2/25/23.
//

import Foundation

/// Firmware Version
public struct FirmwareVersion: RawRepresentable, Equatable, Hashable, Codable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - CustomStringConvertible

extension FirmwareVersion: CustomStringConvertible {
    
    public var description: String {
        return rawValue
    }
}

// MARK: - Command

public extension FirmwareVersion {
    
    /// Main CPU Firmware Version query
    struct Query: QueryCommand, CustomStringConvertible {
            
        public static var commandType: CommandType { .query(.firmwareVersion) }
        
        public init() { }
    }
}

public extension FirmwareVersion.Query {
    
    /// Secondary CPU Firmware Version query
    struct Secondary: QueryCommand, CustomStringConvertible {
            
        public static var commandType: CommandType { .query(.firmwareVersion2) }
        
        public init() { }
    }
}

// MARK: - Response

public extension FirmwareVersion.Query {
    
    /// Device Protocol ID Inquiry Response
    struct Response: ResponseProtocol, Equatable, Hashable, Codable {
        
        internal static var prefix: String { "VERFW:" }
        
        public let version: FirmwareVersion
        
        public init?(rawValue: String) {
            // (VERFW:00123.01<CRC><cr>
            guard rawValue.hasPrefix(Self.prefix)
                else { return nil }
            let version = String(rawValue.suffix(from: rawValue.index(rawValue.startIndex, offsetBy: Self.prefix.count)))
            self.version = FirmwareVersion(rawValue: version)
        }
    }
}

public extension FirmwareVersion.Query.Secondary {
    
    /// Secondary CPU Firmware Version Response
    struct Response: ResponseProtocol, Equatable, Hashable, Codable {
        
        internal static var prefix: String { "VERFW2:" }
        
        public let version: FirmwareVersion
        
        public init?(rawValue: String) {
            // (VERFW2:00123.01<CRC><cr>
            guard rawValue.hasPrefix(Self.prefix)
                else { return nil }
            let version = String(rawValue.suffix(from: rawValue.index(rawValue.startIndex, offsetBy: Self.prefix.count)))
            self.version = FirmwareVersion(rawValue: version)
        }
    }
}
