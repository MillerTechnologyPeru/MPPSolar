//
//  OutputMode.swift
//  
//
//  Created by Alsey Coleman Miller on 2/27/23.
//

/// Output Mode
public enum OutputMode: UInt8, Codable, CaseIterable {
    
    /// Single machine output
    case singleMachine      = 0
    
    /// Parallel output
    case parallel           = 1
    
    /// Phase 1 of 3 Phase output
    case phase1             = 2
    
    /// Phase 2 of 3 Phase output
    case phase2             = 3
    
    /// Phase 3 of 3 Phase output
    case phase3             = 4
}

// MARK: - CustomStringConvertible

extension OutputMode: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .singleMachine:
            return "Single Machine"
        case .parallel:
            return "Parallel"
        case .phase1:
            return "Phase 1 of 3"
        case .phase2:
            return "Phase 2 of 3"
        case .phase3:
            return "Phase 3 of 3"
        }
    }
}
