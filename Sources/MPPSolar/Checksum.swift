//
//  Checksum.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation
import CMPPSolar

/// Checksum
public struct Checksum: RawRepresentable, Equatable, Hashable {
    
    public let rawValue: UInt16
    
    public init(rawValue: UInt16) {
        self.rawValue = rawValue
    }
}

public extension Checksum {
    
    init(data: Data) {
        guard data.isEmpty == false else {
            self = 0
            return
        }
        let value = data.withUnsafeBytes { (buffer: UnsafeRawBufferPointer) in
            mppsolar_crc(
                UnsafeMutablePointer(mutating: buffer.baseAddress!.assumingMemoryBound(to: UInt8.self)),
                UInt8(buffer.count)
            )
        }
        self.init(rawValue: value)
    }
}

// MARK: - CustomStringConvertible

extension Checksum: CustomStringConvertible {
    
    public var description: String {
        return "0x" + rawValue.toHexadecimal()
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Checksum: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: UInt16) {
        self.init(rawValue: value)
    }
}
