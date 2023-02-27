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
        throw CocoaError(.coderReadCorrupt)
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        log?("Requested single value container for path \"\(codingPath.path)\"")
        return MPPSolarSingleValueDecodingContainer(referencing: self)
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
    
    func readString() throws -> String {
        let substring = try read()
        return String(substring)
    }
    
    func readBool() throws -> Bool {
        let substring = try read()
        guard let character = substring.first, substring.count == 1, let value = Bool(solar: character) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode \(Bool.self) from \"\(substring)\"."))
        }
        return value
    }
    
    func readFloat() throws -> Float {
        let substring = try read()
        guard let value = Float(substring) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode \(Float.self) from \"\(substring)\"."))
        }
        return value
    }
    
    func readDouble() throws -> Double {
        let substring = try read()
        guard let value = Double(substring) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode \(Double.self) from \"\(substring)\"."))
        }
        return value
    }
    
    func readNumeric<T>(_ type: T.Type) throws -> T where T: FixedWidthInteger {
        // attempt to decode binary format
        let substring = try read()
        if substring.count == T.bitWidth {
            guard let value = T.init(substring, radix: 2) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode \(type) from \"\(substring)\"."))
            }
            return value
        } else {
            // decode decimal string
            guard let value = T.init(substring, radix: 10) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Could not decode \(type) from \"\(substring)\"."))
            }
            return value
        }
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
        
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        self.decoder.log?("Will read \(type) at path \"\(decoder.codingPath.path)\"")
        return try self.decoder.readBool()
    }
    
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        return try decodeNumeric(type, forKey: key)
    }
    
    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        return try decodeNumeric(type, forKey: key)
    }
    
    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        return try decodeNumeric(type, forKey: key)
    }
    
    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        return try decodeNumeric(type, forKey: key)
    }
    
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        return try decodeNumeric(type, forKey: key)
    }
    
    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        return try decodeNumeric(type, forKey: key)
    }
    
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        return try decodeNumeric(type, forKey: key)
    }
    
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        return try decodeNumeric(type, forKey: key)
    }
    
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        return try decodeNumeric(type, forKey: key)
    }
    
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        return try decodeNumeric(type, forKey: key)
    }
    
    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        self.decoder.log?("Will read \(type) at path \"\(decoder.codingPath.path)\"")
        return try self.decoder.readFloat()
    }
    
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        self.decoder.log?("Will read \(type) at path \"\(decoder.codingPath.path)\"")
        return try self.decoder.readDouble()
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
    
    private func decodeNumeric <T> (_ type: T.Type, forKey key: Key) throws -> T where T: FixedWidthInteger {
        self.decoder.codingPath.append(key)
        defer { self.decoder.codingPath.removeLast() }
        self.decoder.log?("Will read \(T.self) at path \"\(decoder.codingPath.path)\"")
        return try self.decoder.readNumeric(T.self)
    }
}

// MARK: - SingleValueDecodingContainer

internal struct MPPSolarSingleValueDecodingContainer: SingleValueDecodingContainer {
    
    // MARK: Properties
    
    /// A reference to the decoder we're reading from.
    let decoder: MPPSolarDecoder
    
    /// The path of coding keys taken to get to this point in decoding.
    let codingPath: [CodingKey]
    
    // MARK: Initialization
    
    /// Initializes `self` by referencing the given decoder and container.
    init(referencing decoder: MPPSolarDecoder) {
        self.decoder = decoder
        self.codingPath = decoder.codingPath
    }
    
    // MARK: SingleValueDecodingContainer
    
    func decodeNil() -> Bool {
        return false // FIXME: Decode nil
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        return try decoder.readBool()
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        try decoder.readNumeric(type)
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        try decoder.readNumeric(type)
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        try decoder.readNumeric(type)
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        try decoder.readNumeric(type)
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        try decoder.readNumeric(type)
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        try decoder.readNumeric(type)
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        try decoder.readNumeric(type)
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        return try decoder.readNumeric(UInt16.self)
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        try decoder.readNumeric(type)
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        try decoder.readNumeric(type)
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        try decoder.readFloat()
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        try decoder.readDouble()
    }
    
    func decode(_ type: String.Type) throws -> String {
        return try decoder.readString()
    }
    
    func decode <T : Decodable> (_ type: T.Type) throws -> T {
        return try decoder.readDecodable(type)
    }
}
