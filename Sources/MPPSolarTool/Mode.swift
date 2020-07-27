//
//  Mode.swift
//  
//
//  Created by Alsey Coleman Miller on 7/26/20.
//

import Foundation
import MPPSolar
import ArgumentParser

extension SolarTool {
    
    struct Mode: SolarToolCommand {
        
        static let configuration = CommandConfiguration(abstract: "Read the device mode.")
        
        @OptionGroup()
        var options: Options
        
        func run(device: MPPSolar) throws {
            let mode = try device.send(DeviceMode.Inquiry()).mode
            print("Mode:", mode)
        }
    }
}

extension SolarTool.Mode {
    
    struct Options: ParsableArguments {
        
        @Option(default: "/dev/hidraw0", help: "The special file path to the solar device.")
        var path: String
    }

    var path: String { return options.path }
}
