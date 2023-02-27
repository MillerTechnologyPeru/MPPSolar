//
//  MachineType.swift
//  
//
//  Created by Alsey Coleman Miller on 2/27/23.
//

/// Machine Type
public enum MachineType: UInt8, Codable, CaseIterable {
    
    /// Grid tie
    case gridTie    = 0b00
    
    /// Off Grid
    case offGrid    = 0b01
    
    /// Hybrid
    case hybrid     = 0b10
}

// MARK: - CustomStringConvertible

extension MachineType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .gridTie:
            return "Grid Tie"
        case .offGrid:
            return "Off Grid"
        case .hybrid:
            return "Hybrid"
        }
    }
}

// MARK: - MPPSolarDecodable

extension MachineType: MPPSolarDecodable {
    
    public init(from solar: String.SubSequence, codingPath: [CodingKey]) throws {
        guard let rawValue = UInt8(solar, radix: 2), let value = MachineType.init(rawValue: rawValue) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode \(Self.self) from \"\(solar)\"."))
        }
        self = value
    }
}
