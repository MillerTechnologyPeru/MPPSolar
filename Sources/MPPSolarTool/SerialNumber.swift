//
//  SerialNumber.swift
//  
//
//  Created by Alsey Coleman Miller on 7/26/20.
//

import Foundation
import MPPSolar
import ArgumentParser

private typealias Query = SerialNumber.Query

extension SolarTool {
    
    struct SerialNumber: SolarToolCommand {
        
        static let configuration = CommandConfiguration(abstract: "Read the device serial number.")
        
        @OptionGroup()
        var options: Options
        
        func run(device: MPPSolar) throws {
            let serialNumber = try device.send(Query()).serialNumber
            print("Serial Number:", serialNumber)
        }
    }
}

extension SolarTool.SerialNumber {
    
    struct Options: ParsableArguments {
        
        @Option(help: "The special file path to the solar device.")
        var path = "/dev/hidraw0"
    }
    
    var path: String { return options.path }
}
