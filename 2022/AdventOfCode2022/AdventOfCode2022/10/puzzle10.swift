//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle10() {
    print("Test")
    print("One")
    one(input: testInput10)
    print("Two")
    two(input: testInput10)

    print("")
    print("Real")
    print("One")
    one(input: input10)
    print("Two")
    two(input: input10)
}

private func commands(input: String) -> [Command] {
    input.components(separatedBy: "\n").map { string in
        let components = string.components(separatedBy: " ")
        let command = components.first!

        switch command {
        case "noop": return Command.noop
        case "addx": return Command.addx(Int(components.last!)!)
        default: fatalError("Unknown command")
        }
    }
}

private func one(input: String) {
    let commands = commands(input: input)

    var x: Int = 1
    var signalStrengths: [Int] = []

    for command in commands {
        switch command {
        case .noop:
            signalStrengths.append(x * (signalStrengths.count+1))
        case .addx(let value):
            signalStrengths.append(x * (signalStrengths.count+1))
            signalStrengths.append(x * (signalStrengths.count+1))
            x += value
        }
    }

    let everyNth = 40

    let every40th: [Int] = signalStrengths.enumerated().compactMap { index, strength in
        guard ((index + 20) % everyNth) == (everyNth - 1) else {
            return nil
        }
        return strength
    }
    let result = every40th.reduce(0, +)
    print("Result: \(result)")
}

private func two(input: String) {
    let commands = commands(input: input)

    var x: Int = 1
    var currentCycle: Int = 0

    var lines: [[Character]] = Array(repeating: Array(repeating: ".", count: 40), count: 6)

    func cycle() {
        let line = currentCycle / 40
        let drawAt = currentCycle % 40
        lines[line][drawAt] = abs(x - drawAt) > 1 ? " " : "#"
        currentCycle += 1
    }

    for command in commands {
        switch command {
        case .noop:
            cycle()
        case .addx(let value):
            cycle()
            cycle()
            x += value
        }
    }

    lines.forEach { characters in
        print(String(characters))
    }
}

private enum Command {
    case noop
    case addx(Int)
}
