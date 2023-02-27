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
