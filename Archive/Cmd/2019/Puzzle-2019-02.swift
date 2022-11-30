//
//  Puzzle-2019-02.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-11-27.
//

import Foundation

func puzzle2019_02() {
    one()
    two()
}

fileprivate enum State {
    enum Command: Int {
        case addition = 1
        case multiplication = 2
    }

    case initial
    case command(Command)
    case firstIndex(Command, Int)
    case twoIndices(Command, Int, Int)
}

fileprivate func one() {
    let input = puzzle2019_02_input()

    print(solve(input: input, noun: 12, verb: 2))
}

fileprivate func two() {
    let target = 19690720

    for noun in 0..<99 {
        for verb in 0..<99 {
            if solve(input: puzzle2019_02_input(), noun: noun, verb: verb) == target {
                print("noun: \(noun) verb: \(verb)")
                return
            }
        }
    }

    print("none")
}

fileprivate func solve(input: [Int], noun: Int, verb: Int) -> Int {
    var input = input
    input[1] = noun
    input[2] = verb

    var state = State.initial

    loop: for index in 0..<input.count {
        let value = input[index]
        switch state {
        case .initial:
            if value == 99 {
                break loop
            }
            guard let command = State.Command(rawValue: value) else {
                fatalError("Unknown Command")
            }
            state = .command(command)
        case .command(let command):
            state = .firstIndex(command, value)
        case .firstIndex(let command, let firstIndex):
            state = .twoIndices(command, firstIndex, value)
        case .twoIndices(let command, let firstIndex, let secondIndex):
            let first = input[firstIndex]
            let second = input[secondIndex]
            let result: Int
            switch command {
            case .addition: result = first + second
            case .multiplication: result = first * second
            }
            input[value] = result
            state = .initial
        }
    }
    return input[0]
}

fileprivate func puzzle2019_02_input() -> [Int] {
    [1,0,0,3,
     1,1,2,3,
     1,3,4,3,
     1,5,0,3,
     2,13,1,19,
     1,19,10,23,
     2,10,23,27,
     1,27,6,31,
     1,13,31,35,
     1,13,35,39,
     1,39,10,43,
     2,43,13,47,
     1,47,9,51,
     2,51,13,55,
     1,5,55,59,
     2,59,9,63,
     1,13,63,67,
     2,13,67,71,
     1,71,5,75,
     2,75,13,79,
     1,79,6,83,
     1,83,5,87,
     2,87,6,91,
     1,5,91,95,
     1,95,13,99,
     2,99,6,103,
     1,5,103,107,
     1,107,9,111,
     2,6,111,115,
     1,5,115,119,
     1,119,2,123,
     1,6,123,0,
     99,
     2,14,0,0]
}
