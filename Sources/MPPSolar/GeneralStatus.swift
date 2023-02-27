//
//  GeneralStatus.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

/// MPP Solar General Status Parameters
public struct GeneralStatus: Equatable, Hashable, Codable {
    
    /// Grid voltage
    ///
    /// The units is V.
    public let gridVoltage: Float
    
    /// Grid frequency.
    ///
    /// The units is Hz.
    public let gridFrequency: Float
    
    /// AC output voltage
    ///
    /// The units is V.
    public let outputVoltage: Float
    
    /// AC output frequency
    ///
    /// The units is Hz.
    public let outputFrequency: Float
    
    /// AC output apparent power
    ///
    /// The units is VA.
    public let outputApparentPower: UInt
    
    /// AC output active power
    ///
    /// The units is W.
    public let outputActivePower: UInt
    
    /// Output load percent
    ///
    /// The units is %.
    public let outputLoadPercent: UInt
    
    /// BUS voltage
    ///
    /// The units is V.
    public let busVoltage: UInt
    
    /// Battery voltage
    ///
    /// The units is V.
    public let batteryVoltage: Float
    
    /// Battery charging current
    ///
    /// The units is A.
    public let batteryChargingCurrent: UInt
    
    /// Battery capacity
    ///
    /// The units is %.
    public let batteryCapacity: UInt
    
    /// Inverter heat sink temperature
    ///
    /// The units is °C
    public let inverterHeatSinkTemperature: Int
    
    /// PV Input current for battery.
    ///
    /// The units is A.
    public let solarInputCurrent: UInt
    
    /// PV Input voltage
    ///
    /// The units is V.
    public let solarInputVoltage: Float
    
    /// Battery voltage from SCC
    ///
    /// The units is V.
    public let batteryVoltageSCC: Float
    
    /// Battery discharge current
    ///
    /// The units is A.
    public let batteryDischargeCurrent: UInt
    
    public let flags: Flags
}

public extension GeneralStatus {
    
    struct Flags: OptionSet, Equatable, Hashable, Codable {
        
        public var rawValue: UInt8
        
        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }
    }
}

extension GeneralStatus.Flags: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: RawValue) {
        self.init(rawValue: value)
    }
}

extension GeneralStatus.Flags: CaseIterable {
    
    static public let allCases: [GeneralStatus.Flags] = _allCases.keys.sorted(by: { $0.rawValue < $1.rawValue })
}

extension GeneralStatus.Flags: CustomStringConvertible {
    
    public var description: String {
        description(Self._allCases)
    }
    
    internal static var _allCases: [GeneralStatus.Flags: String] {
        [
            .chargingStatusAC: "chargingStatusAC",
            .chargingStatusSCC: "chargingStatusSCC",
            .isCharging: "isCharging",
            .batteryVoltageSteady: "batteryVoltageSteady",
            .isLoadEnabled: "isLoadEnabled",
            .sccFirmareUpdated: "sccFirmareUpdated",
            .configurationChanged: "configurationChanged",
            .addSBUPriorityVersion: "addSBUPriorityVersion"
        ]
    }
}

public extension GeneralStatus.Flags {
    
    /// Charging status (AC charging on/off)
    static var chargingStatusAC: GeneralStatus.Flags        { 0b00000001 }
    
    /// Charging status (SCC charging on/off)
    static var chargingStatusSCC: GeneralStatus.Flags       { 0b00000010 }
    
    /// Charging status (Charging on/off)
    static var isCharging: GeneralStatus.Flags              { 0b00000100 }
    
    /// Battery voltage to steady while charging
    static var batteryVoltageSteady: GeneralStatus.Flags    { 0b00001000 }
    
    /// Load status
    static var isLoadEnabled: GeneralStatus.Flags           { 0b00010000 }
    
    /// Whether SCC firmware version updated
    static var sccFirmareUpdated: GeneralStatus.Flags       { 0b00100000 }
    
    /// Whether configuration changed
    static var configurationChanged: GeneralStatus.Flags    { 0b01000000 }
    
    /// Add SBU priority version
    static var addSBUPriorityVersion: GeneralStatus.Flags   { 0b10000000 }
}

// MARK: - Command

public extension GeneralStatus {
    
    /// Device general status parameters Inquiry
    struct Query: QueryCommand, CustomStringConvertible {
        
        public typealias Response = GeneralStatus
            
        public static var commandType: CommandType { .query(.generalStatus) }
        
        public init() { }
    }
}

// MARK: - Response

extension GeneralStatus: ResponseProtocol {
    
    public init?(response: String) {
        // (BBB.B CC.C DDD.D EE.E FFFF GGGG HHH III JJ.JJ KKK OOO TTTT EEEE UUU.U WW.WW PPPPP b7b6b5b4b3b2b1b0<CRC><cr>
        let decoder = MPPSolarDecoder(rawValue: response)
        try? self.init(from: decoder)
    }
}
