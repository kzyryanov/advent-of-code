//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle08() {
    print("Test")
    print("One")
    one(input: testInput08)
    print("Two")
    two(input: testInput08)

    print("")
    print("Real")
    print("One")
    one(input: input08)
    print("Two")
    two(input: input08)
}

private func one(input: String) {
    let grid = input.components(separatedBy: "\n")
        .map {
            $0.map {
                $0.wholeNumberValue!
            }
        }
    var visibleTreesCount = 2 * grid.count + 2 * (grid.first!.count - 2) // Count edge

    for rowIndex in 1..<(grid.count-1) {
        let row = grid[rowIndex]
        for columnIndex in 1..<(row.count - 1) {
            let treeHeight = row[columnIndex]
            var visibleDirections = 4
            for r in (0...rowIndex-1).reversed() {
                if treeHeight <= grid[r][columnIndex] {
                    visibleDirections -= 1
                    break
                }
            }

            for r in rowIndex+1..<grid.count {
                if treeHeight <= grid[r][columnIndex] {
                    visibleDirections -= 1
                    break
                }
            }

            for c in (0...columnIndex-1).reversed() {
                if treeHeight <= grid[rowIndex][c] {
                    visibleDirections -= 1
                    break
                }
            }

            for c in columnIndex+1..<row.count {
                if treeHeight <= grid[rowIndex][c] {
                    visibleDirections -= 1
                    break
                }
            }

            if visibleDirections > 0 {
                visibleTreesCount += 1
            }
        }
    }

    print("Result: \(visibleTreesCount)")
}

private func two(input: String) {
    let grid = input.components(separatedBy: "\n")
        .map {
            $0.map {
                $0.wholeNumberValue!
            }
        }
    var scenicScores = Array(repeating: Array(repeating: 0, count: grid.first!.count), count: grid.count)

    for rowIndex in 1..<(grid.count-1) {
        let row = grid[rowIndex]
        for columnIndex in 1..<(row.count - 1) {
            let treeHeight = row[columnIndex]
            var scenicScore = 1

            var trees = 0
            for r in (0...rowIndex-1).reversed() {
                trees += 1
                if treeHeight <= grid[r][columnIndex] {
                    break
                }
            }
            scenicScore *= trees

            trees = 0
            for r in rowIndex+1..<grid.count {
                trees += 1
                if treeHeight <= grid[r][columnIndex] {
                    break
                }
            }
            scenicScore *= trees

            trees = 0
            for c in (0...columnIndex-1).reversed() {
                trees += 1
                if treeHeight <= grid[rowIndex][c] {
                    break
                }
            }
            scenicScore *= trees

            trees = 0
            for c in columnIndex+1..<row.count {
                trees += 1
                if treeHeight <= grid[rowIndex][c] {
                    break
                }
            }
            scenicScore *= trees

            scenicScores[rowIndex][columnIndex] = scenicScore
        }
    }

    let maxScore = scenicScores.map { $0.max()! }.max()!
    print("Result: \(maxScore)")
}
