//
//  Regex.swift
//  SwiLex
//
//  Created by Yassir Ramdani on 05/09/2020.
//  Copyright © 2020 Yassir Ramdani. All rights reserved.
//

import Foundation

extension Substring {
    func matches(pattern: String) -> String.Index {
        guard let matchRange = range(of: pattern, options: .regularExpression),
            matchRange.lowerBound == startIndex
        else { return startIndex }
        return matchRange.upperBound
    }
}
