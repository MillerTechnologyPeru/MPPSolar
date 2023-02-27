//
//  DeviceRating.swift
//  
//
//  Created by Alsey Coleman Miller on 2/27/23.
//


import Foundation
import MPPSolar
import ArgumentParser

private typealias Query = DeviceRating.Query

extension SolarTool {
    
    struct DeviceRating: SolarToolCommand {
        
        static let configuration = CommandConfiguration(abstract: "Read the device rating information.")
        
        @OptionGroup()
        var options: Options
        
        func run(device: MPPSolar) throws {
            let rating = try device.send(Query())
            dump(rating)
        }
    }
}

extension SolarTool.DeviceRating {
    
    struct Options: ParsableArguments {
        
        @Option(help: "The special file path to the solar device.")
        var path = "/dev/hidraw0"
    }
    
    var path: String { return options.path }
}
