import Foundation
import XCTest
@testable import MPPSolar

final class MPPSolarTests: XCTestCase {
    
    static let allTests = [
        ("testChecksum", testChecksum),
        ("testDeviceProtocolIDInquiry", testDeviceProtocolIDInquiry),
        ("testDeviceModeInquiry", testDeviceModeInquiry)
    ]
    
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
        XCTAssertEqual(responseChecksum, expectedChecksum)
        XCTAssertEqual(responseChecksum, 0x97d9)
    }
    
    func testDeviceModeInquiry() {
        
        /**
         Command: [81, 77, 79, 68, 73, 193, 13]
         Response: [40, 66, 231, 201, 13, 0, 0, 0]
         Mode: battery
         */
        
        let responseData = Data([40, 66, 231, 201, 13, 0, 0, 0])
        let commandData = Data([81, 77, 79, 68, 73, 193, 13])
        
        let command = DeviceMode.Inquiry()
        let commandChecksum = Checksum(calculate: Data(command.rawValue.utf8))
        XCTAssertEqual(commandChecksum, 0x49c1)
                
        guard let (response, responseChecksum, expectedChecksum) = DeviceMode.Inquiry.Response.parse(responseData)
            else { XCTFail("Cannot parse"); return }
        
        XCTAssertEqual(response.mode, .battery)
        XCTAssertEqual(responseChecksum, expectedChecksum)
        XCTAssertEqual(responseChecksum, 0xE7C9)
    }
    
    func testGeneralStatus() {
        
        let responseString = "001.0 00.0 228.0 60.0 0000 0000 000 334 23.75 000 051 0463 0000 000.0 23.83 00001 10010000 00 03 00000 000"
        
        guard let status = GeneralStatus(rawValue: responseString)
            else { XCTFail("Cannot parse"); return }
        
        dump(status)
    }
}
