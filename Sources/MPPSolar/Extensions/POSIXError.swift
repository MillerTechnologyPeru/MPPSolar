//
//  POSIXError.swift
//  
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import Foundation

#if os(macOS)
import Darwin
#elseif os(Linux) || os(Android)
import Glibc
#endif

#if os(Linux)
internal extension POSIXError {
    
    /// Creates error from C ```errno```.
    static func fromErrno(file: StaticString = #file,
                          line: UInt = #line,
                          function: StaticString = #function) -> POSIXError {
        
        guard let code = POSIXErrorCode(rawValue: errno)
            else { fatalError("Invalid POSIX Error \(errno)") }
        
        return POSIXError(code, function: function, file: file, line: line)
    }
    
    init(_ code: POSIXErrorCode,
         function: StaticString = #function,
         file: StaticString = #file,
         line: UInt = #line) {
        
        self.init(_nsError: NSPOSIXError(code, function: function, file: file, line: line))
    }
}

internal extension POSIXErrorCode {
    
    var errorMessage: String {
        return String(cString: strerror(rawValue), encoding: .utf8)!
    }
}

// MARK: - Supporting Types

/// NSError subclass for POSIX Errors
internal final class NSPOSIXError: NSError {
    
    let posixError: POSIXErrorCode
    
    init(_ code: POSIXErrorCode,
         function: StaticString = #function,
         file: StaticString = #file,
         line: UInt = #line) {
        
        var userInfo = [String: Any](minimumCapacity: 1)
        userInfo[NSPOSIXError.debugInformationKey] = NSPOSIXError.debugInformation(
            function: function,
            file: file,
            line: line)
        
        self.posixError = code
        super.init(domain: NSPOSIXErrorDomain,
                   code: Int(code.rawValue),
                   userInfo: userInfo)
    }
    
    required init?(coder decoder: NSCoder) {
        return nil
    }
    
    override var domain: String { return NSPOSIXErrorDomain }
    
    override var code: Int {
        return Int(posixError.rawValue)
    }
    
    override var localizedDescription: String {
        return posixError.errorMessage
    }
    
    override var localizedFailureReason: String? {
        return posixError.errorMessage
    }
    
    override var description: String {
        return "\(posixError.errorMessage) (\(posixError))"
    }
    
    var debugInformation: String? {
        return userInfo[NSPOSIXError.debugInformationKey] as? String
    }
}

internal extension NSPOSIXError {
    
    /// Contains
    static let debugInformationKey: String = "NSPOSIXErrorDebugInformation"
}

private extension NSPOSIXError {
    
    static let module = NSStringFromClass(NSPOSIXError.self).components(separatedBy:".")[0]
    
    static func debugInformation(function: StaticString,
                                 file: StaticString,
                                 line: UInt) -> String {
        
        let file = "\(file)"
        let fileName = file.components(separatedBy: "/").last ?? file
        return "\(module):\(fileName):\(function):\(line)"
    }
}
#endif
