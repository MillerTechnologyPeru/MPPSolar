//
//  CommandType.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

/// MPP Solar Command Type
public enum CommandType: Equatable, Hashable {
    
    case query(Query)
    case setting(Setting)
}

// MARK: - RawRepresentable

extension CommandType: RawRepresentable {
    
    public init?(rawValue: String) {
        if let query = Query(rawValue: rawValue) {
            self = .query(query)
        } else if let setting = Setting(rawValue: rawValue) {
            self = .setting(setting)
        } else {
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case let .query(value): return value.rawValue
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
    
    enum Query: String {
        
        /// Device Protocol ID Inquiry
        case protocolID                 = "QPI"
        
        /// Device serial number inquiry
        case serialNumber               = "QID"
        
        /// Main CPU Firmware version inquiry
        case firmwareVersion            = "QVFW"
        
        /// Secondary CPU Firmware version inquiry
        case firmwareVersion2           = "QVFW2"
        
        /// Device Rating Information inquiry
        case ratingInformation          = "QPIRI"
        
        /// Device flag status inquiry
        case flagStatus                 = "QFLAG"
        
        /// Device general status parameters inquiry
        case generalStatus              = "QPIGS"
        
        /// Device Mode inquiry
        case mode                       = "QMOD"
        
        /// Device Warning Status inquiry
        case warningStatus              = "QPIWS"
        
        /// Default Setting Value Information inquiry
        case defaultSetting             = "QDI"
        
        /// Selectable value about max charging current inquiry
        case maxChargingCurrent         = "QMCHGCR"
        
        /// Selectable value about max utility charging current inquiry
        case maxUtilityChargingCurrent  = "QMUCHGCR"
        
        /// DSP has bootstrap or not inquiry
        case dspBootstrap               = "QBOOT"
        
        /// Output Mode
        case outputMode                 = "QOPM"
    }
}

public extension CommandType {
    
    enum Setting: String {
        
        /// Enable parameter
        case flagEnable         = "PE"
        
        /// Setting control parameter to default value
        case reset              = "PF"
        
        /// Setting device output rating frequency
        case frequency          = "F"
        
        // TODO: Complete all
    }
}
