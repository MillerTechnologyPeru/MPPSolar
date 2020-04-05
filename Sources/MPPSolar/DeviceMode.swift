//
//  DeviceMode.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

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

public extension DeviceMode {
    
    struct Inquiry: InquiryCommand, CustomStringConvertible {
        
        public static var commandType: CommandType { .inquiry(.mode) } // QMOD<CRC><cr>
        
        public init() { }
    }
}

// MARK: - Response

public extension DeviceMode.Inquiry {
    
    struct Response: ResponseProtocol, Equatable, Hashable {
        
        public let mode: DeviceMode
        
        public init?(rawValue: String) {
            guard let mode = DeviceMode(rawValue: rawValue)
                else { return nil }
            self.mode = mode
        }
    }
}
