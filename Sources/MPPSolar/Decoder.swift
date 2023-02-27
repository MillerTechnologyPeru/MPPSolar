//
//  Decoder.swift
//  
//
//  Created by Alsey Coleman Miller on 2/26/23.
//

import Foundation

internal final class MPPSolarDecoder: Decoder {
    
    /// The path of coding keys taken to get to this point in decoding.
    fileprivate(set) var codingPath: [CodingKey]
    
    /// Any contextual information set by the user for decoding.
    let userInfo: [CodingUserInfoKey : Any]
    
    let log: ((String) -> ())?
    
    let components: [String.SubSequence]
    
    private var offset: Int = 0
    
    // MARK: - Initialization
    
    init(rawValue: String,
         at codingPath: [CodingKey] = [],
         userInfo: [CodingUserInfoKey : Any] = [:],
         log: ((String) -> ())? = nil
    ) {
        self.codingPath = codingPath
        self.userInfo = userInfo
        self.log = log
        self.components = rawValue.split(separator: " ")
    }
    
    // MARK: - Methods
    
    func container <Key: CodingKey> (keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> {
        log?("Requested container keyed by \(type.sanitizedName) for path \"\(codingPath.path)\"")
        let keyedContainer = MPPSolarKeyedDecodingContainer<Key>(referencing: self)
        return KeyedDecodingContainer(keyedContainer)
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        log?("Requested unkeyed container for path \"\(codingPath.path)\"")
        fatalError()
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        log?("Requested single value container for path \"\(codingPath.path)\"")
        fatalError()
    }
}

fileprivate extension MPPSolarDecoder {
    
    func read() throws -> String.SubSequence {
        guard offset < components.count else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "End of string."))
        }
        defer { offset += 1 }
        return components[offset]
    }
    
    func read<T: MPPSolarRawDecodable>(_ type: T.Type) throws -> T {
        let substring = try read()
        guard let decoded = type.init(solar: substring) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode \(type) from \"\(substring)\"."))
        }
        return decoded
    }
    
    func readString() throws -> String {
        let substring = try read()
        return String(substring)
    }
    
    func readOptionSet<T>(_ type: T.Type) throws -> T where T: OptionSet, T.RawValue: FixedWidthInteger {
        let substring = try read()
        guard let rawValue = T.RawValue(substring, radix: 2) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode \(type) from \"\(substring)\"."))
        }
        return T.init(rawValue: rawValue)
    }
    
    /// Attempt to decode native value to expected type.
    func readDecodable <T: Decodable> (_ type: T.Type) throws -> T {
                
        // override for native types
        if type == Data.self {
            fatalError() //return try readData() as! T // In this case T is Data
        } else if type == Date.self {
            fatalError() //return try readDate() as! T
        } else {
            // decode using Decodable, container should read directly.
            return try T.init(from: self)
        }
    }
}

// MARK: - KeyedDecodingContainer

internal struct MPPSolarKeyedDecodingContainer <K: CodingKey> : KeyedDecodingContainerProtocol {
    
    typealias Key = K
    
    // MARK: Properties
    
    /// A reference to the encoder we're reading from.
    let decoder: MPPSolarDecoder
    
    /// The path of coding keys taken to get to this point in decoding.
    let codingPath: [CodingKey]
    
    /// All the keys the Decoder has for this container.
    let allKeys: [Key]
    
    // MARK: Initialization
    
    /// Initializes `self` by referencing the given decoder and container.
    init(referencing decoder: MPPSolarDecoder) {
        
        self.decoder = decoder
        self.codingPath = decoder.codingPath
        self.allKeys = [] // FIXME: allKeys
    }
    
    // MARK: KeyedDecodingContainerProtocol
    
    func contains(_ key: Key) -> Bool {
        
        self.decoder.log?("Check whether key \"\(key.stringValue)\" exists")
        return true // FIXME: Contains key
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        
        // set coding key context
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        
        self.decoder.log?("Check if nil at path \"\(decoder.codingPath.path)\"")
        
        // There is no way to represent nil
        return false
    }
    
    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        return try decodeSolar(type, forKey: key)
    }
    
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        return try decodeSolar(type, forKey: key)
    }
    
    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        return try decodeSolar(type, forKey: key)
    }
    
    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        return try decodeSolar(type, forKey: key)
    }
    
    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        return try decodeSolar(type, forKey: key)
    }
    
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        return try decodeSolar(type, forKey: key)
    }
    
    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        return try decodeSolar(type, forKey: key)
    }
    
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        return try decodeSolar(type, forKey: key)
    }
    
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        return try decodeSolar(type, forKey: key)
    }
    
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        return try decodeSolar(type, forKey: key)
    }
    
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        return try decodeSolar(type, forKey: key)
    }
    
    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        return try decodeSolar(type, forKey: key)
    }
    
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        return try decodeSolar(type, forKey: key)
    }
    
    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        self.decoder.log?("Will read \(type) at path \"\(decoder.codingPath.path)\"")
        return try self.decoder.readString()
    }
    
    func decode <T: Decodable> (_ type: T.Type, forKey key: Key) throws -> T {
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        self.decoder.log?("Will read \(type) at path \"\(decoder.codingPath.path)\"")
        return try self.decoder.readDecodable(T.self)
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        assertionFailure()
        throw CocoaError(.coderValueNotFound)
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        assertionFailure()
        throw CocoaError(.coderValueNotFound)
    }
    
    func superDecoder() throws -> Decoder {
        assertionFailure()
        throw CocoaError(.coderValueNotFound)
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        assertionFailure()
        throw CocoaError(.coderValueNotFound)
    }
    
    // MARK: Private Methods
        
    /// Decode native value type from Solar data.
    private func decodeSolar <T: MPPSolarRawDecodable> (_ type: T.Type, forKey key: Key) throws -> T {
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        self.decoder.log?("Will read \(T.self) at path \"\(decoder.codingPath.path)\"")
        return try self.decoder.read(T.self)
    }
}

// MARK: - Decodable Types

/// Private protocol for decoding MPP Solar values into raw data.
internal protocol MPPSolarRawDecodable {
    
    init?(solar: String.SubSequence)
}

extension Bool: MPPSolarRawDecodable {
    
    public init?(solar string: String.SubSequence) {
        guard let character = string.first, string.count == 1 else {
            return nil
        }
        self.init(solar: character)
    }
}

extension UInt8: MPPSolarRawDecodable {
    
    init?(solar: String.SubSequence) {
        self.init(solar)
    }
}

extension UInt16: MPPSolarRawDecodable {
    
    init?(solar: String.SubSequence) {
        self.init(solar)
    }
}

extension UInt32: MPPSolarRawDecodable {
    
    init?(solar: String.SubSequence) {
        self.init(solar)
    }
}

extension UInt64: MPPSolarRawDecodable {
    
    init?(solar: String.SubSequence) {
        self.init(solar)
    }
}

extension Int8: MPPSolarRawDecodable {
    
    init?(solar: String.SubSequence) {
        self.init(solar)
    }
}

extension Int16: MPPSolarRawDecodable {
    
    init?(solar: String.SubSequence) {
        self.init(solar)
    }
}

extension Int32: MPPSolarRawDecodable {
    
    init?(solar: String.SubSequence) {
        self.init(solar)
    }
}

extension Int64: MPPSolarRawDecodable {
    
    init?(solar: String.SubSequence) {
        self.init(solar)
    }
}

extension UInt: MPPSolarRawDecodable {
    
    init?(solar: String.SubSequence) {
        self.init(solar)
    }
}

extension Int: MPPSolarRawDecodable {
    
    init?(solar: String.SubSequence) {
        self.init(solar)
    }
}

extension Float: MPPSolarRawDecodable {
    
    init?(solar: String.SubSequence) {
        self.init(solar)
    }
}

extension Double: MPPSolarRawDecodable {
    
    init?(solar: String.SubSequence) {
        self.init(solar)
    }
}
