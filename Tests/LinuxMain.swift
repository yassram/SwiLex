import XCTest

import SwiLexTests

var tests = [XCTestCaseEntry]()
tests += WordNumberTokensTests.allTests()
tests += CalculatorTokensTests.allTests()
XCTMain(tests)
