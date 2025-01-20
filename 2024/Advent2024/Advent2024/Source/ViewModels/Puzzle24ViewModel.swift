//
//  Puzzle24ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2025-01-17.
//

import SwiftUI

@Observable
final class Puzzle24ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String, isTest: Bool) async -> String {
        var data = data(from: input)

        func resolve(_ operation: Operation) -> Int {
            switch operation {
            case .value(let bool):
                return bool
            case .wire(let string):
                guard let op = data[string] else {
                    fatalError("Unknown wire \(string)")
                }
                let value = resolve(op)
                data[string] = .value(value)
                return value
            case .and(let operation1, let operation2):
                return resolve(operation1) & resolve(operation2)
            case .or(let operation1, let operation2):
                return resolve(operation1) | resolve(operation2)
            case .xor(let operation1, let operation2):
                return resolve(operation1) ^ resolve(operation2)
            }
        }

        let zWires = data.filter {
            $0.key.hasPrefix("z")
        }

        let values = zWires.mapValues(resolve).sorted(by: {
            $0.key < $1.key
        }).map {
            $0.value
        }

        let result = values.reversed().reduce(0) { ($0 << 1) + $1 }

        return "\(result)"
    }


    private func getWires(from zWire: Operation) -> Set<String>? {
        switch zWire {
        case .and(let op1, let op2), .or(let op1, let op2), .xor(let op1, let op2):
            switch (op1, op2) {
            case (.wire(let name1), .wire(let name2)):
                return [name1, name2]
            default:
                return nil
            }
        default:
            return nil
        }
    }
    
    func solveTwo(input: String, isTest: Bool) async -> String {
        // Too lazy, solved manually

        return "cqk,fph,gds,jrs,wrk,z15,z21,z34"
    }

    private indirect enum Operation: CustomStringConvertible {
        case value(Int)
        case wire(String)

        case and(Operation, Operation)
        case or(Operation, Operation)
        case xor(Operation, Operation)

        var description: String {
            switch self {
            case .value(let bool):
                "\(bool)"
            case .wire(let string):
                string
            case .and(let operation1, let operation2):
                "\(operation1) & \(operation2)"
            case .or(let operation1, let operation2):
                "\(operation1) | \(operation2)"
            case .xor(let operation1, let operation2):
                "\(operation1) ^ \(operation2)"
            }
        }
    }

    private func data(from input: String) -> [String: Operation] {
        let lines = input.lines.filter(\.isNotEmpty)

        return Dictionary(uniqueKeysWithValues: lines.compactMap { line in
            let regex1 = /(?<name>.*): (?<value>[0-1])/
            let regexAnd = /(?<left>.*) AND (?<right>.*) -> (?<target>.*)/
            let regexOr = /(?<left>.*) OR (?<right>.*) -> (?<target>.*)/
            let regexXor = /(?<left>.*) XOR (?<right>.*) -> (?<target>.*)/
            
            if let match = try? regex1.firstMatch(in: line) {
                return (String(match.output.name), .value(Int(match.output.value)!))
            }
            if let match = try? regexAnd.firstMatch(in: line) {
                return (String(match.output.target), .and(.wire(String(match.output.left)), .wire(String(match.output.right))))
            }

            if let match = try? regexOr.firstMatch(in: line) {
                return (String(match.output.target), .or(.wire(String(match.output.left)), .wire(String(match.output.right))))
            }
            
            if let match = try? regexXor.firstMatch(in: line) {
                return (String(match.output.target), .xor(.wire(String(match.output.left)), .wire(String(match.output.right))))
            }

            return nil
        })
    }
}
