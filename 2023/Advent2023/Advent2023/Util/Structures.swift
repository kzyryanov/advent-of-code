//
//  Structures.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-14.
//

import Foundation

struct Point: Hashable, Equatable, CustomStringConvertible {
    let x, y: Int

    var description: String {
        "{\(x), \(y)}"
    }
}
