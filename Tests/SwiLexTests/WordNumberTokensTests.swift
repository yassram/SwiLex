@testable import SwiLex
import XCTest

final class WordNumberTokensTests: XCTestCase {
    enum WordNumberTokens: String, SwiLexable {
        static var separators: Set<Character> = [" ", "\n"]
        case txt = "[A-Za-z]*"
        case number = "[0-9]*"
        
        case eof
        case none
    }

    func testWords() throws {
        var lexer = SwiLex<WordNumberTokens>()
        let tokens = try lexer.lex(input: "  HELLO  h i abc  ABC   Hi   hello         boy        XD")
        AssertEqualTokens(tokens1: tokens,
                          tokens2: [
                            Token<WordNumberTokens>(type: .txt, value: "HELLO"),
                            Token<WordNumberTokens>(type: .txt, value: "h"),
                            Token<WordNumberTokens>(type: .txt, value: "i"),
                            Token<WordNumberTokens>(type: .txt, value: "abc"),
                            Token<WordNumberTokens>(type: .txt, value: "ABC"),
                            Token<WordNumberTokens>(type: .txt, value: "Hi"),
                            Token<WordNumberTokens>(type: .txt, value: "hello"),
                            Token<WordNumberTokens>(type: .txt, value: "boy"),
                            Token<WordNumberTokens>(type: .txt, value: "XD"),
                            Token<WordNumberTokens>(type: .eof, value: ""),
                          ])
    }

    func testNumbers() throws {
        var lexer = SwiLex<WordNumberTokens>()
        let tokens = try lexer.lex(input: "  233 2    1  23123    3333333     324    33    2")
        AssertEqualTokens(tokens1: tokens,
                          tokens2: [
                            Token<WordNumberTokens>(type: .number, value: "233"),
                            Token<WordNumberTokens>(type: .number, value: "2"),
                            Token<WordNumberTokens>(type: .number, value: "1"),
                            Token<WordNumberTokens>(type: .number, value: "23123"),
                            Token<WordNumberTokens>(type: .number, value: "3333333"),
                            Token<WordNumberTokens>(type: .number, value: "324"),
                            Token<WordNumberTokens>(type: .number, value: "33"),
                            Token<WordNumberTokens>(type: .number, value: "2"),
                            Token<WordNumberTokens>(type: .eof, value: ""),
                          ])
    }

    func testWordsAndNumbers() throws {
        var lexer = SwiLex<WordNumberTokens>()
        let tokens = try lexer.lex(input: "  233 2    1  23123abc  ABC   Hi3333333     324    33    2")
        AssertEqualTokens(tokens1: tokens,
                          tokens2: [
                            Token<WordNumberTokens>(type: .number, value: "233"),
                            Token<WordNumberTokens>(type: .number, value: "2"),
                            Token<WordNumberTokens>(type: .number, value: "1"),
                            Token<WordNumberTokens>(type: .number, value: "23123"),
                            Token<WordNumberTokens>(type: .txt, value: "abc"),
                            Token<WordNumberTokens>(type: .txt, value: "ABC"),
                            Token<WordNumberTokens>(type: .txt, value: "Hi"),
                            Token<WordNumberTokens>(type: .number, value: "3333333"),
                            Token<WordNumberTokens>(type: .number, value: "324"),
                            Token<WordNumberTokens>(type: .number, value: "33"),
                            Token<WordNumberTokens>(type: .number, value: "2"),
                            Token<WordNumberTokens>(type: .eof, value: ""),
                          ])
    }

    static var allTests = [
        ("testWords", testWords),
        ("testNumbers", testNumbers),
        ("testWordsAndNumbers", testWordsAndNumbers),
    ]
}
