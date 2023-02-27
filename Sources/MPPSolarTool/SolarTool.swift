//
//  main.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation
import MPPSolar
import ArgumentParser

@main
struct SolarTool: ParsableCommand {
        
    static let configuration = CommandConfiguration(
        abstract: "A utility for interacting with MPP Solar devices.",
        version: "1.0.0",
        subcommands: [
            RawCommand.self,
            Mode.self,
            ProtocolID.self,
            SerialNumber.self,
            Status.self,
            FlagStatus.self,
            WarningStatus.self,
            Rating.self,
            OutputFrequency.self,
        ],
        defaultSubcommand: {
            #if os(Linux)
            return Status.self
            #else
            return nil
            #endif
        }()
    )
}
