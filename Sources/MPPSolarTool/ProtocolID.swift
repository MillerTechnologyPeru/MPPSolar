//
//  ProtocolID.swift
//  
//
//  Created by Alsey Coleman Miller on 7/26/20.
//

import Foundation
import MPPSolar
import ArgumentParser

private typealias Query = ProtocolID.Query

extension SolarTool {
    
    struct ProtocolID: SolarToolCommand {
        
        static let configuration = CommandConfiguration(abstract: "Read the device protocol ID.")
        
        @OptionGroup()
        var options: Options
        
        func run(device: MPPSolar) async throws {
            let protocolID = try await device.send(Query()).protocolID
            print("Protocol ID:", protocolID)
        }
    }
}

extension SolarTool.ProtocolID {
    
    struct Options: ParsableArguments {
        
        @Option(help: "The special file path to the solar device.")
        var path = "/dev/hidraw0"
    }
    
    var path: String { return options.path }
}
