//
//  Command.swift
//  
//
//  Created by Alsey Coleman Miller on 7/26/20.
//

import Foundation
import MPPSolar
import ArgumentParser

protocol SolarToolCommand: AsyncParsableCommand {
    
    var path: String { get }
    
    func run(device: MPPSolar) async throws
}

extension SolarToolCommand {
    
    func run() async throws {
        print("Loading solar device at \(path)")
        guard let solarDevice = await MPPSolar(path: path)
            else { throw CommandError.deviceUnavailable }
        try await run(device: solarDevice)
    }
}
