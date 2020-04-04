//
//  File.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation

/// MPP Solar Response
public protocol ResponseProtocol {
    
    init?(data: Data)
}

internal extension ResponseProtocol {
    
    static func parse(_ data: Data) -> (response: Self, checksum: Checksum)? {
        guard data.count > 2,
            let response = Self.init(data: data.subdataNoCopy(in: 0 ..< data.count - 2)),
            let checksum = Checksum(data: data.subdataNoCopy(in: data.count - 2 ..< data.count))
            else { return nil }
        return (response, checksum)
    }
}
