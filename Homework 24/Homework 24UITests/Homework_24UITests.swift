import XCTest

final class UITests: XCTestCase {
    
    override func setUp() {
        
        continueAfterFailure = false
    }
    
    func test_givenApp_whenLaunching_thenCorrect() {

            XCUIApplication().launch()
    }
}
