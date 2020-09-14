//
//  TokensAssert.swift
//  SwiLex
//
//  Created by Yassir Ramdani on 12/09/2020.
//  Copyright © 2020 Yassir Ramdani. All rights reserved.
//

import SwiLex
import XCTest

func AssertEqualTokens<T: Equatable>(tokens1: [Token<T>], tokens2: [Token<T>]) {
    XCTAssertEqual(tokens1.count, tokens2.count, "Wrong tokens' number")
    for i in 0 ..< tokens1.count {
        XCTAssertEqual(tokens1[i].type, tokens2[i].type, "Wrong token's type at index \(i)")
        XCTAssertEqual(tokens1[i].value, tokens2[i].value, "Wrong token's value at index \(i)")
    }
}
