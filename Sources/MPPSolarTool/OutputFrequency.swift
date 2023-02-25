//
//  File.swift
//  
//
//  Created by Alsey Coleman Miller on 7/27/20.
//

import Foundation
import MPPSolar
import ArgumentParser

private typealias Setting = OutputFrequency.Setting

extension SolarTool {
    
    struct OutputFrequency: SolarToolCommand {
        
        static let configuration = CommandConfiguration(abstract: "Set the AC output frequency.")
        
        @OptionGroup()
        var options: Options
        
        func run(device: MPPSolar) throws {
            try device.send(Setting(frequency: options.frequency))
            print("Set output frequency:", options.frequency)
        }
    }
}

extension SolarTool.OutputFrequency {
    
    struct Options: ParsableArguments {
        
        @Option(help: "The special file path to the solar device.")
        var path = "/dev/hidraw0"
        
        @Argument(help: "The desired output frequency.")
        var frequency: OutputFrequency
    }
    
    var path: String { return options.path }
}
