//
//  Command.swift
//  
//
//  Created by Alsey Coleman Miller on 7/26/20.
//

import Foundation
import MPPSolar
import ArgumentParser

protocol SolarToolCommand: ParsableCommand {
    
    var path: String { get }
    
    func run(device: MPPSolar) throws
}

extension SolarToolCommand {
    
    func run() throws {
        print("Loading solar device at \(path)")
        guard let solarDevice = MPPSolar(path: path)
            else { throw CommandError.deviceUnavailable }
        try run(device: solarDevice)
    }
}
