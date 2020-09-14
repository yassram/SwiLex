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
