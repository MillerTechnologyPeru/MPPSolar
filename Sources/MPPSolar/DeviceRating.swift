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
    
    // TODO: add more properties
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
        let decoder = MPPSolarDecoder(rawValue: response)
        try? self.init(from: decoder)
    }
}
