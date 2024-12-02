//
//  Puzzle01ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-01.
//

import SwiftUI

@Observable
final class Puzzle01ViewModel: PuzzleViewModel {
    var answer: Answer = Answer()

    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String) async -> String {
        let (firstList, secondList) = data(from: input)

        let sortedFirst = firstList.sorted()
        let sortedSecond = secondList.sorted()

        let distances = sortedFirst.enumerated().map { index, value in
            abs(value - sortedSecond[index])
        }

        let result = distances.reduce(0, +)

        return "\(result)"
    }

    func solveTwo(input: String) async -> String {
        let (firstList, secondList) = data(from: input)

        let groupedSecond = Dictionary(grouping: secondList, by: { $0 }).mapValues(\.count)

        let similarities = firstList.map { value in
            value * groupedSecond[value, default: 0]
        }

        let result = similarities.reduce(0, +)

        return "\(result)"
    }

    func data(from input: String) -> (fisrtList: [Int], secondList: [Int]) {
        let lines = input.lines.filter(\.isNotEmpty)

        var firstList: [Int] = []
        var secondList: [Int] = []

        for line in lines {
            let numbers = line.split(whereSeparator: \.isWhitespace).filter(\.isNotEmpty)

            if numbers.count == 2 {
                firstList.append(Int(numbers.first!)!)
                secondList.append(Int(numbers.last!)!)
            } else {
                fatalError()
            }
        }

        return (firstList, secondList)
    }
}
