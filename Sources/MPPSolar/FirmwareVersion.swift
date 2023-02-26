//
//  FirmwareVersion.swift
//  
//
//  Created by Alsey Coleman Miller on 2/25/23.
//

import Foundation

/// Firmware Version
public struct FirmwareVersion: Equatable, Hashable, Codable {
    
    public let series: UInt32
    
    public let version: UInt8
    
    public init(series: UInt32 = 0, version: UInt8 = 0) {
        //precondition(UInt32(series.toHexadecimal().suffix(5)) == series)
        self.series = series
        self.version = version
    }
}

// MARK: - RawRepresentable

extension FirmwareVersion: RawRepresentable {
    
    public init?(rawValue: String) {
        self.init(rawValue)
    }
    
    internal init?<S>(_ string: S) where S: StringProtocol {
        let components = string.split(separator: ".")
        guard components.count == 2,
              components[0].count == 5,
              components[1].count == 2,
              let series = UInt32(components[0], radix: 16),
              let version = UInt8(components[1], radix: 16)
              //UInt32(series.toHexadecimal().suffix(5)) == series
            else { return nil }
        self.init(series: series, version: version)
    }
    
    public var rawValue: String {
        series.toHexadecimal().suffix(5) + "." + version.toHexadecimal()
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
            guard rawValue.hasPrefix(Self.prefix),
                  let version = FirmwareVersion(rawValue.suffix(from: rawValue.index(rawValue.startIndex, offsetBy: Self.prefix.count)))
                else { return nil }
            self.version = version
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
            guard rawValue.hasPrefix(Self.prefix),
                  let version = FirmwareVersion(rawValue.suffix(from: rawValue.index(rawValue.startIndex, offsetBy: Self.prefix.count)))
                else { return nil }
            self.version = version
        }
    }
}
