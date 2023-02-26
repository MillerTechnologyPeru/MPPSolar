//
//  DeviceMode.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

/// MPP Solar Device Mode
public enum DeviceMode: String, Codable, CaseIterable {
    
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

// MARK: - CustomStringConvertible

extension DeviceMode: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .powerOn: return "Power On"
        case .standby: return "Standby"
        case .line: return "Line"
        case .battery: return "Battery"
        case .fault: return "Fault"
        case .powerSaving: return "Power Saving"
        }
    }
}

// MARK: - Command

public extension DeviceMode {
    
    struct Query: QueryCommand, CustomStringConvertible {
        
        public static var commandType: CommandType { .query(.mode) } // QMOD<CRC><cr>
        
        public init() { }
    }
}

// MARK: - Response

public extension DeviceMode.Query {
    
    struct Response: ResponseProtocol, Equatable, Hashable, Codable {
        
        public let mode: DeviceMode
        
        public init?(rawValue: String) {
            guard let mode = DeviceMode(rawValue: rawValue)
                else { return nil }
            self.mode = mode
        }
    }
}
