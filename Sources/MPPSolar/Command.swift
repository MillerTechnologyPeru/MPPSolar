//
//  File.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation

public protocol Command: Message {
    
    associatedtype Response: MPPSolar.Response
    
    static var commandType: CommandType { get }
    
    var data: Data { get }
}
