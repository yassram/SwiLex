import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(WordNumberTokensTests.allTests),
            testCase(CalculatorTokensTests.allTests),
        ]
    }
#endif
