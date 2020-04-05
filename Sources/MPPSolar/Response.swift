//
//  File.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation

/// MPP Solar Response
public protocol ResponseProtocol {
    
    init?(rawValue: String)
}

internal extension ResponseProtocol {
    
    static var prefix: String { return "(" }
}

internal extension ResponseProtocol {
    
    static func parse(_ data: Data) -> (Self, Checksum, Checksum)? {
        guard data.count > 3
            else { return nil }
        let responseBodyData = data.prefix(while: { $0 != "\r".utf8.first })
        let responseData = responseBodyData.subdataNoCopy(in: 1 ..< responseBodyData.count - 2)
        let checksumData = responseBodyData.subdataNoCopy(in: responseBodyData.count - 2 ..< responseBodyData.count)
        guard responseBodyData[0] == prefix.utf8.first,
            let responseString = String(data: responseData, encoding: .utf8),
            let response = Self.init(rawValue: responseString),
            let checksum = Checksum(data: checksumData)
            else { return nil }
        let expectedChecksum = Checksum(calculate: responseBodyData.subdataNoCopy(in: 0 ..< responseBodyData.count - 2))
        return (response, checksum, expectedChecksum)
    }
}
