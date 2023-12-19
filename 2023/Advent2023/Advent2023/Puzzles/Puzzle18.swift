//
//  Puzzle18.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-18.
//

import SwiftUI

struct Puzzle18: View {
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

        let instructions = Self.parseOne(input: input)

        let result = Self.solve(instructions: instructions)

        await MainActor.run {
            print("Result 1: \(result)")
            answerFirst = result
        }
    }

    private func solveSecond() async {
        answerSecond = nil

        let instructions = Self.parseTwo(input: input)

        let result = Self.solve(instructions: instructions)

        await MainActor.run {
            print("Result 2: \(result)")
            answerSecond = result
        }
    }

    private static func solve(instructions: [Instruction]) -> Int {
        var coordinates: [Point] = [.zero]
        var edgeLength: Int = 0

        for instruction in instructions {
            var newLast = coordinates.last!

            edgeLength += instruction.distance

            switch instruction.direction {
            case .north:
                newLast.y -= instruction.distance
            case .west:
                newLast.x -= instruction.distance
            case .south:
                newLast.y += instruction.distance
            case .east:
                newLast.x += instruction.distance
            }
            coordinates.append(newLast)
        }

        var area = 0
        for index in 0..<coordinates.count {
            let xi = coordinates[index].x
            let yim = coordinates[((index + coordinates.count) - 1) % coordinates.count].y
            let yip = coordinates[(index + 1) % coordinates.count].y
            area += xi * (yip - yim)
        }
        area = abs(area) / 2

        let result = area + (edgeLength + 2) / 2

        return result
    }

    private static func parseOne(input: String) -> [Instruction] {
        let regex = /(?<direction>[RDLU]{1}?) (?<distance>[0-9]+?) \(#.*\)/

        return input.components(separatedBy: .newlines).filter(\.isNotEmpty).map { line in
            let match = try! regex.wholeMatch(in: line)

            let direction = match!.direction
            let distance = Int(match!.distance)!

            let digDirection: Direction

            switch direction {
            case "R":
                digDirection = .east
            case "D":
                digDirection = .south
            case "L":
                digDirection = .west
            case "U":
                digDirection = .north
            default: fatalError()
            }

            return Instruction(direction: digDirection, distance: distance)
        }
    }

    private static func parseTwo(input: String) -> [Instruction] {
        let regex = /.* \(#(?<color>.*?)\)/

        return input.components(separatedBy: .newlines).filter(\.isNotEmpty).map { line in
            let match = try! regex.wholeMatch(in: line)

            var color: [Character] = Array(match!.color)
            let direction = color.removeLast()
            let distance = Int(String(color), radix: 16)!

            let digDirection: Direction

            switch direction {
            case "0":
                digDirection = .east
            case "1":
                digDirection = .south
            case "2":
                digDirection = .west
            case "3":
                digDirection = .north
            default: fatalError()
            }

            return Instruction(direction: digDirection, distance: distance)
        }
    }
}

private struct Instruction: CustomStringConvertible {
    let direction: Direction
    let distance: Int

    var description: String {
        "\(direction) \(distance)"
    }
}

#Preview {
    Puzzle18(input: Input.puzzle18.testInput)
}
