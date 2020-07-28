//
//  main.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation
import MPPSolar
import ArgumentParser

struct SolarTool: ParsableCommand {
        
    static let configuration = CommandConfiguration(
        abstract: "A utility for interacting with MPP Solar devices.",
        version: "1.0.0",
        subcommands: [
            Mode.self,
            ProtocolID.self,
            SerialNumber.self,
            Status.self,
            OutputFrequency.self
        ],
        defaultSubcommand: Status.self
    )
}

SolarTool.main()
