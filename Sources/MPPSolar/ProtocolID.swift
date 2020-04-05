//
//  File.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

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
    struct Inquiry: InquiryCommand, CustomStringConvertible {
            
        public static var commandType: CommandType { .inquiry(.protocolID) }
        
        public init() { }
    }
}

// MARK: - Response

public extension ProtocolID.Inquiry {
    
    /// Device Protocol ID Inquiry Response
    struct Response: ResponseProtocol, Equatable, Hashable {
        
        public let protocolID: ProtocolID
        
        public init?(rawValue: String) {
            // (PI<NN> <CRC><cr>
            guard rawValue.count == 4,
                rawValue.hasPrefix("PI"),
                let protocolID = UInt(rawValue.suffix(2))
                else { return nil }
            self.protocolID = .init(rawValue: protocolID)
        }
    }
}
