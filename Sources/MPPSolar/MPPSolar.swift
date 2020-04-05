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
    
    public let connection: MPPSolarConnection
    
    // MARK: - Initialization
    
    public init(connection: MPPSolarConnection) {
        self.connection = connection
    }
    
    // MARK: - Methods
    
    @discardableResult
    public func send <T: Command> (_ command: T) throws -> T.Response {
        
        // send command
        try connection.send(command.data)
        // read response
        let responseData = try connection.recieve(256)
        // parse response
        guard let (responseString, responseChecksum, expectedChecksum) = responseData.parseSolarResponse()
            else { throw MPPSolarError.invalidResponse(responseData) }
        // validate checksum
        guard responseChecksum == expectedChecksum
            else { throw MPPSolarError.invalidChecksum(responseChecksum, expected: expectedChecksum) }
        // parse response string
        guard let response = T.Response.init(rawValue: responseString) else {
            if let acknowledgement = Acknowledgement(rawValue: responseString),
                acknowledgement == .notAcknowledged {
                throw MPPSolarError.notAcknowledged
            } else {
                throw MPPSolarError.invalidResponse(responseData)
            }
        }
        return response
    }
}

public extension MPPSolar {
    
    /// Initialize with special file path. 
    convenience init?(path: String) {
        #if os(Linux)
        guard let connection = try? USB(path: path) ?? try? Serial(path: path)
            else { return nil }
        #else
        guard let connection = try? Serial(path: path)
            else { return nil }
        #endif
        self.init(connection: connection)
    }
}

// MARK: - Supporting Types

public protocol MPPSolarConnection {
    
    func send(_ data: Data) throws
    
    func recieve(_ size: Int) throws -> Data
}

#if os(Linux)
public extension MPPSolar {
    
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
            let timeout = Date() + 5.0
            var data = Data()
            repeat { data += try readFD() }
            while data.contains("\r".utf8.first!) == false && Date() < timeout
            guard Date() < timeout else { throw MPPSolarError.timeout }
            return data
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
#endif

public extension MPPSolar {
    
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
