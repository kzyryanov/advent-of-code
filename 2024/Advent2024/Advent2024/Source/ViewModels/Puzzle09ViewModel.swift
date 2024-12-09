//
//  Puzzle09ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-09.
//

import SwiftUI

@Observable
final class Puzzle09ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String) async -> String {
        let diskMap: [Int] = input.trimmingCharacters(in: .whitespacesAndNewlines).enumerated().flatMap { index, character in
            let blocks = character.wholeNumberValue!
            if index % 2 == 0 {
                return Array(repeating: index / 2, count: blocks)
            } else {
                return Array(repeating: -1, count: blocks)
            }
        }

        var defragmentedDiskMap: [Int] = dropEmptyTail(diskMap)

        var index = 0
        while index < defragmentedDiskMap.count {
            if defragmentedDiskMap[index] < 0 {
                while index < defragmentedDiskMap.count {
                    let last = defragmentedDiskMap.removeLast()
                    if last >= 0 {
                        defragmentedDiskMap[index] = last
                        break
                    }
                }
            }
            index += 1
        }

        defragmentedDiskMap = dropEmptyTail(defragmentedDiskMap)

        let result = checksum(of: defragmentedDiskMap)

        return "\(result)"
    }

    private func dropEmptyTail(_ array: [Int]) -> [Int] {
        array.reversed().drop(while: {
            $0 < 0
        }).reversed()
    }

    private func checksum(of array: [Int]) -> Int {
        array.enumerated().reduce(0) { acc, element in
            acc + max(0, element.offset * element.element)
        }
    }

    func solveTwo(input: String) async -> String {
        let diskMap: [Int] = input.trimmingCharacters(in: .whitespacesAndNewlines).enumerated().flatMap { index, character in
            let blocks = character.wholeNumberValue!
            if index % 2 == 0 {
                return Array(repeating: index / 2, count: blocks)
            } else {
                return Array(repeating: -1, count: blocks)
            }
        }

        var defragmentedDiskMap = diskMap

        var tailIndex = defragmentedDiskMap.count - 1

        var sortedIds: Set<Int> = []

        while tailIndex >= 0 {
            while tailIndex >= 0, defragmentedDiskMap[tailIndex] < 0 {
                tailIndex -= 1
            }

            let id = defragmentedDiskMap[tailIndex]

            if sortedIds.contains(id) {
                tailIndex -= 1
                continue
            }

            var fileSize = 1

            while tailIndex >= 1, defragmentedDiskMap[tailIndex-1] == id {
                tailIndex -= 1
                fileSize += 1
            }

            var headIndex = 0
            var freeSpaceCount = 0

            while headIndex < tailIndex, fileSize > freeSpaceCount {
                while headIndex < defragmentedDiskMap.count,
                      headIndex < tailIndex,
                      defragmentedDiskMap[headIndex] >= 0 {
                    headIndex += 1
                }

                freeSpaceCount = 1

                while headIndex + freeSpaceCount < defragmentedDiskMap.count, defragmentedDiskMap[headIndex + freeSpaceCount] < 0 {
                    freeSpaceCount += 1
                }

                if fileSize > freeSpaceCount {
                    headIndex += 1
                }
            }

            if headIndex >= tailIndex {
                tailIndex -= 1
                continue
            }

            for i in 0..<fileSize {
                defragmentedDiskMap[headIndex + i] = id
                defragmentedDiskMap[tailIndex + i] = -1
                sortedIds.insert(id)
            }

            tailIndex -= 1
        }

        let result = checksum(of: defragmentedDiskMap)

        return "\(result)"
    }
}
