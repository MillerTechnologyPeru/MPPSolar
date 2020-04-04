//
//  File.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation

/// MPP Solar Device Protocol ID
public struct ProtocolID: RawRepresentable, Equatable, Hashable {
    
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
    struct Inquiry: InquiryCommand {
            
        public static var commandType: CommandType { .inquiry(.protocolID) }
        
        public init() { }
    }
}

// MARK: - Response

public extension ProtocolID.Inquiry {
    
    struct Response: ResponseProtocol, Equatable, Hashable {
        
        internal static var prefix: String { return "(PI" }
        
        internal static var length: Int { return 5 }
        
        public let protocolID: ProtocolID
        
        public init?(data: Data) {
            // (PI<NN> <CRC><cr>
            guard data.count == 5,
                let string = String(data: data, encoding: .utf8),
                string.count == 5,
                string.hasPrefix(type(of: self).prefix),
                let protocolID = UInt(string.suffix(2))
                else { return nil }
            self.protocolID = .init(rawValue: protocolID)
        }
    }
}
