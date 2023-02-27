//
//  WarningStatus.swift
//  
//
//  Created by Alsey Coleman Miller on 2/27/23.
//

import Foundation
import MPPSolar
import ArgumentParser

private typealias Query = WarningStatus.Query

extension SolarTool {
    
    struct WarningStatus: SolarToolCommand {
        
        static let configuration = CommandConfiguration(abstract: "Get the warning status.")
        
        @OptionGroup()
        var options: Options
        
        func run(device: MPPSolar) throws {
            let warningStatus = try device.send(Query())
            print("Warning Status: \(warningStatus.isEmpty ? "None" : warningStatus.description)")
        }
    }
}

extension SolarTool.WarningStatus {
    
    struct Options: ParsableArguments {
        
        @Option(help: "The special file path to the solar device.")
        var path = "/dev/hidraw0"
    }
    
    var path: String { return options.path }
}
