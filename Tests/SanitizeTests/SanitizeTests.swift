import XCTest
@testable import Sanitize

class sanitizeTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Sanitize().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
