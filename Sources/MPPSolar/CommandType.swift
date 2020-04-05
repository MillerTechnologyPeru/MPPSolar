//
//  File.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

/// MPP Solar Command Type
public enum CommandType: Equatable, Hashable {
    
    case inquiry(Inquiry)
    case setting(Setting)
}

// MARK: - RawRepresentable

extension CommandType: RawRepresentable {
    
    public init?(rawValue: String) {
        if let inquiry = Inquiry(rawValue: rawValue) {
            self = .inquiry(inquiry)
        } else if let setting = Setting(rawValue: rawValue) {
            self = .setting(setting)
        } else {
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case let .inquiry(value): return value.rawValue
        case let .setting(value): return value.rawValue
        }
    }
}

// MARK: - CustomStringConvertible

extension CommandType: CustomStringConvertible {
    
    public var description: String {
        return rawValue
    }
}

// MARK: - Supporting Types

public extension CommandType {
    
    enum Inquiry: String {
        
        /// Device Protocol ID Inquiry
        case protocolID         = "QPI"
        
        /// Device serial number inquiry
        case serialNumber       = "QID"
        
        /// Main CPU Firmware version inquiry
        case firmwareVersion1   = "QVFW"
        
        /// Secondary CPU Firmware version inquiry
        case firmwareVersion2   = "QVFW2"
        
        /// Device Rating Information inquiry
        case ratingInformation  = "QPIRI"
        
        /// Device flag status inquiry
        case flagStatus         = "QFLAG"
        
        /// Device general status parameters inquiry
        case generalStatus      = "QPIGS"
        
        /// Device Mode inquiry
        case mode               = "QMOD"
        
        /// Device Warning Status inquiry
        case warningStatus      = "QPIWS"
        
        // TODO: Complete all
    }
}

public extension CommandType {
    
    enum Setting: String {
        
        /// Enable parameter
        case enable             = "PE"
        
        /// Disable parameter
        case disable            = "PD"
        
        /// Setting control parameter to default value
        case reset              = "PF"
        
        /// Setting device output rating frequency
        case frequency          = "F"
        
        // TODO: Complete all
    }
}
