//
//  Integer.swift
//
//
//  Created by Alsey Coleman Miller on 8/24/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

internal extension UInt16 {
    
    /// Initializes value from two bytes.
    init(bytes: (UInt8, UInt8)) {
        self = unsafeBitCast(bytes, to: UInt16.self)
    }
}
