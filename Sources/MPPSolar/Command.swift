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
    
    /// Append data representation into buffer.
    static func += (data: inout Data, value: Self)
    
    /// Length of value when encoded into data.
    var dataLength: Int { get }
}

public extension Command {
    
    var data: Data {
        let length = self.dataLength
        var data = Data(capacity: length)
        data += self
        assert(data.count == length)
        return data
    }
}

internal extension Command {
    
    var commandData: Data {
        let length = dataLength + Checksum.length
        var data = Data(capacity: length)
        data += self
        let checksum = Checksum(calculate: data)
        data += checksum
        assert(data.count == length)
        return data
    }
}

// MARK: - InquiryCommand

public protocol InquiryCommand: Command { }

public extension InquiryCommand {
    
    var dataLength: Int {
        return type(of: self).commandType.rawValue.utf8.count
    }
    
    static func += (data: inout Data, value: Self) {
        data.append(contentsOf: type(of: value).commandType.rawValue.utf8)
    }
}

// MARK: - SettingCommand

public protocol SettingCommand: Command { }
