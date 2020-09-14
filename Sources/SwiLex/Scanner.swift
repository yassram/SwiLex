//
//  Scanner.swift
//  SwiLex
//
//  Created by Yassir Ramdani on 06/09/2020.
//  Copyright © 2020 Yassir Ramdani. All rights reserved.
//

import Foundation

extension SwiLex {
    struct Scanner<Tokens: SwiLexable> {
        private let input: String
        private(set) var index: String.Index
        private(set) var currentLineNumber: Int

        init(input: String) {
            self.input = input
            index = self.input.startIndex
            currentLineNumber = 0
        }
    }
}

extension SwiLex.Scanner {
    private var end: String.Index { input.endIndex }
    var reachedEnd: Bool { index == end }
    var remainingString: Substring { input[index...] }

    private mutating func next() {
        index = input.index(after: index)
    }

    func buffer(to index: String.Index) -> Substring {
        input[self.index ..< index]
    }

    mutating func move(to index: String.Index) {
        currentLineNumber += buffer(to: index).filter { $0 == "\n" }.count
        self.index = index
    }

    mutating func removeSeparators() {
        while !reachedEnd {
            if Tokens.separators.contains(input[index]) {
                currentLineNumber += input[index] == "\n" ? 1 : 0
                next()
            } else { break }
        }
    }
}
