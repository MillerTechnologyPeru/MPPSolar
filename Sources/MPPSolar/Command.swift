//
//  File.swift
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

internal extension Command {
    
    var data: Data {
        let commandString = rawValue
        let carrierReturn = "\r"
        let length = commandString.utf8.count + Checksum.length + carrierReturn.utf8.count
        var data = Data(capacity: length)
        data += commandString.utf8
        let checksum = Checksum(calculate: data)
        data += checksum
        data += carrierReturn.utf8 // CR
        assert(data.count == length)
        return data
    }
}

// MARK: - InquiryCommand

public protocol InquiryCommand: Command { }

public extension InquiryCommand {
    
    var rawValue: String {
        return Self.commandType.rawValue
    }
}

// MARK: - SettingCommand

public protocol SettingCommand: Command { }
