import XCTest
@testable import Homework_24

final class TestInputCode: XCTestCase {

    func test_givenObject_whenOperationNil_thenNil() {
        
        let inputCode = InputCode(rawValue: 5)
        
        let currentOperation = inputCode?.operation
        XCTAssertEqual(currentOperation, nil)
    }
}
