//
//  String+Extensions.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-01.
//

import Foundation

extension String {
    func indicesOf(string: String) -> [Int] {
        indices.reduce([], { $1.utf16Offset(in: self) > ($0.last ?? -1) && self[$1...].hasPrefix(string) ? ($0 + [$1.utf16Offset(in: self)]) : $0 })
    }
}
