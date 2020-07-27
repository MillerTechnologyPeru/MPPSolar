//
//  SerialNumber.swift
//  
//
//  Created by Alsey Coleman Miller on 7/26/20.
//

import Foundation
import MPPSolar
import ArgumentParser

private typealias Inquiry = SerialNumber.Inquiry

extension SolarTool {
    
    struct SerialNumber: SolarToolCommand {
        
        static let configuration = CommandConfiguration(abstract: "Read the device serial number.")
        
        @OptionGroup()
        var options: Options
        
        func run(device: MPPSolar) throws {
            let serialNumber = try device.send(Inquiry()).serialNumber
            print("Serial Number:", serialNumber)
        }
    }
}

extension SolarTool.SerialNumber {
    
    struct Options: ParsableArguments {
        
        @Option(default: "/dev/hidraw0", help: "The special file path to the solar device.")
        var path: String
    }
    
    var path: String { return options.path }
}
