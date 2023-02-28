//
//  FlagStatus.swift
//  
//
//  Created by Alsey Coleman Miller on 7/27/20.
//

import Foundation

/// MPP Solar Status Flags
public enum FlagStatus: String, Codable, CaseIterable {
    
    /// Enable/disable silence buzzer or open buzzer
    case buzzer             = "a"
    
    /// Enable/Disable overload bypass function
    case overloadBypass     = "b"
    
    /// Enable/Disable power saving
    case powerSaving        = "j"
    
    /// Enable/Disable LCD display escape to default page after 1min timeout
    case displayTimeout     = "k"
    
    /// Enable/Disable overload restart
    case overloadRestart    = "u"
    
    /// Enable/Disable over temperature restart
    case temperatureRestart = "v"
    
    /// Enable/Disable backlight on
    case backlight          = "x"
    
    /// Enable/Disable alarm on when primary source interrupt
    case alarm              = "y"
    
    /// Enable/Disable fault code record
    case recordFault        = "z"
}

// MARK: - Query

public extension FlagStatus {
    
    /// Device Flag Status Inquiry
    struct Query: QueryCommand {
        
        public static var commandType: CommandType { .query(.flagStatus) }
        
        public init() { }
    }
}

public extension FlagStatus.Query {
    
    /// Device Flag Status Inquiry Response
    struct Response: ResponseProtocol, Equatable, Hashable, Codable {
        
        internal static let regularExpression = try! NSRegularExpression(pattern: #"(?:(E[abjkuvxyz]+))*(?:(D[abjkuvxyz]+))*"#, options: [])
        
        public let enabled: Set<FlagStatus>
        
        public let disabled: Set<FlagStatus>
        
        internal init(enabled: Set<FlagStatus> = [],
                      disabled: Set<FlagStatus> = []) {
            
            self.enabled = enabled
            self.disabled = disabled
        }
        
        public init?(response: String) {
            // (ExxxDxxx <CRC><cr>
            var enabled = Set<FlagStatus>()
            var disabled = Set<FlagStatus>()
            let matches = type(of: self).regularExpression.matches(in: response, options: [])
            guard let match = matches.first,
                match.first.flatMap({ String($0) }) == response,
                match.count >= 2,
                match.count <= 3
                else { return nil }
            let groups = match.suffix(from: 1)
            for group in groups {
                guard let type = group.first.flatMap({ Status(rawValue: String($0)) })
                    else { return nil }
                let flagString = group.suffix(from: group.index(after: group.startIndex))
                let flags = flagString.compactMap { FlagStatus(rawValue: String($0)) }
                guard flags.count == flagString.count
                    else { return nil }
                switch type {
                case .enabled:
                    assert(enabled.isEmpty)
                    enabled.reserveCapacity(flagString.count)
                    flags.forEach { enabled.insert($0) }
                case .disabled:
                    assert(disabled.isEmpty)
                    disabled.reserveCapacity(flagString.count)
                    flags.forEach { disabled.insert($0) }
                }
            }
            self.init(
                enabled: enabled,
                disabled: disabled
            )
        }
    }
}

internal extension FlagStatus.Query.Response {
    
    enum Status: String {
        case enabled = "E"
        case disabled = "D"
    }
}

// MARK: - Setting

public extension FlagStatus {
    
    struct Setting: SettingCommand, Equatable, Hashable, Codable {
        
        public typealias Response = Acknowledgement
        
        public static var commandType: CommandType { return .setting(.flagEnable) }
        
        public var enabled: Set<FlagStatus>
        
        public var disabled: Set<FlagStatus>
        
        public init(enabled: Set<FlagStatus> = [],
                      disabled: Set<FlagStatus> = []) {
            
            self.enabled = enabled
            self.disabled = disabled
        }
        
        public var rawValue: String {
            return (enabled.isEmpty ? "" : (Status.enabled.rawValue + enabled.map({ $0.rawValue }).sorted().reduce("", { $0 + $1 })))
                + (disabled.isEmpty ? "" : (Status.disabled.rawValue + disabled.map({ $0.rawValue }).sorted().reduce("", { $0 + $1 })))
        }
    }
}

internal extension FlagStatus.Setting {
    
    enum Status: String {
        case enabled = "PE"
        case disabled = "PD"
    }
}
