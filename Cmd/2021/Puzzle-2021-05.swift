//
//  Puzzle-2021-05.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-12-07.
//

import Foundation

func puzzle2021_05() {
    one()
    two()
}

fileprivate func one() {
    let input = puzzle_2021_05_input()

    var field: [Puzzle2021_05.Point: Int] = [:]

    for line in input {
        if line.start.x == line.end.x {
            let min = min(line.start.y, line.end.y)
            let max = max(line.start.y, line.end.y)
            for y in min...max {
                let value = field[Puzzle2021_05.Point(x: line.start.x, y: y), default: 0]
                field[Puzzle2021_05.Point(x: line.start.x, y: y)] = value + 1
            }
        }

        if line.start.y == line.end.y {
            let min = min(line.start.x, line.end.x)
            let max = max(line.start.x, line.end.x)
            for x in min...max {
                let value = field[Puzzle2021_05.Point(x: x, y: line.start.y), default: 0]
                field[Puzzle2021_05.Point(x: x, y: line.start.y)] = value + 1
            }
        }
    }

    let result = field.filter({ $0.value >= 2 }).count
    print(result)
}

fileprivate func two() {
    let input = puzzle_2021_05_input()

    var field: [Puzzle2021_05.Point: Int] = [:]

    for line in input {
        if line.start.x == line.end.x {
            let min = min(line.start.y, line.end.y)
            let max = max(line.start.y, line.end.y)

            for y in min...max {
                let value = field[Puzzle2021_05.Point(x: line.start.x, y: y), default: 0]
                field[Puzzle2021_05.Point(x: line.start.x, y: y)] = value + 1
            }

        }

        if line.start.y == line.end.y {
            let min = min(line.start.x, line.end.x)
            let max = max(line.start.x, line.end.x)

            for x in min...max {
                let value = field[Puzzle2021_05.Point(x: x, y: line.start.y), default: 0]
                field[Puzzle2021_05.Point(x: x, y: line.start.y)] = value + 1
            }

        }

        if abs(line.start.x - line.end.x) == abs(line.start.y - line.end.y) {
            for x in stride(from: line.start.x, through: line.end.x, by: line.end.x > line.start.x ? 1 : -1) {
                for y in stride(from: line.start.y, through: line.end.y, by: line.end.y > line.start.y ? 1 : -1) {
                    if abs(line.start.x - x) == abs(line.start.y - y) {
                        let value = field[Puzzle2021_05.Point(x: x, y: y), default: 0]
                        field[Puzzle2021_05.Point(x: x, y: y)] = value + 1
                    }
                }
            }
        }
    }

    let result = field.filter({ $0.value >= 2 }).count
    print(result)
}
