//
//  Arguments.swift
//  
//
//  Created by Alsey Coleman Miller on 7/27/20.
//

import Foundation
import ArgumentParser
import MPPSolar

extension RawRepresentable where Self: ExpressibleByArgument, Self.RawValue == String {

    public init?(argument: String) {
        self.init(rawValue: argument)
     }
}

public protocol IntegerExpressibleByArgument: ExpressibleByArgument, FixedWidthInteger {
    
    init?<S: StringProtocol>(_ string: S, radix: Int)
}

extension IntegerExpressibleByArgument {
    
    public init?(integerArgument argument: String) {
        // detect if hexadecimal
        if argument.hasPrefix("0x") {
            self.init(argument.replacingOccurrences(of: "0x", with: ""), radix: 16)
        } else {
            self.init(argument, radix: 10)
        }
     }
}

extension RawRepresentable where Self: ExpressibleByArgument, RawValue: IntegerExpressibleByArgument {
    
    public init?(argument: String) {
        guard let rawValue = RawValue(integerArgument: argument)
            else { return nil }
        self.init(rawValue: rawValue)
    }
}

// MARK: -

extension UInt8: IntegerExpressibleByArgument { }

extension UInt16: IntegerExpressibleByArgument { }

extension UInt: IntegerExpressibleByArgument { }

extension Int: IntegerExpressibleByArgument { }

extension OutputFrequency: ExpressibleByArgument { }

