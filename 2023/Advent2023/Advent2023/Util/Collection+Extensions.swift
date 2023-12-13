//
//  Collection+Extensions.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-01.
//

import Foundation

extension Collection {
    var isNotEmpty: Bool { !isEmpty }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}

extension Collection where Self.Iterator.Element: Collection {
    var transpose: Array<Array<Self.Iterator.Element.Iterator.Element>> {
        var result = Array<Array<Self.Iterator.Element.Iterator.Element>>()
        if self.isEmpty {return result}

        var index = self.first!.startIndex
        while index != self.first!.endIndex {
            var subresult = Array<Self.Iterator.Element.Iterator.Element>()
            for subarray in self {
                subresult.append(subarray[index])
            }
            result.append(subresult)
            index = self.first!.index(after: index)
        }
        return result
    }
}
