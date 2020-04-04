//
//  File.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation

public protocol Response: Message {
    
    init?(data: Data)
}
