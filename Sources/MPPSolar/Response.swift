//
//  ResponseProtocol.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation

/// MPP Solar Response
public protocol ResponseProtocol {
    
    init?(response: String)
}

public extension ResponseProtocol where Self: RawRepresentable, Self.RawValue == String {
    
    init?(response: String) {
        self.init(rawValue: response)
    }
}

public extension ResponseProtocol where Self: OptionSet, Self.RawValue: FixedWidthInteger {
    
    init?(response: String) {
        // parse optionset as binary string
        guard response.count == RawValue.bitWidth,
              let rawValue = RawValue(response, radix: 2)
            else { return nil }
        self.init(rawValue: rawValue)
    }
}

internal extension Data {
    
    func parseSolarResponse() -> (String, Checksum, Checksum)? {
        let responsePrefix = "("
        guard self.count > 3,
            let responseBodyRange = self.firstIndex(of: "\r".utf8.first!).flatMap({ 0 ..< $0 })
            else { return nil }
        let responseBodyData = self.subdataNoCopy(in: responseBodyRange)
        let responseData = responseBodyData.subdataNoCopy(in: 1 ..< responseBodyData.count - 2)
        let checksumData = responseBodyData.suffixNoCopy(from: responseBodyData.count - 2)
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
            let response = Self.init(response: responseString)
            else { return nil }
        return (response, responseChecksum, expectedChecksum)
    }
}
