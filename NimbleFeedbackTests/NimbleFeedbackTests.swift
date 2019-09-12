@testable import NimbleFeedback
import Nimble
import XCTest

class NimbleFeedbackTests: XCTestCase {

    var state: DummyState!

    override func setUp() {
        super.setUp()
        state = DummyState(lastEvent: nil)
    }

    func test_expectation_acceptsEvents() {
        let exp_00 = expect(self.state).after(.alpha)
        XCTAssertEqual([.alpha], exp_00.events)

        let exp_01 = expect(self.state).after([.alpha])
        XCTAssertEqual([.alpha], exp_01.events)
    }
}
