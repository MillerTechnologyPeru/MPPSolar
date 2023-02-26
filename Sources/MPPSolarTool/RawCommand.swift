//
//  RawCommand.swift
//  
//
//  Created by Alsey Coleman Miller on 7/26/20.
//

import Foundation
import MPPSolar
import ArgumentParser

extension SolarTool {
    
    struct RawCommand: SolarToolCommand {
        
        static let configuration = CommandConfiguration(
            commandName: "raw",
            abstract: "Send a raw command string and return response."
        )
        
        @OptionGroup()
        var options: Options
        
        func run(device: MPPSolar) throws {
            let response = try device.send(options.command)
            print(response)
        }
    }
}

extension SolarTool.RawCommand {
    
    struct Options: ParsableArguments {

        @Argument(help: "Raw command string.")
        var command: String
        
        @Option(help: "The special file path to the solar device.")
        var path = "/dev/hidraw0"
    }
    
    var path: String { return options.path }
}
