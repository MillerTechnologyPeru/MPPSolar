//
//  main.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation
import MPPSolar

do {
    
    guard let solarDevice = MPPSolar(path: "/dev/hidraw0")
        else { error("Unable to find attached devices") }
    
    let mode = try solarDevice.send(DeviceModeInquiry())
    print("Mode: \(mode)")
}
catch let solarError {
    error(solarError.localizedDescription)
}

func error(_ message: String) -> Never {
    print("⚠️ Error: \(message)")
    exit(1)
}
