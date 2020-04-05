//
//  Error.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation

/// MPP Solar Error
public enum MPPSolarError: Error {
    
    case timeout
    case invalidChecksum(Checksum, expected: Checksum)
    case invalidResponse(Data)
}
