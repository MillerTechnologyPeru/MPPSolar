//
//  FlagStatus.swift
//  
//
//  Created by Alsey Coleman Miller on 7/27/20.
//

import Foundation

/// MPP Solar Status Flags
public enum FlagStatus: String, CaseIterable {
    
    /// Enable/disable silence buzzer or open buzzer
    case buzzer             = "A"
    
    /// Enable/Disable overload bypass function
    case overloadBypass     = "B"
    
    /// Enable/Disable power saving
    case powerSaving        = "J"
    
    /// Enable/Disable LCD display escape to default page after 1min timeout
    case displayTimeout     = "K"
    
    /// Enable/Disable overload restart
    case overloadRestart    = "U"
    
    /// Enable/Disable over temperature restart
    case temperatureRestart = "V"
    
    /// Enable/Disable backlight on
    case backlight          = "X"
    
    /// Enable/Disable alarm on when primary source interrupt
    case alarm              = "Y"
    
    /// Enable/Disable fault code record
    case recordFault        = "Z"
}

// MARK: - Query

public extension FlagStatus {
    
    /// Device Protocol ID Inquiry
    struct Inquiry: InquiryCommand {
        
        public static var commandType: CommandType { .inquiry(.flagStatus) }
        
        public init() { }
    }
}

public extension FlagStatus.Inquiry {
    
    /// Device Protocol ID Inquiry Response
    struct Response: ResponseProtocol, Equatable, Hashable {
        
        internal static let regularExpression = try! NSRegularExpression(pattern: #"(?:(E[ABJKUVXYZ]+))*(?:(D[ABJKUVXYZ]+))*"#, options: [])
        
        public let enabled: Set<FlagStatus>
        
        public let disabled: Set<FlagStatus>
        
        internal init(enabled: Set<FlagStatus> = [],
                      disabled: Set<FlagStatus> = []) {
            
            self.enabled = enabled
            self.disabled = disabled
        }
        
        public init?(rawValue: String) {
            // (ExxxDxxx <CRC><cr>
            var enabled = Set<FlagStatus>()
            var disabled = Set<FlagStatus>()
            let matches = type(of: self).regularExpression.matches(in: rawValue, options: [])
            guard let match = matches.first,
                match.first.flatMap({ String($0) }) == rawValue,
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

internal extension FlagStatus.Inquiry.Response {
    
    enum Status: String {
        case enabled = "E"
        case disabled = "D"
    }
}
