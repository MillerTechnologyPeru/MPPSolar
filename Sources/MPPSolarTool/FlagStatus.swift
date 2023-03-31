//
//  FlagStatus.swift
//  
//
//  Created by Alsey Coleman Miller on 7/27/20.
//

import Foundation
import MPPSolar
import ArgumentParser

private typealias Query = FlagStatus.Query

extension SolarTool {
    
    struct FlagStatus: SolarToolCommand {
        
        static let configuration = CommandConfiguration(abstract: "Read the device flag status.")
        
        @OptionGroup()
        var options: Options
        
        func run(device: MPPSolar) async throws {
            let flags = try await device.send(Query())
            if flags.enabled.isEmpty == false {
                print("Enabled:")
                for flag in flags.enabled {
                    print("- \(flag.description)")
                }
            }
            if flags.disabled.isEmpty == false {
                print("Disabled:")
                for flag in flags.disabled {
                    print("- \(flag.description)")
                }
            }
        }
    }
}

extension SolarTool.FlagStatus {
    
    struct Options: ParsableArguments {
        
        @Option(help: "The special file path to the solar device.")
        var path = "/dev/hidraw0"
    }
    
    var path: String { return options.path }
}
