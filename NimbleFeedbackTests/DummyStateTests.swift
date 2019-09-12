import XCTest

class DummyStateTests: XCTestCase {

    var state: DummyState!

    override func setUp() {
        super.setUp()
        state = DummyState(lastEvent: nil)
    }

    func test_apply_dummyGetsAlpha() {
        state.apply(.alpha)
        XCTAssertEqual(.alpha, state.lastEvent)
    }

    func test_apply_dummyGetsNone() {
        state.apply(.none)
        XCTAssertNil(state.lastEvent)
    }

    func test_state_isAlpha() {
        XCTAssertNil(state.isAlpha)
        state.apply(.alpha)
        XCTAssertEqual(true, state.isAlpha)
    }

    func test_state_isNotAlpha() {
        XCTAssertNil(state.isAlpha)
        state.apply(.beta)
        XCTAssertEqual(false, state.isAlpha)
    }
}
