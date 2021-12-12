//
//  Puzzle-2021-11.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-12-12.
//

import Foundation

func puzzle2021_11() {
    one()
    two()
}

fileprivate func one() {
    print("One")

    var input = puzzle2021_11_input()

    var flashes: Int = 0

    func increaseEnergy(_ row: Int, _ column: Int) {
        if row < 0 || row >= input.count {
            return
        }
        let columnItems = input[row]
        if column < 0 || column >= columnItems.count {
            return
        }

        input[row][column] += 1
        if input[row][column] == 10 {
            increaseEnergy(row - 1, column - 1)
            increaseEnergy(row - 1, column)
            increaseEnergy(row - 1, column + 1)

            increaseEnergy(row, column - 1)
            increaseEnergy(row, column + 1)

            increaseEnergy(row + 1, column - 1)
            increaseEnergy(row + 1, column)
            increaseEnergy(row + 1, column + 1)
        }
    }

    for _ in 1...100 {
        // Increase energy
        for rowIndex in 0..<input.count {
            let row = input[rowIndex]
            for columnIndex in 0..<row.count {
                increaseEnergy(rowIndex, columnIndex)
            }
        }
        // Reset energy
        for rowIndex in 0..<input.count {
            let row = input[rowIndex]
            for columnIndex in 0..<row.count {
                if input[rowIndex][columnIndex] > 9 {
                    flashes += 1
                    input[rowIndex][columnIndex] = 0
                }
            }
        }
    }
    print(flashes)
}

fileprivate func two() {
    print("Two")

    var input = puzzle2021_11_input()

    func increaseEnergy(_ row: Int, _ column: Int) {
        if row < 0 || row >= input.count {
            return
        }
        let columnItems = input[row]
        if column < 0 || column >= columnItems.count {
            return
        }

        input[row][column] += 1
        if input[row][column] == 10 {
            increaseEnergy(row - 1, column - 1)
            increaseEnergy(row - 1, column)
            increaseEnergy(row - 1, column + 1)

            increaseEnergy(row, column - 1)
            increaseEnergy(row, column + 1)

            increaseEnergy(row + 1, column - 1)
            increaseEnergy(row + 1, column)
            increaseEnergy(row + 1, column + 1)
        }
    }

    var step = 1
    while true { // 🤪
        // Increase energy
        for rowIndex in 0..<input.count {
            let row = input[rowIndex]
            for columnIndex in 0..<row.count {
                increaseEnergy(rowIndex, columnIndex)
            }
        }
        // Reset energy
        var flashes: Int = 0

        for rowIndex in 0..<input.count {
            let row = input[rowIndex]
            for columnIndex in 0..<row.count {
                if input[rowIndex][columnIndex] > 9 {
                    flashes += 1
                    input[rowIndex][columnIndex] = 0
                }
            }
        }
        if flashes == input.count * input.first!.count {
            print(step)
            return
        }
        step += 1
    }
}
