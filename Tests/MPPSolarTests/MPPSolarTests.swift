import Foundation
import XCTest
@testable import MPPSolar

final class MPPSolarTests: XCTestCase {
    
    static let allTests = [
        ("testChecksum", testChecksum),
    ]
    
    func testChecksum() {

        /**
         DEBUG:MPP-Solar:Generate full command for QID
         DEBUG:MPP-Solar:Calculating CRC for QID
         DEBUG:MPP-Solar:Generated CRC d6 ea d6ea
         DEBUG:MPP-Solar:Full command: QID??
         */
        let command = "QID"
        let checksum = Checksum(data: Data(command.utf8))
        XCTAssertEqual(checksum, 0xd6ea)
    }
}
