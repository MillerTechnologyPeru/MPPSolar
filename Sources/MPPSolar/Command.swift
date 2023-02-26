//
//  Command.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation

public protocol Command {
    
    /// Command Response
    associatedtype Response: ResponseProtocol
    
    /// Command Prefix
    static var commandType: CommandType { get }
    
    var rawValue: String { get }
}

extension Command where Self: CustomStringConvertible {
    
    public var description: String {
        return rawValue
    }
}

public extension Command {
    
    var checksum: Checksum {
        return Checksum(calculate: rawValue.utf8)
    }
}

internal extension Command {
    
    var data: Data {
        return Data(solarCommand: rawValue)
    }
}

internal extension Data {
    
    init(solarCommand rawValue: String) {
        let checksum = Checksum(calculate: rawValue.utf8)
        let carrierReturn = "\r"
        let length = rawValue.utf8.count + Checksum.length + carrierReturn.utf8.count
        var data = Data(capacity: length)
        data += rawValue.utf8
        data += checksum
        data += carrierReturn.utf8 // CR
        assert(data.count == length)
        self = data
    }
}

// MARK: - Query Command

public protocol QueryCommand: Command { }

public extension QueryCommand {
    
    var rawValue: String {
        return Self.commandType.rawValue
    }
}

// MARK: - Setting Command

public protocol SettingCommand: Command { }
