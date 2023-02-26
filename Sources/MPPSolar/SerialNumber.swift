//
//  SerialNumber.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

/// MPP Solar Serial Number
public struct SerialNumber: RawRepresentable, Equatable, Hashable, Codable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - CustomStringConvertible

extension SerialNumber: CustomStringConvertible {
    
    public var description: String {
        return rawValue.description
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension SerialNumber: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}

// MARK: - Command

public extension SerialNumber {
    
    /// Device Serial Number Inquiry
    struct Query: QueryCommand, CustomStringConvertible {
            
        public static var commandType: CommandType { .query(.serialNumber) }
        
        public init() { }
    }
}

// MARK: - Response

public extension SerialNumber.Query {
    
    /// Device  Serial Number Inquiry Response
    struct Response: ResponseProtocol, Equatable, Hashable, Codable {
        
        public let serialNumber: SerialNumber
        
        public init?(rawValue: String) {
            // (XXXXXXXXXXXXXX <CRC><cr>
            guard rawValue.isEmpty == false
                else { return nil }
            self.serialNumber = .init(rawValue: rawValue)
        }
    }
}
