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
        guard data.count > 3
            else { return nil }
        let prefix = data.prefix(while: { $0 != "\r".utf8.first })
        guard let response = Self.init(data: prefix.subdataNoCopy(in: 0 ..< prefix.count - 2)),
            let checksum = Checksum(data: prefix.subdataNoCopy(in: prefix.count - 2 ..< prefix.count))
            else { return nil }
        return (response, checksum)
    }
}
