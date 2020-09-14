//
//  SwiLex.swift
//  SwiLex
//
//  Created by Yassir Ramdani on 05/09/2020.
//  Copyright © 2020 Yassir Ramdani. All rights reserved.
//

import Foundation

public struct SwiLex<Tokens: SwiLexable> {
    /// The active mode *if conditional tokens are used*.
    private var currentMode: Tokens.Mode?

    // MARK: Public interface

    public init() {}

    /// The lexing function.
    ///
    /// Lexes an input string using a **SwiLexable enum** that defines the available tokens and their **regular expressions**.
    ///
    /// - Returns: A list of Tokens from a **raw string** and a **SwiLexable enum** defining the available tokens and their **regular expressions**.
    ///
    /// - Parameters:
    ///     - input: The input string to be lexed.
    ///     - initialMode: The initial active mode if conditional tokens are used.
    ///
    ///
    /// # Example
    ///
    /// ```
    /// enum WordNumberTokens: String, SwiLexable {
    ///     static var separators: Set<Character> = [" "]
    ///     case txt = "[A-Za-z]*"
    ///     case number = "[0-9]*"
    /// }
    /// var lexer = SwiLex<WordNumberTokens>()
    /// let tokens = try lexer.lex(input: "  H3Ll0     W0r1d")
    /// // returns [txt[H], number[3], txt[Ll], number[0], txt[W], number[0], txt[r], number[1], txt[d]]
    /// ```
    /// - Note: More examples with complex cases and conditional tokens are available in the project documentation.
    @discardableResult
    public mutating func lex(input: String, initialMode: Tokens.Mode? = nil) throws -> [Token<Tokens>] {
        currentMode = initialMode

        var scanner = Scanner<Tokens>(input: input)
        scanner.removeSeparators()

        var stream = [Token<Tokens>]()

        while !scanner.reachedEnd {
            var longestMatch: Tokens?
            var longestMatchIndex = scanner.index
            for token in Tokens.allCases {
                if let currentMode = currentMode, !token.activeForModes.contains(currentMode) { continue }
                let currentMatchIndex = scanner.remainingString.matches(pattern: token.pattern)
                if currentMatchIndex > longestMatchIndex {
                    longestMatch = token
                    longestMatchIndex = currentMatchIndex
                }
            }

            guard let matchedToken = longestMatch else {
                throw SwiLexError.noTokenMatched(at: scanner.remainingString.prefix(20),
                                                 line: scanner.currentLineNumber)
            }

            let rawString = scanner.buffer(to: longestMatchIndex)
            let newToken = Token(type: matchedToken, value: rawString)
            stream.append(newToken)
            matchedToken.onLex(raw: rawString)
            currentMode = matchedToken.changeMode(current: currentMode)
            scanner.move(to: longestMatchIndex)
            scanner.removeSeparators()
        }

        return stream
    }
}
