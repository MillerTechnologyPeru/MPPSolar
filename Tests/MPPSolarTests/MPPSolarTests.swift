import Foundation
import XCTest
@testable import MPPSolar

final class MPPSolarTests: XCTestCase {
    
    static let allTests = [
        ("testChecksum", testChecksum),
        ("testDeviceProtocolIDInquiry", testDeviceProtocolIDInquiry),
        ("testDeviceModeInquiry", testDeviceModeInquiry)
    ]
    
    func testCommandType() {
        
        let commandType = CommandType.inquiry(.protocolID)
        XCTAssertEqual(commandType.rawValue, "QPI")
        XCTAssertEqual(commandType.description, "QPI")
        XCTAssertEqual(commandType, CommandType(rawValue: "QPI"))
    }
    
    func testChecksum() {

        /**
         DEBUG:MPP-Solar:Generate full command for QMOD
         DEBUG:MPP-Solar:Calculating CRC for QMOD
         DEBUG:MPP-Solar:Generated CRC 49 c1 49c1
         DEBUG:MPP-Solar:Full command: QMODI?
         */
        let command = DeviceMode.Inquiry()
        let checksum = Checksum(calculate: Data(command.rawValue.utf8))
        XCTAssertEqual(checksum, 0x49c1)
        XCTAssertEqual(checksum, command.checksum)
        XCTAssertEqual(checksum.description, "0x49C1")
    }
    
    func testDeviceProtocolIDInquiry() {
        
        /**
         Command: [81, 80, 73, 190, 172, 13]
         Response: [40, 80, 73, 51, 48, 154, 11, 13]
         Protocol ID: 30
         */
        
        let command = ProtocolID.Inquiry()
        let commandData = Data([81, 80, 73, 190, 172, 13])
        XCTAssertEqual(command.data, commandData)
        XCTAssertEqual(command.checksum, 0xBEAC)
        XCTAssertEqual(command.rawValue, "QPI")
        XCTAssertEqual(command.description, "QPI")
        
        let responseData = Data([40, 80, 73, 51, 48, 154, 11, 13])
        guard let (response, responseChecksum, expectedChecksum) = ProtocolID.Inquiry.Response.parse(responseData)
            else { XCTFail("Cannot parse"); return }
        XCTAssertEqual(response.protocolID, 30)
        XCTAssertEqual(response.protocolID.description, "30")
        XCTAssertEqual(responseChecksum, expectedChecksum)
        XCTAssertEqual(responseChecksum, 0x9a0b)
    }
    
    func testDeviceSerialNumberInquiry() {
        
        /**
         Command: [81, 73, 68, 214, 234, 13]
         Response: [40, 57, 50, 54, 51, 49, 56, 48, 55, 49, 48, 48, 51, 53, 56, 151, 217, 13, 0, 0, 0, 0, 0, 0]
         Serial Number: 92631807100358
         */
        
        let command = SerialNumber.Inquiry()
        let commandData = Data([81, 73, 68, 214, 234, 13])
        XCTAssertEqual(command.data, commandData)
        XCTAssertEqual(command.checksum, 0xd6ea)
        XCTAssertEqual(command.rawValue, "QID")
        XCTAssertEqual(command.description, "QID")
        
        let responseData = Data([40, 57, 50, 54, 51, 49, 56, 48, 55, 49, 48, 48, 51, 53, 56, 151, 217, 13, 0, 0, 0, 0, 0, 0])
        guard let (response, responseChecksum, expectedChecksum) = SerialNumber.Inquiry.Response.parse(responseData)
            else { XCTFail("Cannot parse"); return }
        XCTAssertEqual(response.serialNumber, "92631807100358")
        XCTAssertEqual(response.serialNumber.description, "92631807100358")
        XCTAssertEqual(responseChecksum, expectedChecksum)
        XCTAssertEqual(responseChecksum, 0x97d9)
    }
    
    func testDeviceModeInquiry() {
        
        /**
         Command: [81, 77, 79, 68, 73, 193, 13]
         Response: [40, 66, 231, 201, 13, 0, 0, 0]
         Mode: battery
         */
                
        let command = DeviceMode.Inquiry()
        let commandData = Data([81, 77, 79, 68, 73, 193, 13])
        XCTAssertEqual(command.data, commandData)
        XCTAssertEqual(command.checksum, 0x49c1)
        XCTAssertEqual(command.rawValue, "QMOD")
        
        let responseData = Data([40, 66, 231, 201, 13, 0, 0, 0])
        guard let (response, responseChecksum, expectedChecksum) = DeviceMode.Inquiry.Response.parse(responseData)
            else { XCTFail("Cannot parse"); return }
        XCTAssertEqual(response.mode, .battery)
        XCTAssertEqual(responseChecksum, expectedChecksum)
        XCTAssertEqual(responseChecksum, 0xE7C9)
    }
    
    func testGeneralStatus() {
        
        /**
         Command: [81, 80, 73, 71, 83, 183, 169, 13]
         Response: [40, 48, 48, 49, 46, 48, 32, 48, 48, 46, 48, 32, 50, 50, 57, 46, 48, 32, 54, 48, 46, 48, 32, 48, 48, 48, 48, 32, 48, 48, 48, 48, 32, 48, 48, 48, 32, 51, 53, 48, 32, 50, 52, 46, 56, 51, 32, 48, 48, 53, 32, 48, 52, 53, 32, 48, 52, 50, 50, 32, 48, 48, 48, 54, 32, 48, 50, 52, 46, 53, 32, 50, 52, 46, 56, 57, 32, 48, 48, 48, 48, 48, 32, 49, 48, 48, 49, 48, 49, 49, 48, 32, 48, 48, 32, 48, 51, 32, 48, 48, 49, 53, 55, 32, 48, 48, 48, 189, 115, 13, 0, 0]
         General Status:
         ▿ MPPSolar.GeneralStatus
           - gridVoltage: 1.0
           - gridFrequency: 0.0
           - outputVoltage: 229.0
           - outputFrequency: 60.0
           - outputApparentPower: 0
           - outputActivePower: 0
           - outputLoadPercent: 0
           - busVoltage: 350
           - batteryVoltage: 24.83
           - batteryChargingCurrent: 5
           - batteryCapacity: 45
           - inverterHeatSinkTemperature: 422
           - solarInputCurrent: 6
           - solarInputVoltage: 24.5
           - batteryVoltageSCC: 24.89
           - batteryDischargeCurrent: 0
         */
        
        let command = GeneralStatus.Inquiry()
        let commandData = Data([81, 80, 73, 71, 83, 183, 169, 13])
        XCTAssertEqual(command.data, commandData)
        XCTAssertEqual(command.checksum, 0xb7a9)
        XCTAssertEqual(command.rawValue, "QPIGS")
        
        let responseData = Data([40, 48, 48, 49, 46, 48, 32, 48, 48, 46, 48, 32, 50, 50, 57, 46, 48, 32, 54, 48, 46, 48, 32, 48, 48, 48, 48, 32, 48, 48, 48, 48, 32, 48, 48, 48, 32, 51, 53, 48, 32, 50, 52, 46, 56, 51, 32, 48, 48, 53, 32, 48, 52, 53, 32, 48, 52, 50, 50, 32, 48, 48, 48, 54, 32, 48, 50, 52, 46, 53, 32, 50, 52, 46, 56, 57, 32, 48, 48, 48, 48, 48, 32, 49, 48, 48, 49, 48, 49, 49, 48, 32, 48, 48, 32, 48, 51, 32, 48, 48, 49, 53, 55, 32, 48, 48, 48, 189, 115, 13, 0, 0])
        guard let (response, responseChecksum, expectedChecksum) = GeneralStatus.Inquiry.Response.parse(responseData)
            else { XCTFail("Cannot parse"); return }
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
        
        dump(response)
    }
}
