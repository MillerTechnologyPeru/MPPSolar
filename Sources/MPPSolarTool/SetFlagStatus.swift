//
//  FlagStatus.swift
//  
//
//  Created by Alsey Coleman Miller on 2/27/23.
//


import Foundation
import MPPSolar
import ArgumentParser

private typealias Setting = FlagStatus.Setting

private typealias FlagParameter = FlagStatus

extension SolarTool {
    
    struct SetFlagStatus: SolarToolCommand {
        
        static let configuration = CommandConfiguration(abstract: "Set the device flag status.")
        
        @OptionGroup()
        var options: Options
        
        func run(device: MPPSolar) throws {
            var command = Setting()
            let options: [FlagParameter: Bool?] = [
                .buzzer: options.buzzer,
                .overloadBypass: options.overloadBypass,
                .powerSaving: options.powerSaving,
                .displayTimeout: options.displayTimeout,
                .overloadRestart: options.overloadRestart,
                .temperatureRestart: options.temperatureRestart,
                .backlight: options.backlight,
                .alarm: options.alarm,
                .recordFault: options.recordFault
            ]
            command.enabled = Set(options
                .filter { $0.value == true }
                .map { $0.key })
            command.disabled = Set(options
                .filter { $0.value == false }
                .map { $0.key })
            let _ = try device.send(command)
        }
    }
}

extension SolarTool.SetFlagStatus {
    
    struct Options: ParsableArguments {
        
        @Option(help: "The special file path to the solar device.")
        var path = "/dev/hidraw0"
        
        @Option(help: "Enable/Disable silence buzzer or open buzzer")
        var buzzer: Bool?
        
        @Option(help: "Enable/Disable overload bypass function")
        var overloadBypass: Bool?
        
        @Option(help: "Enable/Disable power saving")
        var powerSaving: Bool?
        
        @Option(help: "Enable/Disable LCD display escape to default page after 1 min timeout")
        var displayTimeout: Bool?
        
        @Option(help: "Enable/Disable overload restart")
        var overloadRestart: Bool?
        
        @Option(help: "Enable/Disable over temperature restart")
        var temperatureRestart: Bool?
        
        @Option(help: "Enable/Disable backlight on")
        var backlight: Bool?
        
        @Option(help: "Enable/Disable alarm on when primary source interrupt")
        var alarm: Bool?
        
        @Option(help: "Enable/Disable fault code record")
        var recordFault: Bool?
    }
    
    var path: String { return options.path }
}
