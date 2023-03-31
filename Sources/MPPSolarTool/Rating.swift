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
    
    struct Rating: SolarToolCommand {
        
        static let configuration = CommandConfiguration(abstract: "Read the device rating information.")
        
        @OptionGroup()
        var options: Options
        
        func run(device: MPPSolar) async throws {
            let rating = try await device.send(Query())
            dump(rating)
        }
    }
}

extension SolarTool.Rating {
    
    struct Options: ParsableArguments {
        
        @Option(help: "The special file path to the solar device.")
        var path = "/dev/hidraw0"
    }
    
    var path: String { return options.path }
}
