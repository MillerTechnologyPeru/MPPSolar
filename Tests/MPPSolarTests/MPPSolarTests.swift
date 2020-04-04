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
        let command = DeviceModeInquiry()
        let checksum = Checksum(calculate: command.data)
        XCTAssertEqual(checksum, 0x49c1)
    }
}
