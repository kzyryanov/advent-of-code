//
//  Puzzle08.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-08.
//

import SwiftUI

struct Puzzle08: View {
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
        isSolving = true
        defer {
            isSolving = false
        }

        var lines = input.components(separatedBy: "\n").filter(\.isNotEmpty)

        let instructions = Array(lines.removeFirst()).map(String.init)

        let regex = /(?<key>.+?) = \((?<left>.+?), (?<right>.+?)\)/

        let map: [String: [String: String]] = Dictionary(uniqueKeysWithValues: lines.map { line in
            let match = try! regex.wholeMatch(in: line)
            let key: String = String(match!.key)
            let left: String = String(match!.left)
            let right: String = String(match!.right)
            return (key, ["L": left, "R": right])
        })

        var currentPosition = "AAA"
        var step = 0

        while currentPosition != "ZZZ" {
            let instruction = instructions[step % instructions.count]

            currentPosition = map[currentPosition]![instruction]!
            step += 1
        }

        let result = step

        await MainActor.run {
            answerFirst = result
        }
    }

    private func solveSecond() async {
        answerSecond = nil
        isSolving = true
        defer {
            isSolving = false
        }

        var lines = input.components(separatedBy: "\n").filter(\.isNotEmpty)

        let instructions = Array(lines.removeFirst()).map(String.init)

        let regex = /(?<key>.+?) = \((?<left>.+?), (?<right>.+?)\)/

        let map: [String: [String: String]] = Dictionary(uniqueKeysWithValues: lines.map { line in
            let match = try! regex.wholeMatch(in: line)
            let key: String = String(match!.key)
            let left: String = String(match!.left)
            let right: String = String(match!.right)
            return (key, ["L": left, "R": right])
        })

        var positions: [String] = map.keys.filter({ $0.hasSuffix("A") })
        var step = 0

        var stepsCounts: [String: Int] = [:]

        while positions.isNotEmpty {
            let instruction = instructions[step % instructions.count]

            positions = positions.map {
                map[$0]![instruction]!
            }

            step += 1

            let finished = positions.filter({ $0.hasSuffix("Z") })
            positions = positions.filter({ !$0.hasSuffix("Z") })
            finished.forEach {
                stepsCounts[$0] = step
            }
        }

        let divisions = stepsCounts.values.map { steps in
            var division: [Int] = []

            let number = steps
            var divider = 2

            if number.isPrime {
                return [number]
            }

            while divider < number / 2 {
                if number % divider == 0 {
                    division.append(divider)
                }
                repeat {
                    divider += 1
                } while !divider.isPrime
            }

            return division
        }

        let set = Set(divisions.flatMap({ $0 }))

        let result = set.reduce(1, *)

        await MainActor.run {
            answerSecond = result
        }
    }
}

extension Int {
    var isPrime: Bool {
        self > 1 && !(2..<self).contains { self % $0 == 0 }
    }
}

#Preview {
    Puzzle08(input: Input.puzzle08.testInput)
}
