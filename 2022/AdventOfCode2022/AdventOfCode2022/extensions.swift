//
//  extensions.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-05.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
