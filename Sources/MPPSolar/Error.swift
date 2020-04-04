//
//  Error.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation

/// MPP Solar Error
public enum MPPSolarError: Error {
    
    case invalidChecksum(expected: Checksum, invalid: Checksum)
    case invalidResponse(Data)
}
