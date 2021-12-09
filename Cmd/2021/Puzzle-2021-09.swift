//
//  Puzzle-2021-09.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-12-09.
//

import Foundation

func puzzle2021_09() {
    one()
    two()
}

fileprivate func one() {
    print("One")
    let input = puzzle2021_09_input()

    var sum: Int = 0

    for row in 0..<input.count {
        let rowValues = input[row]
        for column in 0..<rowValues.count {
            let value = rowValues[column]

            if row > 0 && value >= input[row-1][column] {
                continue
            }
            if row < input.count-1 && value >= input[row+1][column] {
                continue
            }
            if column > 0 && value >= input[row][column-1] {
                continue
            }
            if column < rowValues.count-1 && value >= input[row][column+1] {
                continue
            }

            sum += (value + 1)
        }
    }

    print(sum)
}

fileprivate struct Index: Hashable {
    let row, column: Int
}

fileprivate func two() {
    print("Two")

    let input = puzzle2021_09_input()

    var basinSizes: [Int] = []

    for row in 0..<input.count {
        let rowValues = input[row]
        for column in 0..<rowValues.count {
            let value = rowValues[column]

            if row > 0 && value >= input[row-1][column] {
                continue
            }
            if row < input.count-1 && value >= input[row+1][column] {
                continue
            }
            if column > 0 && value >= input[row][column-1] {
                continue
            }
            if column < rowValues.count-1 && value >= input[row][column+1] {
                continue
            }

            var indices: Set<Index> = []

            func basinIndex(_ index: Index) {
                let value = input[index.row][index.column]
                if value == 9 {
                    return
                }
                indices.insert(index)
                if index.row > 0 && value < input[index.row-1][index.column] {
                    basinIndex(Index(row: index.row-1, column: index.column))
                }
                if index.row < input.count-1 && value < input[index.row+1][index.column] {
                    basinIndex(Index(row: index.row+1, column: index.column))
                }
                if index.column > 0 && value < input[index.row][index.column-1] {
                    basinIndex(Index(row: index.row, column: index.column-1))
                }
                if index.column < input[row].count-1 && value < input[index.row][index.column+1] {
                    basinIndex(Index(row: index.row, column: index.column+1))
                }
            }
            let index = Index(row: row, column: column)
            basinIndex(index)
            basinSizes.append(indices.count)
        }
    }

    let result = basinSizes.sorted(by: >)
    if result.count >= 3 {
        print(result[0...2].reduce(1, *))
        return
    }
    print("Not found")
}
