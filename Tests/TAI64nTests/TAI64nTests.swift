import XCTest
@testable import TAI64n

final class TAI64nTests: XCTestCase {
	@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
    func testExample() throws {
		XCTAssertEqual(Date(tai64nLabel: "@400000000000000a00000000")?.timeIntervalSince1970, 0.0)
		XCTAssertEqual(Date(tai64nLabel: "@4000000063933b5d1cb6f99c")?.ISO8601Format(.iso8601(timeZone: .gmt, includingFractionalSeconds: true, dateSeparator: .dash, dateTimeSeparator: .space, timeSeparator: .colon)), "2022-12-09 13:42:43.481")
    }
}
