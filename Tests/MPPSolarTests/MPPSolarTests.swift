import Foundation
import XCTest
@testable import MPPSolar

final class MPPSolarTests: XCTestCase {
    
    func testDevice() {
        
        XCTAssertNil(MPPSolar(path: "/dev/tty0-invalid"))
    }
    
    func testCommandType() {
        
        let commandType = CommandType.query(.protocolID)
        XCTAssertEqual(commandType.rawValue, "QPI")
        XCTAssertEqual(commandType.description, "QPI")
        XCTAssertEqual(commandType, CommandType(rawValue: "QPI"))
        XCTAssertNotEqual(commandType, CommandType(rawValue: "PF"))
    }
    
    func testChecksum() {

        /**
         DEBUG:MPP-Solar:Generate full command for QMOD
         DEBUG:MPP-Solar:Calculating CRC for QMOD
         DEBUG:MPP-Solar:Generated CRC 49 c1 49c1
         DEBUG:MPP-Solar:Full command: QMODI?
         */
        let command = DeviceMode.Query()
        let checksum = Checksum(calculate: Data(command.rawValue.utf8))
        XCTAssertEqual(checksum, 0x49c1)
        XCTAssertEqual(checksum, command.checksum)
        XCTAssertEqual(checksum.description, "0x49C1")
        XCTAssertNotEqual(checksum, 0x00)
        XCTAssertEqual(checksum, Checksum(data: checksum.data))
        XCTAssertEqual(0x00, Checksum(calculate: Data()))
        XCTAssertEqual(0x00, Checksum(calculate: "".utf8))
    }
    
    func testDeviceProtocolIDInquiry() {
        
        /**
         Command: [81, 80, 73, 190, 172, 13]
         Response: [40, 80, 73, 51, 48, 154, 11, 13]
         Protocol ID: 30
         */
        
        let command = ProtocolID.Query()
        let commandData = Data([81, 80, 73, 190, 172, 13])
        XCTAssertEqual(command.data, commandData)
        XCTAssertEqual(command.checksum, 0xBEAC)
        XCTAssertEqual(command.rawValue, "QPI")
        XCTAssertEqual(command.description, "QPI")
        
        let responseData = Data([40, 80, 73, 51, 48, 154, 11, 13])
        guard let (response, responseChecksum, expectedChecksum) = ProtocolID.Query.Response.parse(responseData)
            else { XCTFail("Cannot parse"); return }
        XCTAssertEqual(response.protocolID, 30)
        XCTAssertEqual(response.protocolID.description, "30")
        XCTAssertEqual(responseChecksum, expectedChecksum)
        XCTAssertEqual(responseChecksum, 0x9a0b)
        
        let solarDevice = MPPSolar.test(commands: [commandData], responses: [responseData])
        XCTAssertEqual(try? solarDevice.send(command), response)
    }
    
    func testDeviceSerialNumberInquiry() {
        
        /**
         Command: [81, 73, 68, 214, 234, 13]
         Response: [40, 57, 50, 54, 51, 49, 56, 48, 55, 49, 48, 48, 51, 53, 56, 151, 217, 13, 0, 0, 0, 0, 0, 0]
         Serial Number: 92631807100358
         */
        
        let command = SerialNumber.Query()
        let commandData = Data([81, 73, 68, 214, 234, 13])
        XCTAssertEqual(command.data, commandData)
        XCTAssertEqual(command.checksum, 0xd6ea)
        XCTAssertEqual(command.rawValue, "QID")
        XCTAssertEqual(command.description, "QID")
        
        let responseData = Data([40, 57, 50, 54, 51, 49, 56, 48, 55, 49, 48, 48, 51, 53, 56, 151, 217, 13, 0, 0, 0, 0, 0, 0])
        guard let (response, responseChecksum, expectedChecksum) = SerialNumber.Query.Response.parse(responseData)
            else { XCTFail("Cannot parse"); return }
        XCTAssertEqual(response.serialNumber, "92631807100358")
        XCTAssertEqual(response.serialNumber.description, "92631807100358")
        XCTAssertEqual(responseChecksum, expectedChecksum)
        XCTAssertEqual(responseChecksum, 0x97d9)
        
        let solarDevice = MPPSolar.test(commands: [commandData], responses: [responseData])
        XCTAssertEqual(try? solarDevice.send(command), response)
    }
    
    func testDeviceModeInquiry() {
        
        /**
         Command: [81, 77, 79, 68, 73, 193, 13]
         Response: [40, 66, 231, 201, 13, 0, 0, 0]
         Mode: battery
         */
                
        let command = DeviceMode.Query()
        let commandData = Data([81, 77, 79, 68, 73, 193, 13])
        XCTAssertEqual(command.data, commandData)
        XCTAssertEqual(command.checksum, 0x49c1)
        XCTAssertEqual(command.rawValue, "QMOD")
        
        let responseData = Data([40, 66, 231, 201, 13, 0, 0, 0])
        guard let (response, responseChecksum, expectedChecksum) = DeviceMode.Query.Response.parse(responseData)
            else { XCTFail("Cannot parse"); return }
        XCTAssertEqual(response, .battery)
        XCTAssertEqual(responseChecksum, expectedChecksum)
        XCTAssertEqual(responseChecksum, 0xE7C9)
        
        let solarDevice = MPPSolar.test(commands: [commandData], responses: [responseData])
        XCTAssertEqual(try? solarDevice.send(command), response)
    }
    
    func testGeneralStatusInquiry() throws {
        
        /**
         Command: [81, 80, 73, 71, 83, 183, 169, 13]
         Response: [40, 48, 48, 49, 46, 48, 32, 48, 48, 46, 48, 32, 50, 50, 57, 46, 48, 32, 54, 48, 46, 48, 32, 48, 48, 48, 48, 32, 48, 48, 48, 48, 32, 48, 48, 48, 32, 51, 53, 48, 32, 50, 52, 46, 56, 51, 32, 48, 48, 53, 32, 48, 52, 53, 32, 48, 52, 50, 50, 32, 48, 48, 48, 54, 32, 48, 50, 52, 46, 53, 32, 50, 52, 46, 56, 57, 32, 48, 48, 48, 48, 48, 32, 49, 48, 48, 49, 48, 49, 49, 48, 32, 48, 48, 32, 48, 51, 32, 48, 48, 49, 53, 55, 32, 48, 48, 48, 189, 115, 13, 0, 0]
         */
        
        let command = GeneralStatus.Query()
        let commandData = Data([81, 80, 73, 71, 83, 183, 169, 13])
        XCTAssertEqual(command.data, commandData)
        XCTAssertEqual(command.checksum, 0xb7a9)
        XCTAssertEqual(command.rawValue, "QPIGS")
        
        let responseData = Data([40, 48, 48, 49, 46, 48, 32, 48, 48, 46, 48, 32, 50, 50, 57, 46, 48, 32, 54, 48, 46, 48, 32, 48, 48, 48, 48, 32, 48, 48, 48, 48, 32, 48, 48, 48, 32, 51, 53, 48, 32, 50, 52, 46, 56, 51, 32, 48, 48, 53, 32, 48, 52, 53, 32, 48, 52, 50, 50, 32, 48, 48, 48, 54, 32, 48, 50, 52, 46, 53, 32, 50, 52, 46, 56, 57, 32, 48, 48, 48, 48, 48, 32, 49, 48, 48, 49, 48, 49, 49, 48, 32, 48, 48, 32, 48, 51, 32, 48, 48, 49, 53, 55, 32, 48, 48, 48, 189, 115, 13, 0, 0])
        guard let (responseString, responseChecksum, expectedChecksum) = responseData.parseSolarResponse() else {
            XCTFail("Cannot parse")
            return
        }
        XCTAssertEqual(responseString, "001.0 00.0 229.0 60.0 0000 0000 000 350 24.83 005 045 0422 0006 024.5 24.89 00000 10010110 00 03 00157 000")
        let response = try GeneralStatus(response: responseString, log: { print("MPPSolarDecoder:", $0) })
        XCTAssertEqual(responseChecksum, expectedChecksum)
        XCTAssertEqual(responseChecksum, 0xBD73)
        XCTAssertEqual(response.gridVoltage, 1.0)
        XCTAssertEqual(response.gridFrequency, 0.0)
        XCTAssertEqual(response.outputVoltage, 229.0)
        XCTAssertEqual(response.outputFrequency, 60.0)
        XCTAssertEqual(response.outputApparentPower, 0)
        XCTAssertEqual(response.outputActivePower, 0)
        XCTAssertEqual(response.outputLoadPercent, 0)
        XCTAssertEqual(response.busVoltage, 350)
        XCTAssertEqual(response.batteryVoltage, 24.83)
        XCTAssertEqual(response.flags.description, "[.chargingStatusSCC, .isCharging, .isLoadEnabled, .addSBUPriorityVersion]")
        XCTAssertEqual(response.flags, [.chargingStatusSCC, .isCharging, .isLoadEnabled, .addSBUPriorityVersion])
        
        dump(response)
        
        let solarDevice = MPPSolar.test(commands: [commandData], responses: [responseData])
        XCTAssertEqual(try? solarDevice.send(command), response)
    }
    
    func testFlagStatusInquiry() {
        
        let testResponses: [String: FlagStatus.Query.Response] = [
            "EakxyzDbjuv": .init(
                enabled: [.buzzer, .backlight, .displayTimeout, .alarm, .recordFault],
                disabled: [.temperatureRestart, .powerSaving, .overloadBypass, .overloadRestart]
            )
        ]
        
        for (string, response) in testResponses {
            XCTAssertEqual(FlagStatus.Query.Response(response: string), response)
        }
    }
    
    func testFirmwareVersion() {
        
        let versions: [(String, FirmwareVersion)] = [
            ("00000.00", FirmwareVersion(series: 0x00000, version: 0x00)),
            ("00079.50", FirmwareVersion(series: 0x00079, version: 0x50)),
            ("00123.01", FirmwareVersion(series: 0x00123, version: 0x01))
        ]
        
        for (rawValue, version) in versions {
            XCTAssertEqual(FirmwareVersion(rawValue: rawValue), version)
            XCTAssertEqual(version.rawValue, rawValue)
        }
        
        XCTAssertEqual(FirmwareVersion.Query.Response(response: "VERFW:00079.50")?.version, FirmwareVersion(series: 0x00079, version: 0x50))
        XCTAssertEqual(FirmwareVersion.Query.Secondary.Response(response: "VERFW2:00000.00")?.version, FirmwareVersion())
    }
    
    func testWarningStatus() {
        let testResponses: [(String, WarningStatus)]  = [
            ("00000000000000000000000000000000", []),
            ("00000000000000000000000000000010", [.inverterFault]),
            ("00000000000000000000000000000110", [.inverterFault, .busOver]),
            ("00100000000000000000000000000000", [.batteryLowCharge]),
            ("00000100000000000000000000000000000000", 0b00000100000000000000000000000000000000),
        ]
        for (response, status) in testResponses {
            XCTAssertEqual(WarningStatus(response: response), status)
        }
    }

    func testDeviceRatingInformation() throws {
        let rawValue = "120.0 25.0 120.0 60.0 13.0 3000 2400 24.0 23.0 21.0 28.2 27.0 0 30 060 0 0 2 6 10 0 0 27.0 0 1"
        let rating = try DeviceRating(response: rawValue, log: { print("MPPSolarDecoder:", $0) })
        dump(rating)
    }
}

// MARK: - Supporting Types

internal extension MPPSolar {
    
    final class Test: MPPSolarConnection {
        
        var commands = [Data]()
        
        var responses = [Data]()
        
        init() { }
        
        func send(_ data: Data) throws {
            guard commands.first == data
                else { throw POSIXError(.EBADF) }
            commands.removeFirst()
        }
        
        func recieve(_ size: Int) throws -> Data {
            guard let response = responses.first
                else { throw POSIXError(.EBADF) }
            responses.removeFirst()
            return response
        }
    }
}

internal extension MPPSolar {
    
    static func test(commands: [Data], responses: [Data]) -> MPPSolar {
        let connection = MPPSolar.Test()
        connection.commands = commands
        connection.responses = responses
        return MPPSolar(connection: connection)
    }
}
