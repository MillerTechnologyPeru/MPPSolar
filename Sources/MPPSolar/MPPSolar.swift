//
//  MPPSolar.swift
//
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation

#if os(macOS)
import Darwin
#elseif os(Linux) || os(Android)
import Glibc
#endif

/// MPP Solar Device
public final class MPPSolar {
    
    // MARK: - Properties
    
    public let connection: Connection
    
    // MARK: - Initialization
    
    public init(connection: Connection) {
        self.connection = connection
    }
    
    public convenience init?(path: String) {
        if let connection = try? Connection.USB(path: path) {
            self.init(connection: .usb(connection))
        } else if let connection = try? Connection.Serial(path: path) {
            self.init(connection: .serial(connection))
        } else {
            return nil
        }
    }
    
    // MARK: - Methods
    
    @discardableResult
    public func send <T: Command> (_ command: T) throws -> T.Response {
        
        let connection = self.connection.rawValue
        try connection.send(command.commandData)
        let responseData = try connection.recieve(256)
        guard let (response, responseChecksum) = T.Response.parse(responseData)
            else { throw MPPSolarError.invalidResponse(responseData) }
        let validChecksum = Checksum(calculate: responseData.subdataNoCopy(in: 0 ..< responseData.count - 2))
        guard validChecksum == responseChecksum
            else { throw MPPSolarError.invalidChecksum(expected: validChecksum, invalid: responseChecksum) }
        return response
    }
}

// MARK: - Supporting Types

public extension MPPSolar {
    
    enum Connection {
        
        /// USB Connection
        case usb(USB)
        
        /// Serial Connection
        case serial(Serial)
    }
}

internal extension MPPSolar.Connection {
    
    var rawValue: MPPSolarConnection {
        switch self {
        case let .usb(connection): return connection
        case let .serial(connection): return connection
        }
    }
}

public protocol MPPSolarConnection {
    
    func send(_ data: Data) throws
    
    func recieve(_ size: Int) throws -> Data
}

public extension MPPSolar.Connection {
    
    /// MPP Solar USB Connection
    final class USB: MPPSolarConnection {
        
        // MARK: - Properties
        
        public let path: String
        
        internal let fileDescriptor: Int32
        
        // MARK: Initialization
        
        deinit {
            closeFD()
        }
        
        public init(path: String = "/dev/hidraw0") throws {
            let fileDescriptor = open(path, O_RDWR) // | O_NONBLOCK)
            guard fileDescriptor != -1
                else { throw POSIXError.fromErrno() }
            self.path = path
            self.fileDescriptor = fileDescriptor
        }
        
        // MARK: Methods
        
        internal func closeFD() {
            close(fileDescriptor)
        }
        
        public func send(_ data: Data) throws {
            assert(data.isEmpty == false, "Cannot write empty data")
            let actualByteCount = data.withUnsafeBytes {
                write(fileDescriptor, $0.baseAddress, $0.count)
            }
            guard actualByteCount >= 0
                else { throw POSIXError.fromErrno() }
            assert(data.count == actualByteCount, "Did not send \(data.count) bytes, instead \(actualByteCount)")
        }
        
        public func recieve(_ size: Int = 256) throws -> Data {
            return try readFD()
        }
        
        internal func readFD(_ size: Int = 256) throws -> Data {
            
            var data = Data(repeating: 0x00, count: size)
            let actualByteCount = data.withUnsafeMutableBytes {
                read(fileDescriptor, $0.baseAddress, $0.count)
            }
            guard actualByteCount >= 0 else { throw POSIXError.fromErrno() }
            if actualByteCount < size {
                data.removeSubrange(actualByteCount ..< size)
            }
            assert(data.count == actualByteCount)
            return data
        }
    }
}

public extension MPPSolar.Connection {
    
    /// MPP Solar Serial Connection
    final class Serial: MPPSolarConnection {
        
        public let path: String
        
        public init(path: String, baudRate: UInt = 2400) throws {
            self.path = path
            // FIXME: Open Serial Device with SwiftSerial
            fatalError("Not implemented")
        }
        
        public func send(_ data: Data) throws {
            fatalError("Not implemented")
        }
        
        public func recieve(_ size: Int = 256) throws -> Data {
            fatalError("Not implemented")
        }
    }
}
