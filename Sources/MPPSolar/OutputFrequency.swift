//
//  OutputFrequency.swift
//  
//
//  Created by Alsey Coleman Miller on 7/27/20.
//

/// Set UPS output rating frequency to 50Hz or 60Hz.
public enum OutputFrequency: UInt {
    
    /// 50Hz
    case hz50 = 50
    
    ///60 Hz
    case hz60 = 60
}

extension OutputFrequency: CustomStringConvertible {
    
    public var description: String {
        return rawValue.description + "Hz"
    }
}

public extension OutputFrequency {
    
    struct Setting: SettingCommand, Equatable, Hashable {
        
        public typealias Response = Acknowledgement
        
        public static var commandType: CommandType { return .setting(.frequency) }
        
        public var frequency: OutputFrequency
        
        public init(frequency: OutputFrequency) {
            self.frequency = frequency
        }
        
        public var rawValue: String {
            return "\(frequency.rawValue)"
        }
    }
}
