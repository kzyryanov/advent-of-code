//
//  Puzzle17ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-17.
//

import SwiftUI

@Observable
final class Puzzle17ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String) async -> String {
        let computer = data(from: input)

        let result = computer.run().map(String.init).joined(separator: ",")

        return result
    }

    func solveTwo(input: String) async -> String {
        let computer = data(from: input)

        var checked: Set<Int> = []

        var foundA: Set<Int> = []

        var possibleAs: Set<Int> = Set(0...7)
        while possibleAs.isNotEmpty {
            let aPrefix = possibleAs.removeFirst()
            for a in 0..<8 {
                let targetA = (aPrefix << 3) | a
                if checked.contains(targetA) {
                    continue
                }
                checked.insert(targetA)
                let output = computer.run(overrideA: targetA)
                if output == computer.resultProgram {
                    foundA.insert(targetA)
                    break
                }
                if computer.resultProgram.suffix(output.count) == output {
                    possibleAs.insert(targetA)
                }
            }
        }

        if let min = foundA.min() {
            return "\(min)"
        }

        return "None"
    }

    private final class Computer {
        enum Instruction {
            case adv(Int)
            case bxl(Int)
            case bst(Int)
            case jnz(Int)
            case bxc(Int)
            case out(Int)
            case bdv(Int)
            case cdv(Int)

            init(instruction: Int, operand: Int) {
                switch instruction {
                case 0: self = .adv(operand)
                case 1: self = .bxl(operand)
                case 2: self = .bst(operand)
                case 3: self = .jnz(operand)
                case 4: self = .bxc(operand)
                case 5: self = .out(operand)
                case 6: self = .bdv(operand)
                case 7: self = .cdv(operand)
                default: fatalError("Unknown operation")
                }
            }
        }

        private var registerA: Int
        private var registerB: Int
        private var registerC: Int

        let program: [Instruction]
        let resultProgram: [Int]

        init(
            registerA: Int,
            registerB: Int,
            registerC: Int,
            program: [Instruction],
            resultProgram: [Int]
        ) {
            self.registerA = registerA
            self.registerB = registerB
            self.registerC = registerC
            self.program = program
            self.resultProgram = resultProgram
        }

        func run(overrideA: Int? = nil) -> [Int] {
            var output: [Int] = []

            if let overrideA {
                registerA = overrideA
            }

            var position: Int = 0

            while position < program.count {
                let instruction = program[position]

                switch instruction {
                case .adv(let operand): // 0
                    let result = registerA >> combo(operand)
                    registerA = result
                    position += 1
                case .bxl(let operand): // 1
                    let uintB = UInt(registerB)
                    let uintOperand = UInt(operand)
                    let result = uintB ^ uintOperand
                    registerB = Int(result)
                    position += 1
                case .bst(let operand): // 2
                    let result = combo(operand) % 8
                    registerB = result
                    position += 1
                case .jnz(let operand): // 3
                    if registerA == 0 {
                        position += 1
                    } else {
                        position = operand / 2
                    }
                case .bxc: // 4
                    let uintB = UInt(registerB)
                    let uintC = UInt(registerC)
                    let result = uintB ^ uintC
                    registerB = Int(result)
                    position += 1
                case .out(let operand): // 5
                    let result = combo(operand) % 8
                    output.append(result)
                    position += 1
                case .bdv(let operand): // 6
                    let result = registerA >> combo(operand)
                    registerB = result
                    position += 1
                case .cdv(let operand): // 7
                    let result = registerA >> combo(operand)
                    registerC = result
                    position += 1
                }
            }

            return output
        }

        private func combo(_ operand: Int) -> Int {
            switch operand {
            case 0...3: return operand
            case 4: return registerA
            case 5: return registerB
            case 6: return registerC
            default: fatalError()
            }
        }
    }

    private func data(from input: String) -> Computer {
        let regex = /Register A: (?<a>\d+)\nRegister B: (?<b>\d+)\nRegister C: (?<c>\d+)\n\nProgram: (?<program>.*)/

        guard let match = try? regex.firstMatch(in: input),
              let a = Int(match.output.a),
              let b = Int(match.output.b),
              let c = Int(match.output.c) else {
            fatalError()
        }

        let program = match.output.program.split(separator: ",").map {
            Int($0)!
        }

        var instructions: [Computer.Instruction] = []

        for i in 0..<(program.count/2) {
            let instruction = program[i*2]
            let operand = program[i*2+1]
            
            instructions.append(.init(instruction: instruction, operand: operand))
        }

        return Computer(
            registerA: a,
            registerB: b,
            registerC: c,
            program: instructions,
            resultProgram: program
        )
    }
}
