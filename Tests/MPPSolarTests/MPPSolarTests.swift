import Foundation
import XCTest
@testable import MPPSolar

final class MPPSolarTests: XCTestCase {
    
    static let allTests = [
        ("testChecksum", testChecksum),
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
    }
    
    func testDeviceMode() {
                
        let responseData = Data([40, 66, 231, 201, 13, 0, 0, 0])
        
        guard let (response, responseChecksum, expectedChecksum) = DeviceMode.Inquiry.Response.parse(responseData)
            else { XCTFail("Cannot parse"); return }
        
        XCTAssertEqual(response.mode, .battery)
        XCTAssertEqual(responseChecksum, expectedChecksum)
    }
}
