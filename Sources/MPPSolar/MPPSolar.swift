//
//  MPPSolar.swift
//
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation
import Socket

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
    
    /// Send MPP Solar command.
    @discardableResult
    public func send <T: Command> (_ command: T) async throws -> T.Response {
        
        // send command
        let responseString = try await send(command.rawValue)
        // parse response string
        guard let response = T.Response.init(response: responseString) else {
            throw MPPSolarError.invalidResponse(command.data)
        }
        return response
    }
    
    /// Send raw MPP Solar command.
    @discardableResult
    public func send(_ command: String) async throws -> String {
        
        // send command
        let requestData = Data(solarCommand: command)
        try await connection.send(requestData)
        // read response
        let responseData = try await connection.recieve(256)
        // parse response
        guard let (responseString, responseChecksum, expectedChecksum) = responseData.parseSolarResponse()
            else { throw MPPSolarError.invalidResponse(responseData) }
        // validate checksum
        guard responseChecksum == expectedChecksum
            else { throw MPPSolarError.invalidChecksum(responseChecksum, expected: expectedChecksum) }
        guard responseString != Acknowledgement.notAcknowledged.rawValue else {
            throw MPPSolarError.notAcknowledged
        }
        return responseString
    }
}

public extension MPPSolar {
    
    /// Initialize with special file path. 
    convenience init?(path: String) async {
        #if os(Linux)
        guard let connection: MPPSolarConnection = await (try? USB(path: path)) ?? (try? Serial(path: path))
            else { return nil }
        #else
        guard let connection = try? Serial(path: path)
            else { return nil }
        #endif
        self.init(connection: connection)
    }
}

// MARK: - Supporting Types

public protocol MPPSolarConnection: AnyObject {
    
    func send(_ data: Data) async throws
    
    func recieve(_ size: Int) async throws -> Data
}

#if os(Linux)
public extension MPPSolar {
    
    /// MPP Solar USB Connection
    final class USB: MPPSolarConnection {
        
        // MARK: - Properties
        
        public let path: String
        
        @usableFromInline
        internal let socket: Socket
        
        // MARK: Initialization
        
        deinit {
            Task(priority: .high) {
                await socket.close()
            }
        }
        
        public init(path: String = "/dev/hidraw0") async throws {
            let fileDescriptor = try FileDescriptor.open(
                FilePath(path),
                .readWrite
            )
            self.socket = await Socket(
                fileDescriptor: .init(rawValue: fileDescriptor.rawValue)
            )
            self.path = path
        }
        
        // MARK: Methods
        
        public func send(_ data: Data) async throws {
            assert(data.isEmpty == false, "Cannot write empty data")
            let actualByteCount = try await socket.write(data)
            assert(data.count == actualByteCount, "Did not send \(data.count) bytes, instead \(actualByteCount)")
        }
        
        public func recieve(_ size: Int = 256) async throws -> Data {
            let task = Task {
                var data = Data()
                repeat {
                    data += try await socket.read(size)
                }
                while data.contains("\r".utf8.first!) == false
                return data
            }
            Task {
                try await Task.sleep(nanoseconds: 5 * 1_000_000_000)
                task.cancel()
            }
            return try await task.value
        }
    }
}
#endif

public extension MPPSolar {
    
    /// MPP Solar Serial Connection
    final class Serial: MPPSolarConnection {
        
        public let path: String
        
        public init(path: String, baudRate: UInt = 2400) throws {
            throw POSIXError(.EBADF)
        }
        
        public func send(_ data: Data) throws {
            fatalError("Not implemented")
        }
        
        public func recieve(_ size: Int = 256) throws -> Data {
            fatalError("Not implemented")
        }
    }
}
