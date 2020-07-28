//
//  FlagStatus.swift
//  
//
//  Created by Alsey Coleman Miller on 7/27/20.
//

import Foundation
import MPPSolar
import ArgumentParser

private typealias Inquiry = FlagStatus.Inquiry

extension SolarTool {
    
    struct FlagStatus: SolarToolCommand {
        
        static let configuration = CommandConfiguration(abstract: "Read the flag status.")
        
        @OptionGroup()
        var options: Options
        
        func run(device: MPPSolar) throws {
            let flags = try device.send(Inquiry())
            if flags.enabled.isEmpty == false {
                print("Enabled:")
                for flag in flags.enabled {
                    print("\(flag)")
                }
            }
            if flags.disabled.isEmpty == false {
                print("Disable:")
                for flag in flags.disabled {
                    print("\(flag)")
                }
            }
        }
    }
}

extension SolarTool.FlagStatus {
    
    struct Options: ParsableArguments {
        
        @Option(default: "/dev/hidraw0", help: "The special file path to the solar device.")
        var path: String
    }
    
    var path: String { return options.path }
}
