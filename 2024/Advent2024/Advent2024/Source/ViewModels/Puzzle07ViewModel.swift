//
//  Puzzle07ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-07.
//

import SwiftUI

@Observable
final class Puzzle07ViewModel: PuzzleViewModel {

    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    enum Operation: String, CustomStringConvertible {
        case add
        case multiply
        case concatenate

        var description: String { rawValue }
    }

    private func solveExpression(numbers: [Int], operations: [Operation]) -> Int {
        var stack: [Int] = numbers.reversed()

        for operation in operations {
            switch operation {
            case .add:
                stack.append(stack.popLast()! + stack.popLast()!)
            case .multiply:
                stack.append(stack.popLast()! * stack.popLast()!)
            case .concatenate:
                stack.append(Int("\(stack.popLast()!)\(stack.popLast()!)")!)
            }
        }

        return stack.last!
    }

    func solveOne(input: String, isTest: Bool) async -> String {
        let data = data(from: input)

        let totalCalibrationResult = await withTaskGroup(of: Int.self) { group in
            for (key, value) in data {
                group.addTask {
                    guard value.count > 1 else { return key == value.first ? key : 0 }

                    let operationsCount = value.count - 1

                    let variants = (pow(2, operationsCount) as NSDecimalNumber).intValue

                    for variant in 0..<variants {
                        var operations: [Operation] = []

                        for operationIndex in 0..<operationsCount {
                            if variant & (1 << operationIndex) == 0 {
                                operations.append(.add)
                            } else {
                                operations.append(.multiply)
                            }
                        }

                        let result = self.solveExpression(numbers: value, operations: operations)

                        if result == key {
                            return key
                        }
                    }

                    return 0
                }
            }

            return await group.reduce(0, +)
        }

        return "\(totalCalibrationResult)"
    }

    func solveTwo(input: String, isTest: Bool) async -> String {
        let data = data(from: input)

        let totalCalibrationResult = await withTaskGroup(of: Int.self) { group in
            for (key, value) in data {
                group.addTask {
                    guard value.count > 1 else { return key == value.first ? key : 0 }

                    let operationsCount = value.count - 1

                    let variants = (pow(3, operationsCount) as NSDecimalNumber).intValue

                    for variant in 0..<variants {
                        var operations: [Operation] = []

                        var number = variant

                        for _ in 0..<operationsCount {
                            let rest = number % 3
                            number /= 3

                            switch rest {
                            case 2: operations.append(.concatenate)
                            case 1: operations.append(.add)
                            case 0: operations.append(.multiply)
                            default: fatalError("Unknown operation \(rest)")
                            }
                        }

                        let result = self.solveExpression(numbers: value, operations: operations)

                        if result == key {
                            return key
                        }
                    }

                    return 0
                }
            }
            return await group.reduce(0, +)
        }

        return "\(totalCalibrationResult)"
    }

    func data(from input: String) -> [(Int, [Int])] {
        let lines = input.lines.filter(\.isNotEmpty)

        let data = lines.map { line in
            let split = line.split(separator: ":")

            let key = Int(split[0].trimmingCharacters(in: .whitespacesAndNewlines))!
            let values = split[1].split(separator: " ").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

            return (key, values.compactMap { Int($0) })
        }

        return data
    }
}
