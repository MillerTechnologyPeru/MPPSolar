//
//  DataConvertible.swift
//
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation

/// Can be converted into data.
internal protocol DataConvertible {
    
    /// Append data representation into buffer.
    static func += (data: inout Data, value: Self)
    
    /// Length of value when encoded into data.
    var dataLength: Int { get }
}

extension Data {
    
    /// Initialize data with contents of value.
    @inline(__always)
    init <T: DataConvertible> (_ value: T) {
        self.init(capacity: value.dataLength)
        self += value
        assert(count == value.dataLength)
    }
}

// MARK: - UnsafeDataConvertible

/// Internal Data casting protocol
internal protocol UnsafeDataConvertible: DataConvertible { }

extension UnsafeDataConvertible {
    
    var dataLength: Int {
        return MemoryLayout<Self>.size
    }
    
    /// Append data representation into buffer.
    static func += (data: inout Data, value: Self) {
        withUnsafePointer(to: value) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<Self>.size) {
                data.append($0, count: MemoryLayout<Self>.size)
            }
        }
    }
}

extension UInt16: UnsafeDataConvertible { }
extension UInt32: UnsafeDataConvertible { }
extension UInt64: UnsafeDataConvertible { }
