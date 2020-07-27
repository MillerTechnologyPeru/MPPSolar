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
        
        func run(device: MPPSolar) throws {
            let generalStatus = try device.send(GeneralStatus.Inquiry())
            print("General Status:")
            dump(generalStatus)
        }
    }
}

extension SolarTool.Status {
    
    struct Options: ParsableArguments {
        
        @Option(default: "/dev/hidraw0", help: "The special file path to the solar device.")
        var path: String
    }
    
    var path: String { return options.path }
}
