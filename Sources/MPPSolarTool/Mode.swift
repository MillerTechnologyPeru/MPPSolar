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
            let mode = try device.send(DeviceMode.Query()).mode
            print("Mode:", mode)
        }
    }
}

extension SolarTool.Mode {
    
    struct Options: ParsableArguments {
        
        @Option(help: "The special file path to the solar device.")
        var path = "/dev/hidraw0"
    }

    var path: String { return options.path }
}
