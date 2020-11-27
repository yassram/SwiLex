@testable import SwiLex
import XCTest

final class CalculatorTokensTests: XCTestCase {
    enum CalculatorTokens: String, SwiLexable {
        static var separators: Set<Character> = [" ", "\n"]
        case op = "[+-/*]"
        case float = "[0-9]+.[0-9]+"
        case int = "[0-9]+"
        case lParenthesis = #"\("#
        case rParenthesis = #"\)"#

        case eof
        case none
    }

    func testIntSum() throws {
        var lexer = SwiLex<CalculatorTokens>()
        let tokens = try lexer.lex(input: "1 + 1")
        AssertEqualTokens(tokens1: tokens,
                          tokens2: [
                            Token<CalculatorTokens>(type: .int, value: "1"),
                            Token<CalculatorTokens>(type: .op, value: "+"),
                            Token<CalculatorTokens>(type: .int, value: "1"),
                            Token<CalculatorTokens>(type: .eof, value: ""),
                          ])
    }

    func testFloatSum() throws {
        var lexer = SwiLex<CalculatorTokens>()
        let tokens = try lexer.lex(input: "1.2   +      1.004")
        AssertEqualTokens(tokens1: tokens,
                          tokens2: [
                            Token<CalculatorTokens>(type: .float, value: "1.2"),
                            Token<CalculatorTokens>(type: .op, value: "+"),
                            Token<CalculatorTokens>(type: .float, value: "1.004"),
                            Token<CalculatorTokens>(type: .eof, value: ""),
                          ])
    }

    func testFloatIntSum() throws {
        var lexer = SwiLex<CalculatorTokens>()
        let tokens = try lexer.lex(input: "   1332.4322  +       1   ")
        AssertEqualTokens(tokens1: tokens,
                          tokens2: [
                            Token<CalculatorTokens>(type: .float, value: "1332.4322"),
                            Token<CalculatorTokens>(type: .op, value: "+"),
                            Token<CalculatorTokens>(type: .int, value: "1"),
                            Token<CalculatorTokens>(type: .eof, value: ""),
                          ])
    }

    func testComplexEprssion() throws {
        var lexer = SwiLex<CalculatorTokens>()
        let tokens = try lexer.lex(input: "( 1332.4322  +       1   ) *2 / 44.44 + ((2.3- 2) * 4  )   / 0.3       ")
        print(tokens)
        AssertEqualTokens(tokens1: tokens,
                          tokens2: [
                            Token<CalculatorTokens>(type: .lParenthesis, value: "("),
                            Token<CalculatorTokens>(type: .float, value: "1332.4322"),
                            Token<CalculatorTokens>(type: .op, value: "+"),
                            Token<CalculatorTokens>(type: .int, value: "1"),
                            Token<CalculatorTokens>(type: .rParenthesis, value: ")"),
                            Token<CalculatorTokens>(type: .op, value: "*"),
                            Token<CalculatorTokens>(type: .int, value: "2"),
                            Token<CalculatorTokens>(type: .op, value: "/"),
                            Token<CalculatorTokens>(type: .float, value: "44.44"),
                            Token<CalculatorTokens>(type: .op, value: "+"),
                            Token<CalculatorTokens>(type: .lParenthesis, value: "("),
                            Token<CalculatorTokens>(type: .lParenthesis, value: "("),
                            Token<CalculatorTokens>(type: .float, value: "2.3"),
                            Token<CalculatorTokens>(type: .op, value: "-"),
                            Token<CalculatorTokens>(type: .int, value: "2"),
                            Token<CalculatorTokens>(type: .rParenthesis, value: ")"),
                            Token<CalculatorTokens>(type: .op, value: "*"),
                            Token<CalculatorTokens>(type: .int, value: "4"),
                            Token<CalculatorTokens>(type: .rParenthesis, value: ")"),
                            Token<CalculatorTokens>(type: .op, value: "/"),
                            Token<CalculatorTokens>(type: .float, value: "0.3"),
                            Token<CalculatorTokens>(type: .eof, value: ""),
                          ])
    }

    static var allTests = [
        ("testIntSum", testIntSum),
        ("testFloatSum", testFloatSum),
        ("testFloatIntSum", testFloatIntSum),
        ("testComplexEprssion", testComplexEprssion),
    ]

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
}
