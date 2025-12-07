//
//  Puzzle06ViewModel.swift
//  Advent2025
//
//  Created by Konstantin on 2025-12-07.
//

import SwiftUI

@Observable
final class Puzzle06ViewModel: PuzzleViewModel {
    let puzzle: Puzzle
    
    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }
    
    func solveOne(input: String, isTest: Bool) async -> String {
        let data = data(from: input)
        
        let result = data.reduce(0, { (partialResult, element) in
            partialResult + element.operation.reduce(values: element.numbers)
        })
        
        return "\(result)"
    }
    
    func solveTwo(input: String, isTest: Bool) async -> String {
        let data = dataTwo(from: input)
        
        let result = data.reduce(0, { (partialResult, element) in
            partialResult + element.operation.reduce(values: element.numbers)
        })
        
        return "\(result)"
    }
    
    func data(from input: String) -> [(operation: Operation, numbers: [Int])] {
        let lines = input.lines.filter(\.isNotEmpty)
        
        var numbers: [[Int]] = []
        var operations: [Operation] = []
        
        for line in lines {
            let split = line.split(separator: " ")
                .filter(\.isNotEmpty)
            
            let values = split.compactMap {
                Int($0)
            }
            if values.isNotEmpty {
                numbers.append(values)
                continue
            }
            
            let ops = split.compactMap {
                Operation(rawValue: String($0))
            }
            if ops.isNotEmpty {
                operations = ops
            }
        }
        
        var parsed: [(operation: Operation, numbers: [Int])] = []
        for (index, operation) in operations.enumerated() {
            var values: [Int] = []
            
            for numbersRow in numbers {
                values.append(numbersRow[index])
            }
            
            parsed.append((operation, values))
        }
        
        return parsed
    }
    
    func dataTwo(from input: String) -> [(operation: Operation, numbers: [Int])] {
        let lines = input.lines.filter(\.isNotEmpty)
        
        var parsed: [(operation: Operation, numbers: [Int])] = []
        
        let lastLine = lines.last!
        let numbersCount = lines.count-1
        
        var numbers: [Int] = Array(repeating: 0, count: lastLine.count)
        
        for (i, symbol) in lastLine.enumerated().reversed() {
            for j in 0..<numbersCount {
                let symbol = Array(lines[j])[i]
                if let number = Int(String(symbol)) {
                    numbers[i] = numbers[i] * 10 + number
                }
            }
            
            if let operation = Operation(rawValue: String(symbol)) {
                parsed.append((operation, numbers.filter { $0 > 0 }))
                numbers = Array(repeating: 0, count: lastLine.count)
            }
        }
        
        return parsed
    }
}

extension Puzzle06ViewModel {
    enum Operation: String {
        case addition = "+"
        case multiplication = "*"
        
        func reduce(values: [Int]) -> Int {
            switch self {
            case .addition:
                return values.reduce(0, +)
            case .multiplication:
                return values.reduce(1, *)
            }
        }
    }
}
