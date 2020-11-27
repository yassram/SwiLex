//
//  Error.swift
//  SwiLex
//
//  Created by Yassir Ramdani on 12/09/2020.
//  Copyright © 2020 Yassir Ramdani. All rights reserved.
//

import Foundation

public enum SwiLexError: Error {
    case noTokenMatched(at: Substring, line: Int)
}

extension SwiLexError : LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .noTokenMatched(at: str, line: line):
            return "No token matched \(str), line: \(line)"
        }
    }
}
