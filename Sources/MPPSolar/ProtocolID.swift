//
//  ProtocolID.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

/// MPP Solar Device Protocol ID
public struct ProtocolID: RawRepresentable, Equatable, Hashable, Codable {
    
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}

// MARK: - CustomStringConvertible

extension ProtocolID: CustomStringConvertible {
    
    public var description: String {
        return rawValue.description
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension ProtocolID: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: UInt) {
        self.init(rawValue: value)
    }
}

// MARK: - Command

public extension ProtocolID {
    
    /// Device Protocol ID Inquiry
    struct Query: QueryCommand, CustomStringConvertible {
            
        public static var commandType: CommandType { .query(.protocolID) }
        
        public init() { }
    }
}

// MARK: - Response

public extension ProtocolID.Query {
    
    /// Device Protocol ID Inquiry Response
    struct Response: ResponseProtocol, Equatable, Hashable, Codable {
        
        public let protocolID: ProtocolID
        
        public init?(response: String) {
            // (PI<NN> <CRC><cr>
            guard response.count == 4,
                  response.hasPrefix("PI"),
                let protocolID = UInt(response.suffix(2))
                else { return nil }
            self.protocolID = .init(rawValue: protocolID)
        }
    }
}
