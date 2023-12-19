//
//  Puzzle19.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-19.
//

import SwiftUI

struct Puzzle19: View {
    let input: String

    @State private var presentInput: Bool = false

    @State private var isSolving: Bool = false
    @State private var answerFirst: Int?
    @State private var answerSecond: Int?

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    if let answerFirst {
                        Text("Result 1: ").font(.headline) +
                        Text("\(answerFirst)")
                    }
                    if let answerSecond {
                        Text("Result 2: ").font(.headline) +
                        Text("\(answerSecond)")
                    }
                }
                .padding()
            }
            Button(
                action: {
                    Task {
                        isSolving = true
                        defer {
                            isSolving = false
                        }
                        let clock = ContinuousClock()
                        let result1 = await clock.measure {
                            await solveFirst()
                        }
                        print("Result 1: \(result1)")
                        let result2 = await clock.measure {
                            await solveSecond()
                        }
                        print("Result 2: \(result2)")
                    }
                },
                label: {
                    Image(systemName: "figure.run.circle")
                    Text("Solve")
                }
            )
            .font(.largeTitle)
            .disabled(isSolving)
            .padding()
        }
        .overlay {
            if isSolving {
                ProgressView()
            }
        }
        .toolbar {
            Button(
                action: { presentInput.toggle() },
                label: { Image(systemName: "doc") }
            )
        }
        .sheet(isPresented: $presentInput) {
            NavigationView {
                ScrollView {
                    Text(input)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .navigationTitle("Input")
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Button(
                            action: { presentInput.toggle() },
                            label: { Image(systemName: "xmark.circle") }
                        )
                    }
                }
            }
        }
    }

    private func solveFirst() async {
        answerFirst = nil

        let (workflows, parts) = Self.parse(input: input)

        let inWorkflow = workflows["in"]!

        func decide(part: Part, workflow: Workflow) -> Bool {
            for instruction in workflow.instructions {
                switch instruction {
                case .less(let category, let amount, let instruction):
                    if part.categories[category]! < amount {
                        switch instruction {
                        case .accept: return true
                        case .reject: return false
                        case .sendToOther(let name):
                            return decide(part: part, workflow: workflows[name]!)
                        default:
                            fatalError()
                        }
                    }
                case .more(let category, let amount, let instruction):
                    if part.categories[category]! > amount {
                        switch instruction {
                        case .accept: return true
                        case .reject: return false
                        case .sendToOther(let name):
                            return decide(part: part, workflow: workflows[name]!)
                        default:
                            fatalError()
                        }
                    }
                case .sendToOther(let name):
                    return decide(part: part, workflow: workflows[name]!)
                case .accept:
                    return true
                case .reject:
                    return false
                }
            }
            fatalError()
        }

        let result = parts.filter { decide(part: $0, workflow: inWorkflow) }.flatMap(\.categories.values).reduce(0, +)

        await MainActor.run {
            print("Result 1: \(result)")
            answerFirst = result
        }
    }

    private func solveSecond() async {
        answerSecond = nil

        let (workflows, _) = Self.parse(input: input)
        let inWorkflow = workflows["in"]!

        let ranges: [Category: ClosedRange<Int>] = [
            .x: 1...4000,
            .m: 1...4000,
            .a: 1...4000,
            .s: 1...4000
        ]

        func decide(ranges: [Category: ClosedRange<Int>], workflow: Workflow) -> Int {
            for instruction in workflow.instructions {
                switch instruction {
                case .less(let category, let amount, let instruction):
                    guard let categoryRange = ranges[category] else {
                        return 0
                    }
                    let passRange: ClosedRange<Int>?
                    if categoryRange.lowerBound < amount {
                        passRange = categoryRange.lowerBound...amount-1
                    } else {
                        passRange = nil
                    }
                    let failRange: ClosedRange<Int>?
                    if categoryRange.upperBound >= amount {
                        failRange = amount...categoryRange.upperBound
                    } else {
                        failRange = nil
                    }

                    var failRanges = ranges
                    failRanges[category] = failRange

                    var instructions = workflow.instructions
                    instructions.removeFirst()
                    let failAmount = decide(ranges: failRanges, workflow: Workflow(name: workflow.name, instructions: instructions))

                    var passRanges = ranges
                    passRanges[category] = passRange

                    switch instruction {
                    case .accept:
                        return failAmount + passRanges.values.map(\.count).reduce(1, *)
                    case .reject: return failAmount
                    case .sendToOther(let name):
                        return failAmount + decide(ranges: passRanges, workflow: workflows[name]!)
                    default:
                        fatalError()
                    }
                case .more(let category, let amount, let instruction):
                    guard let categoryRange = ranges[category] else {
                        return 0
                    }
                    let failRange: ClosedRange<Int>?
                    if categoryRange.lowerBound <= amount {
                        failRange = categoryRange.lowerBound...amount
                    } else {
                        failRange = nil
                    }
                    let passRange: ClosedRange<Int>?
                    if categoryRange.upperBound > amount {
                        passRange = (amount+1)...categoryRange.upperBound
                    } else {
                        passRange = nil
                    }

                    var failRanges = ranges
                    failRanges[category] = failRange

                    var instructions = workflow.instructions
                    instructions.removeFirst()
                    let failAmount = decide(ranges: failRanges, workflow: Workflow(name: workflow.name, instructions: instructions))

                    var passRanges = ranges
                    passRanges[category] = passRange

                    switch instruction {
                    case .accept:
                        return failAmount + passRanges.values.map(\.count).reduce(1, *)
                    case .reject: return failAmount
                    case .sendToOther(let name):
                        return failAmount + decide(ranges: passRanges, workflow: workflows[name]!)
                    default:
                        fatalError()
                    }
                case .sendToOther(let name):
                    return decide(ranges: ranges, workflow: workflows[name]!)
                case .accept:
                    return ranges.values.map(\.count).reduce(1, *)
                case .reject:
                    return 0
                }
            }
            return 0
        }

        let result = decide(ranges: ranges, workflow: inWorkflow)

        await MainActor.run {
            print("Result 2: \(result)")
            answerSecond = result
        }
    }

    private static func parse(input: String) -> (workflows: [String: Workflow], parts: [Part]) {
        let components = input.components(separatedBy: "\n\n")

        let partsRegex = /\{x=(?<x>\d+?),m=(?<m>\d+?),a=(?<a>\d+?),s=(?<s>\d+?)\}/
        let parts = components.last!.components(separatedBy: .newlines).filter(\.isNotEmpty).map { line in
            let match = (try! partsRegex.wholeMatch(in: line))!
            return Part(categories: [
                .x: Int(match.x)!,
                .m: Int(match.m)!,
                .a: Int(match.a)!,
                .s: Int(match.s)!,
            ])
        }

        let workflowRegex = /(?<name>.*?)\{(?<list>.*?)\}/
        let instructionRegex = /(?<category>[xmas]?)(?<comparator>[<>]?)(?<value>\d+?):(?<instruction>.*?)/
        let workflows = Dictionary(uniqueKeysWithValues: components.first!.components(separatedBy: .newlines).filter(\.isNotEmpty).map { line in
            let match = (try! workflowRegex.wholeMatch(in: line))!
            let name = String(match.name)
            let list = match.list

            let instructions: [Instruction] = list.components(separatedBy: ",").map { line in
                switch line {
                case "A":
                    return .accept
                case "R":
                    return .reject
                case line where !line.contains(where: { $0 == ">" || $0 == "<" }):
                    return .sendToOther(other: line)
                default:
                    let imatch = (try! instructionRegex.wholeMatch(in: line))!
                    let category = Category(rawValue: imatch.category.first!)!
                    let comparator = imatch.comparator
                    let value = Int(imatch.value)!
                    let instructionString = imatch.instruction

                    let instruction: Instruction
                    switch instructionString {
                    case "A": instruction = .accept
                    case "R": instruction = .reject
                    default: instruction = .sendToOther(other: String(instructionString))
                    }

                    switch comparator {
                    case "<":
                        return .less(category: category, amount: value, instruction: instruction)
                    case ">":
                        return .more(category: category, amount: value, instruction: instruction)
                    default: fatalError()
                    }
                }
            }

            return (name, Workflow(name: name, instructions: instructions))
        })

        return (workflows, parts)
    }
}

private enum Category: Character, CustomStringConvertible {
    case x = "x"
    case m = "m"
    case a = "a"
    case s = "s"

    var description: String {
        String(rawValue)
    }
}

private indirect enum Instruction: CustomStringConvertible {
    case less(category: Category, amount: Int, instruction: Instruction)
    case more(category: Category, amount: Int, instruction: Instruction)

    case sendToOther(other: String)
    case accept
    case reject

    var description: String {
        switch self {
        case .less(let category, let amount, let instruction):
            "\(category)<\(amount):\(instruction)"
        case .more(let category, let amount, let instruction):
            "\(category)>\(amount):\(instruction)"
        case .sendToOther(let other):
            "\(other)"
        case .accept:
            "A"
        case .reject:
            "R"
        }
    }
}

private struct Workflow: CustomStringConvertible {
    let name: String
    let instructions: [Instruction]

    var description: String {
        "\(name){\(instructions)}"
    }
}

private struct Part: CustomStringConvertible {
    let categories: [Category: Int]

    var description: String {
        "\(categories)"
    }
}

#Preview {
    Puzzle19(input: Input.puzzle19.testInput)
}
