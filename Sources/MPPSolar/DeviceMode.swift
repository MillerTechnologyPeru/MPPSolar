//
//  DeviceMode.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

/// MPP Solar Device Mode
public enum DeviceMode: String {
    
    /// Power On Mode
    case powerOn        = "P"
    
    /// Standby Mode
    case standby        = "S"
    
    /// Line Mode
    case line           = "L"
    
    /// Battery Mode
    case battery        = "B"
    
    /// Fault Mode
    case fault          = "F"
    
    /// Power saving Mode
    case powerSaving    = "H"
}

// MARK: - Command

public struct DeviceModeInquiry: Command, Equatable, Hashable {
    
    
    
    public init() {
        
    }
    
    public let checksum: Checksum
}
