//
//  Status.swift
//  
//
//  Created by Alsey Coleman Miller on 7/26/20.
//

import Foundation
import MPPSolar
import ArgumentParser

extension SolarTool {
    
    struct Status: SolarToolCommand {
        
        static let configuration = CommandConfiguration(abstract: "Read the device general status.")
        
        @OptionGroup()
        var options: Options
        
        func run(device: MPPSolar) async throws {
            let generalStatus = try await device.send(GeneralStatus.Query())
            print("General Status:")
            dump(generalStatus)
        }
    }
}

extension SolarTool.Status {
    
    struct Options: ParsableArguments {
        
        @Option(help: "The special file path to the solar device.")
        var path = "/dev/hidraw0"
    }
    
    var path: String { return options.path }
}
