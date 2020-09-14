//
//  SwiLexable.swift
//  SwiLex
//
//  Created by Yassir Ramdani on 05/09/2020.
//  Copyright © 2020 Yassir Ramdani. All rights reserved.
//

import Foundation

// MARK: Public interface

/// A type of tokens that can be used to **lex** an input string using **SwiLex**.
public protocol SwiLexable: RawRepresentable, CaseIterable where Self.RawValue == String {
    /// Possible modes while Lexing.
    associatedtype Mode: Hashable = AnyHashable

    /// Characters used as sparators.
    ///
    /// Separators are ignored by the lexer and won't appear in the result token list.
    static var separators: Set<Character> { get }

    /// The pattern (*regular expression*) of the token.
    var pattern: String { get }
    /// The set of modes for which the token is active.
    ///
    /// SwiLex supports conditional tokens.
    ///
    /// Conditional tokens are tokens that are only availble if some specific modes are active.
    ///
    /// - note: If not set, all tokens are available by default.
    ///
    /// # Example
    /// In the bellow example, `.dubQuote` can be matched in both `.normal` and `.quote` modes
    /// (`.normal` mode to start a quote and `.quote` mode to end it).
    ///
    /// `.quotedStr` can only be matched in `.quote` mode.
    ///
    /// ```
    /// var activeForModes: Set<Mode> {
    ///     switch self {
    ///         case .dubQuote:
    ///             return [.quote, .normal]
    ///         case .quotedStr:
    ///             return [.quote]
    ///         default:
    ///             return [.normal]
    ///     }
    /// }
    /// ```
    ///
    var activeForModes: Set<Mode> { get }

    /// This function is called whenever a substring matches a token to perform actions on the matched string.
    ///
    /// - Parameters:
    ///     - raw: The matched substring.
    func onLex(raw: Substring)

    /// This function is called whenever a substring matches a token to update the **current mode** if multiple modes are used.
    ///
    /// This function is used to support conditional tokens.
    ///
    /// # Example
    /// In the bellow example, we use changeMode to switch between the `.normal` and the `.quote` mode each time a `.dubQuote` is matched.
    ///
    /// By changing the **current mode** we can enable / disable a set of tokens.
    ///
    /// ```
    /// func changeMode(current mode: Mode?) -> Mode? {
    ///     switch self {
    ///         case .dubQuote:
    ///             return mode == .normal ? .quote : .normal
    ///         default:
    ///             return mode
    ///     }
    /// }
    /// ```
    ///
    /// - note: By changing the current mode, only tokens for witch the attribute **activeForModes** contains the new mode are **active**.
    ///
    /// - Parameters:
    ///     - mode: The current active mode.
    func changeMode(current mode: Mode?) -> Mode?
}

// MARK: Default implementation

public extension SwiLexable {
    /// The pattern (*regular expression*) of the token.
    /// By default the token's pattern is its rawValue.
    var pattern: String { rawValue }

    /// The set of modes for which the token is active.
    /// By default it is an empty set.
    var activeForModes: Set<Mode> { [] }

    /// This function is called whenever a substring matches a token to perform actions on the matched string.
    /// By default this function does nothing,
    ///
    /// - Parameters:
    ///     - raw: The matched substring.
    func onLex(raw _: Substring) {}

    /// This function is called whenever a substring matches a token to update the **current mode** if multiple modes are used.
    /// By default the current mode does not change.
    /// - Parameters:
    ///     - mode: The current active mode.
    func changeMode(current mode: Mode?) -> Mode? { return mode }
}
