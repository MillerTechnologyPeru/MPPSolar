import Foundation
import XCTest
@testable import MPPSolar

final class MPPSolarTests: XCTestCase {
    
    static let allTests = [
        ("testChecksum", testChecksum),
        ("testDeviceProtocolIDInquiry", testDeviceProtocolIDInquiry),
        ("testDeviceMode", testDeviceMode)
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
         Sent [81, 80, 73, 190, 172, 13]
         Recieved [40, 80, 73, 51, 48, 154, 11, 13]
         Protocol ID: 30
         */
        
        let commandData = Data([81, 80, 73, 190, 172, 13])
        XCTAssertEqual(commandData, ProtocolID.Inquiry().data)
        
        let responseData = Data([40, 80, 73, 51, 48, 154, 11, 13])
        guard let (response, responseChecksum, expectedChecksum) = ProtocolID.Inquiry.Response.parse(responseData)
            else { XCTFail("Cannot parse"); return }
        XCTAssertEqual(response.protocolID, 30)
        XCTAssertEqual(responseChecksum, expectedChecksum)
        XCTAssertEqual(responseChecksum, 0x9a0b)
    }
    
    func testDeviceSerialNumberInquiry() {
        
        /**
         Sent [81, 73, 68, 214, 234, 13]
         Recieved [40, 57, 50, 54, 51, 49, 56, 48]
         Serial Number: 92631
         */
        
        let commandData = Data([81, 73, 68, 214, 234, 13])
        XCTAssertEqual(commandData, SerialNumber.Inquiry().data)
        
        let responseData = Data([40, 57, 50, 54, 51, 49, 56, 48])
        guard let (response, responseChecksum, expectedChecksum) = SerialNumber.Inquiry.Response.parse(responseData)
            else { XCTFail("Cannot parse"); return }
        XCTAssertEqual(response.serialNumber, "92631807100358")
        XCTAssertEqual(responseChecksum, expectedChecksum)
        XCTAssertEqual(responseChecksum, 0x97d9)
    }
    
    func testDeviceMode() {
                
        let responseData = Data([40, 66, 231, 201, 13, 0, 0, 0])
        
        guard let (response, responseChecksum, expectedChecksum) = DeviceMode.Inquiry.Response.parse(responseData)
            else { XCTFail("Cannot parse"); return }
        
        XCTAssertEqual(response.mode, .battery)
        XCTAssertEqual(responseChecksum, expectedChecksum)
    }
    
    func testGeneralStatus() {
        
        let responseString = "001.0 00.0 228.0 60.0 0000 0000 000 334 23.75 000 051 0463 0000 000.0 23.83 00001 10010000 00 03 00000 000"
        
        let status = GeneralStatus(rawValue: responseString)
        
        dump(status)
    }
}
