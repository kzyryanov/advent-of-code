//
//  Collection+Extensions.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-02.
//

import Foundation

extension Collection {
    var isNotEmpty: Bool { !isEmpty }
}

extension StringProtocol {
    var lines: [SubSequence] { split(whereSeparator: \.isNewline) }
}
