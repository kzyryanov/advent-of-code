//
//  Puzzle-2021-13.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-12-13.
//

import Foundation

func puzzle2021_13() {
    one()
    two()
}

fileprivate func one(_ onlyFirstFold: Bool = true) {
    print("One")

    let input = puzzle2021_13_input()

    guard let maxX = input.points.map(\.x).max(),
          let maxY = input.points.map(\.y).max() else {
              fatalError()
          }

    var field = Array(repeating: Array(repeating: false, count: maxX+1), count: maxY+1)

    input.points.forEach({ field[$0.y][$0.x] = true })

    func printField() {
        field.forEach({
            $0.forEach { value in
                if value {
                    print("#", terminator: "")
                } else {
                    print(".", terminator: "")
                }
            }
            print("\n", terminator: "")
        })
    }

    for fold in input.folds {
        switch fold {
        case .x(let line):
            for i in 0...line {
                let leftIndex = line-i
                let rightIndex = line+i
                if leftIndex < 0 || rightIndex >= field[0].count {
                    break
                }
                for j in 0..<field.count {
                    field[j][leftIndex] = field[j][leftIndex] || field[j][rightIndex]
                }
            }
            field = field.map { Array($0[0..<line]) }
        case .y(let line):
            for i in 0...line {
                let upLineIndex = line-i
                let downLineIndex = line+i
                if upLineIndex < 0 || downLineIndex >= field.count {
                    break
                }
                for j in 0..<field[0].count {
                    field[upLineIndex][j] = field[upLineIndex][j] || field[downLineIndex][j]
                }
            }
            field = Array(field[0..<line])
        }
        if onlyFirstFold {
            break
        }
    }

    printField()

    let result = field.reduce(0, { $0 + $1.reduce(0, { $0 + ($1 ? 1 : 0) }) })
    print(result)
}

fileprivate func two() {
    print("Two")

    one(false)
}
