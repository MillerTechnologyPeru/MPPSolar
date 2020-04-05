//
//  File.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

/// MPP Solar General Status Parameters
public struct GeneralStatus: Equatable, Hashable {
    
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
    
    /// Device status
    //public let
}


// MARK: - Command

public extension GeneralStatus {
    
    /// Device general status parameters Inquiry
    struct Inquiry: InquiryCommand, CustomStringConvertible {
        
        public typealias Response = GeneralStatus
            
        public static var commandType: CommandType { .inquiry(.generalStatus) }
        
        public init() { }
    }
}

// MARK: - Response

extension GeneralStatus: ResponseProtocol {
    
    public init?(rawValue: String) {
        // (BBB.B CC.C DDD.D EE.E FFFF GGGG HHH III JJ.JJ KKK OOO TTTT EEEE UUU.U WW.WW PPPPP b7b6b5b4b3b2b1b0<CRC><cr>
        let components = rawValue.components(separatedBy: " ")
        guard components.count >= 17,
            let gridVoltage = Float(components[0]),
            let gridFrequency = Float(components[1]),
            let outputVoltage = Float(components[2]),
            let outputFrequency = Float(components[3]),
            let outputApparentPower = UInt(components[4]),
            let outputActivePower = UInt(components[5]),
            let outputLoadPercent = UInt(components[6]),
            let busVoltage = UInt(components[7]),
            let batteryVoltage = Float(components[8]),
            let batteryChargingCurrent = UInt(components[9]),
            let batteryCapacity = UInt(components[10]),
            let inverterHeatSinkTemperature = Int(components[11]),
            let solarInputCurrent = UInt(components[12]),
            let solarInputVoltage = Float(components[13]),
            let batteryVoltageSCC = Float(components[14]),
            let batteryDischargeCurrent = UInt(components[15])
            // TODO: Flags
            else { return nil }
        
        self.gridVoltage = gridVoltage
        self.gridFrequency = gridFrequency
        self.outputVoltage = outputVoltage
        self.outputFrequency = outputFrequency
        self.outputApparentPower = outputApparentPower
        self.outputActivePower = outputActivePower
        self.outputLoadPercent = outputLoadPercent
        self.busVoltage = busVoltage
        self.batteryVoltage = batteryVoltage
        self.batteryChargingCurrent = batteryChargingCurrent
        self.batteryCapacity = batteryCapacity
        self.inverterHeatSinkTemperature = inverterHeatSinkTemperature
        self.solarInputCurrent = solarInputCurrent
        self.solarInputVoltage = solarInputVoltage
        self.batteryVoltageSCC = batteryVoltageSCC
        self.batteryDischargeCurrent = batteryDischargeCurrent
    }
}
