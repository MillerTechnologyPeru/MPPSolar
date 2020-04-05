//
//  main.swift
//  
//
//  Created by Alsey Coleman Miller on 4/4/20.
//

import Foundation
import MPPSolar

func error(_ message: String) -> Never {
    print("⚠️ Error: \(message)")
    exit(1)
}

do {
    // get device
    guard let solarDevice = MPPSolar(path: "/dev/hidraw0")
        else { error("Unable to find attached devices") }
    
    // query values
    let mode = try solarDevice.send(DeviceMode.Inquiry()).mode
    print("Mode:", mode)
    let protocolID = try solarDevice.send(ProtocolID.Inquiry()).protocolID
    print("Protocol ID:", protocolID)
    let serialNumber = try solarDevice.send(SerialNumber.Inquiry()).serialNumber
    print("Serial Number:", serialNumber)
    let generalStatus = try solarDevice.send(GeneralStatus.Inquiry())
    print("General Status:")
    dump(generalStatus)
}
catch let solarError {
    error("\(solarError)")
}
