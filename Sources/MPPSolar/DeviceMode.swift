//
//  DeviceMode.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation

/// MPP Solar Device Mode
public enum DeviceMode: String {
    
    /// Power On Mode
    case powerOn        = "P"
    
    /// Standby Mode
    case standby        = "S"
    
    /// Line Mode
    case line           = "L"
    
    /// Battery Mode
    case battery        = "B"
    
    /// Fault Mode
    case fault          = "F"
    
    /// Power saving Mode
    case powerSaving    = "H"
}

// MARK: - Command

public struct DeviceModeInquiry: InquiryCommand {
        
    public static var commandType: CommandType { .inquiry(.mode) }
    
    public init() { }
}

// MARK: - Response

public extension DeviceModeInquiry {
    
    struct Response: ResponseProtocol, Equatable, Hashable {
        
        public let mode: DeviceMode
        
        public init?(data: Data) {
            guard data.count == 1,
                let string = String(data: data, encoding: .utf8),
                let mode = DeviceMode(rawValue: string)
                else { return nil }
            self.mode = mode
        }
    }
}
