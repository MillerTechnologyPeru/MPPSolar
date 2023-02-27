//
//  DeviceRating.swift
//  
//
//  Created by Alsey Coleman Miller on 2/27/23.
//

/// Device Rating Information
public struct DeviceRating: Equatable, Hashable, Codable {
    
    /// Grid rating voltage
    ///
    /// The units is V.
    public let gridRatingVoltage: Float
    
    /// Grid rating current
    ///
    /// The units is A.
    public let gridRatingCurrent: Float
    
    /// AC output rating voltage
    ///
    /// The units is V.
    public let outputRatingVoltage: Float
    
    /// AC output rating frequency
    ///
    /// The units is Hz.
    public let outputRatingFrequency: Float
    
    /// AC output rating current
    ///
    /// The units is A.
    public let outputRatingCurrent: Float
    
    /// AC output rating apparent power
    ///
    /// The unit is VA.
    public let outputRatingApparentPower: UInt
    
    /// AC output rating active power
    ///
    /// The unit is W.
    public let outputRatingActivePower: UInt
    
    /// Battery rating voltage
    ///
    /// The units is V.
    public let batteryRatingVoltage: Float
    
    /// Battery re-charge voltage
    ///
    /// The units is V.
    public let batteryRechargeVoltage: Float
    
    /// Battery under voltage
    ///
    /// The units is V.
    public let batteryUnderVoltage: Float
    
    /// Battery bulk voltage
    ///
    /// The units is V.
    public let batteryBulkVoltage: Float
    
    /// Battery float voltage
    ///
    /// The units is V.
    public let batteryFloatVoltage: Float
    
    /// Battery type
    public let batteryType: BatteryType
    
    /// Current max AC charging current
    ///
    /// The units is A.
    public let maxChargingCurrentAC: UInt
    
    /// Current max charging current
    ///
    /// The units is A.
    public let maxChargingCurrent: UInt
    
    /// Input voltage range
    public let inputVoltageRange: InputVoltageRange
    
    /// Output source priority
    public let outputSourcePriority: OutputSourcePriority
    
    /// Charger source priority
    public let chargerSourcePriority: ChargerSourcePriority
    
    /// Parallel max number
    public let maxParallel: UInt8
    
    /// Machine type
    public let machineType: MachineType
    
    /// Has transformer
    public let topology: Bool
    
    /// Output mode
    public let outputMode: OutputMode
    
    // TODO: add more properties
}

// MARK: - Supporting Types

public extension DeviceRating {
    
    enum BatteryType: UInt8, Codable, CaseIterable {
        
        case agm        = 0
        case flooded    = 1
        case user       = 2
    }
}

extension DeviceRating.BatteryType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .agm: return "AGM"
        case .flooded: return "Flooded"
        case .user: return "User"
        }
    }
}

public extension DeviceRating {
    
    enum InputVoltageRange: UInt8, Codable, CaseIterable {
        
        /// Appliance
        case appliance  = 0
        
        /// UPS
        case ups        = 1
    }
}

extension DeviceRating.InputVoltageRange: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .appliance: return "Appliance"
        case .ups: return "UPS"
        }
    }
}

public extension DeviceRating {
    
    enum OutputSourcePriority: UInt8, Codable, CaseIterable {
        
        /// Utility first
        case utility    = 0
        
        /// Solar first
        case solar      = 1
        
        /// SBU first
        case sbu        = 2
    }
}

extension DeviceRating.OutputSourcePriority: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .utility: return "Utility"
        case .solar: return "Solar"
        case .sbu: return "SBU"
        }
    }
}

public extension DeviceRating {
    
    enum ChargerSourcePriority: UInt8, Codable, CaseIterable {
        
        /// Utility first
        case utilityFirst   = 0
        
        /// Solar first
        case solarFirst     = 1
        
        /// Solar + Utility
        case solarUtility   = 2
        
        /// Only solar charging permitted
        case solarOnly      = 3
    }
}

extension DeviceRating.ChargerSourcePriority: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .utilityFirst: return "Utility first"
        case .solarFirst: return "Solar first"
        case .solarUtility: return "Solar + Utility"
        case .solarOnly: return "Solar only"
        }
    }
}

// MARK: - Command

public extension DeviceRating {
    
    /// Device Rating Information inquiry
    struct Query: QueryCommand, CustomStringConvertible {
        
        public typealias Response = GeneralStatus
            
        public static var commandType: CommandType { .query(.ratingInformation) }
        
        public init() { }
    }
}

// MARK: - Response

extension DeviceRating: ResponseProtocol {
    
    public init?(response: String) {
        /*
         Computer: QPIRI<CRC><cr>
         Device: (BBB.B CC.C DDD.D EE.E FF.F HHHH IIII JJ.J KK.K JJ.J KK.K LL.L O PP QQ0 O P Q R SS T U VV.V W X<CRC><cr>
         */
        try? self.init(response: response, log: nil)
    }
    
    internal init(response: String, log: ((String) -> ())?) throws {
        let decoder = MPPSolarDecoder(rawValue: response, log: log)
        try self.init(from: decoder)
    }
}
