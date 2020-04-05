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

internal extension Data {
    
    func parseSolarResponse() -> (String, Checksum, Checksum)? {
        let responsePrefix = "("
        guard self.count > 3
            else { return nil }
        let responseBodyData = self.prefix(while: { $0 != "\r".utf8.first }) // FIXME: Get range to not copy data
        let responseData = responseBodyData.subdataNoCopy(in: 1 ..< responseBodyData.count - 2)
        let checksumData = responseBodyData.subdataNoCopy(in: responseBodyData.count - 2 ..< responseBodyData.count)
        guard responseBodyData[0] == responsePrefix.utf8.first,
            let responseString = String(data: responseData, encoding: .utf8),
            let checksum = Checksum(data: checksumData)
            else { return nil }
        let expectedChecksum = Checksum(calculate: responseBodyData.subdataNoCopy(in: 0 ..< responseBodyData.count - 2))
        return (responseString, checksum, expectedChecksum)
    }
}

internal extension ResponseProtocol {
         
    static func parse(_ data: Data) -> (Self, Checksum, Checksum)? {
        guard let (responseString, responseChecksum, expectedChecksum) = data.parseSolarResponse(),
            let response = Self.init(rawValue: responseString)
            else { return nil }
        return (response, responseChecksum, expectedChecksum)
    }
}
