//
//  PuzzleViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-03.
//

import SwiftUI

protocol PuzzleViewModel: Observable, AnyObject, Sendable {
    var puzzle: Puzzle { get }

    func solveOne(input: String) async -> String
    func solveTwo(input: String) async -> String
}

extension PuzzleViewModel {
    func testSolveOne(index: Int) async -> String {
        let clock = ContinuousClock()
        var answer: String!
        let result = await clock.measure {
            answer = await solveOne(input: puzzle.testInputs[index])
        }
        debugPrint("Time \(puzzle.name) test one: \(result)")

        return answer
    }

    func testSolveTwo(index: Int) async -> String {
        let clock = ContinuousClock()
        var answer: String!
        let result = await clock.measure {
            answer = await solveTwo(input: puzzle.testInputs[index])
        }
        debugPrint("Time \(puzzle.name) test two: \(result)")
        return answer
    }

    func solveOne() async -> String {
        let clock = ContinuousClock()
        var answer: String!
        let result = await clock.measure {
            answer = await solveOne(input: puzzle.input)
        }
        debugPrint("Time \(puzzle.name) one: \(result)")
        return answer
    }

    func solveTwo() async -> String {
        let clock = ContinuousClock()
        var answer: String!
        let result = await clock.measure {
            answer = await solveTwo(input: puzzle.input)
        }
        debugPrint("Time \(puzzle.name) two: \(result)")
        return answer
    }
}

struct Answer {
    var oneTest: [Int: String] = [:]
    var twoTest: [Int: String] = [:]
    var one: String = "One"
    var two: String = "Two"
}
