//
//  WarningStatus.swift
//  
//
//  Created by Alsey Coleman Miller on 2/27/23.
//

/// Device Warning Status
public struct WarningStatus: OptionSet, Equatable, Hashable, Codable {
    
    public var rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    private init(_ raw: UInt32) {
        self.init(rawValue: raw)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension WarningStatus: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: RawValue) {
        self.init(rawValue: value)
    }
}

// MARK: - CaseIterable

extension WarningStatus: CaseIterable {
    
    static public let allCases: [WarningStatus] = _allCases.keys.sorted(by: { $0.rawValue < $1.rawValue })
}

// MARK: - CustomStringConvertible

extension WarningStatus: CustomStringConvertible {
    
    public var description: String {
        description(Self._allCases)
    }
}

// MARK: - Definitions

internal extension WarningStatus {
    
    static var _allCases: [WarningStatus: String] {
        [
            .reserved0: "reserved",
            .inverterFault: "inverterFault",
            .busOver: "busOver",
            .busUnder: "busUnder",
            .busSoft: "busSoft",
            .line: "line",
            .opvShort: "opvShort",
            
        ]
    }
}

public extension WarningStatus {
    
    internal static var reserved0: WarningStatus        { 1 }
    
    /// Inverter fault
    static var inverterFault: WarningStatus             { WarningStatus(1 << 1) }
    
    /// Bus Over
    static var busOver: WarningStatus                   { WarningStatus(1 << 2) }
    
    /// Bus Under
    static var busUnder: WarningStatus                  { WarningStatus(1 << 3) }
    
    /// Bus Soft Fail
    static var busSoft: WarningStatus                   { WarningStatus(1 << 4) }
    
    /// Line Fail
    static var line: WarningStatus                      { WarningStatus(1 << 5) }
    
    /// OPV Short
    static var opvShort: WarningStatus                  { WarningStatus(1 << 6) }
    
    /// Inverter voltage too low
    static var inverterVoltageLow: WarningStatus        { WarningStatus(1 << 7) }
    
    /// Inverter voltage too high
    static var inverterVoltageHigh: WarningStatus       { WarningStatus(1 << 8) }
    
    /// Over temperature
    static var overTemperature: WarningStatus           { WarningStatus(1 << 9) }
    
    /// Fan locked
    static var fanLocked: WarningStatus                 { WarningStatus(1 << 10) }
    
    /// Battery voltage high
    static var batteryVoltageHigh: WarningStatus        { WarningStatus(1 << 11) }
    
    /// Battery low alarm
    static var batteryLowAlarm: WarningStatus           { WarningStatus(1 << 12) }
    
    /// Reserved
    internal static var reserved13: WarningStatus       { WarningStatus(1 << 13) }
    
    /// Battery under shutdown
    static var batteryShutdown: WarningStatus           { WarningStatus(1 << 14) }
    
    /// Reserved
    internal static var reserved15: WarningStatus       { WarningStatus(1 << 15) }
    
    /// Over load
    static var overload: WarningStatus                  { WarningStatus(1 << 16) }
    
    /// Eeprom fault
    static var eeprom: WarningStatus                    { WarningStatus(1 << 17) }
    
    /// Inverter Over Current
    static var inverterOverCurrent: WarningStatus       { WarningStatus(1 << 18) }
    
    /// Inverter Soft Fail
    static var inverterSoft: WarningStatus              { WarningStatus(1 << 19) }
    
    /// Self Test Fail
    static var selfTest: WarningStatus                  { WarningStatus(1 << 20) }
    
    /// OP DC Voltage Over
    static var opDCVoltageOver: WarningStatus           { WarningStatus(1 << 21) }
    
    /// Bat Open
    static var batOpen: WarningStatus                   { WarningStatus(1 << 22) }
    
    /// Current Sensor Fail
    static var currentSensor: WarningStatus             { WarningStatus(1 << 23) }
    
    /// Battery Short
    static var batteryShort: WarningStatus              { WarningStatus(1 << 24) }
    
    /// Power limit
    static var powerLimit: WarningStatus                { WarningStatus(1 << 25) }
    
    /// PV voltage high
    static var pvVoltageHigh: WarningStatus             { WarningStatus(1 << 26) }
    
    /// MPPT overload fault
    static var mpptOverloadFault: WarningStatus         { WarningStatus(1 << 27) }
    
    /// MPPT overload warning
    static var mpptOverloadWarning: WarningStatus       { WarningStatus(1 << 28) }
    
    /// Battery too low to charge
    static var batteryLowCharge: WarningStatus          { WarningStatus(1 << 29) }
    
    /// Reserved
    internal static var reserved30: WarningStatus       { WarningStatus(1 << 30) }
    
    /// Reserved
    internal static var reserved31: WarningStatus       { WarningStatus(1 << 31) }
}


// MARK: - Command

public extension WarningStatus {
    
    /// Device Warning Status query
    struct Query: QueryCommand, CustomStringConvertible {
        
        public typealias Response = WarningStatus
            
        public static var commandType: CommandType { .query(.warningStatus) }
        
        public init() { }
    }
}

// MARK: - Response

/*
 Computer: QPIWS<CRC> <cr>
 Device: (a0a1.....a30a31<CRC><cr>
 a0,...,a31 is the warning status. If the warning is happened, the relevant bit will set 1, else the
 relevant bit will set 0. The following table is the warning code.
 */
extension WarningStatus: ResponseProtocol { }
