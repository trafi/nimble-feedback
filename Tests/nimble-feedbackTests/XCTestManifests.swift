import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(nimble_feedbackTests.allTests),
    ]
}
#endif
