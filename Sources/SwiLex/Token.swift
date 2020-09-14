//
//  Token.swift
//  SwiLex
//
//  Created by Yassir Ramdani on 05/09/2020.
//  Copyright © 2020 Yassir Ramdani. All rights reserved.
//

import Foundation

// MARK: Public interface

/// An extracted token.
public struct Token<Tokens: SwiLexable>: CustomStringConvertible {
    // MARK: Properties

    /// The type of the token.
    public var type: Tokens
    /// The raw substring value of the matched token.
    public var value: Substring

    /// A default description for *pretty* prints.
    public var description: String {
        return "\(type)[\(value)]"
    }
}

extension Token: Equatable {
    public static func == (lhs: Token<Tokens>, rhs: Token<Tokens>) -> Bool {
        return lhs.type == rhs.type && lhs.value == rhs.value
    }
}
