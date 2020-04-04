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
    
    static func parse(_ data: Data) -> (Self, Checksum, Checksum)? {
        guard data.count > 3
            else { return nil }
        let prefix = data.prefix(while: { $0 != "\r".utf8.first })
        let responseData = prefix.subdataNoCopy(in: 0 ..< prefix.count - 2)
        let checksumData = prefix.subdataNoCopy(in: prefix.count - 2 ..< prefix.count)
        guard let response = Self.init(data: responseData),
            let checksum = Checksum(data: checksumData)
            else { return nil }
        let expectedChecksum = Checksum(calculate: responseData)
        return (response, checksum, expectedChecksum)
    }
}
