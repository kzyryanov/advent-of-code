//
//  Puzzle-2021-02.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-12-02.
//

import Foundation

func puzzle2021_02() {
    print("Puzzle 2021 02")
    one()
    two()
}


fileprivate func one() {
    print("one")
    let input = puzzle2021_02_input()
    let position: (horizontal: Int, depth: Int) = input.reduce((0, 0)) { (partialResult: (horizontal: Int, depth: Int), direction: Puzzle2021_02.Direction) in
        switch direction {
        case .forward(let value):
            return (partialResult.horizontal + value, partialResult.depth)
        case .up(let value):
            return (partialResult.horizontal, partialResult.depth - value)
        case .down(let value):
            return (partialResult.horizontal, partialResult.depth + value)
        }
    }

    print(position.horizontal * position.depth)
}

fileprivate func two() {
    print("two")
    let input = puzzle2021_02_input()

    let position: (horizontal: Int, depth: Int, aim: Int) = input.reduce((0, 0, 0)) { (partialResult: (horizontal: Int, depth: Int, aim: Int), direction: Puzzle2021_02.Direction) in
        switch direction {
        case .forward(let value):
            return (partialResult.horizontal + value, partialResult.depth + value * partialResult.aim, partialResult.aim)
        case .up(let value):
            return (partialResult.horizontal, partialResult.depth, partialResult.aim - value)
        case .down(let value):
            return (partialResult.horizontal, partialResult.depth, partialResult.aim + value)
        }
    }

    print(position.horizontal * position.depth)
}
