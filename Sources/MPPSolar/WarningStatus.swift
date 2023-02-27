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
            .busSoftFail: "busSoftFail",
            .lineFail: "lineFail",
            
        ]
    }
}

public extension WarningStatus {
    
    internal static var reserved0: WarningStatus    { 1 }
    
    /// Inverter fault
    static var inverterFault: WarningStatus         { WarningStatus(1 << 1) }
    
    /// Bus Over
    static var busOver: WarningStatus               { WarningStatus(1 << 2) }
    
    /// Bus Under
    static var busUnder: WarningStatus              { WarningStatus(1 << 3) }
    
    /// Bus Soft Fail
    static var busSoftFail: WarningStatus            { WarningStatus(1 << 4) }
    
    /// Line Fail
    static var lineFail: WarningStatus               { WarningStatus(1 << 5) }
    /* TODO:
    static var busOver: WarningStatus               { WarningStatus(1 << 6) }
    
    static var busOver: WarningStatus               { WarningStatus(1 << 7) }
    
    static var busOver: WarningStatus               { WarningStatus(1 << 8) }
    
    static var busOver: WarningStatus               { WarningStatus(1 << 9) }
    
    static var busOver: WarningStatus               { WarningStatus(1 << 10) }
    
    static var busOver: WarningStatus               { WarningStatus(1 << 11) }
    
    static var busOver: WarningStatus               { WarningStatus(1 << 12) }*/
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
