//
//  Puzzle06.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-07.
//

import SwiftUI

struct Puzzle06: View {
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
                        await solveFirst()
                        await solveSecond()
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

        let lines = input.components(separatedBy: "\n").filter(\.isNotEmpty)
        let times = lines.first!
            .components(separatedBy: .whitespaces)
            .dropFirst()
            .filter(\.isNotEmpty)
            .map { Int($0)! }
        let distances = lines.last!
            .components(separatedBy: .whitespaces)
            .dropFirst()
            .filter(\.isNotEmpty)
            .map { Int($0)! }

        let ranges = times.enumerated().compactMap { (index, time) -> ClosedRange<Int>? in
            let distance = distances[index]
            let disc = Double(time * time - 4 * distance)
            guard disc >= 0 else {
                return nil
            }
            var minHoldTime = Int(ceil((Double(time) - sqrt(disc)) / 2))
            var maxHoldTime = Int(floor((Double(time) + sqrt(disc)) / 2))

            let travelDistanceMinTime = (time - minHoldTime) * minHoldTime
            if travelDistanceMinTime <= distance {
                minHoldTime += 1
            }

            let travelDistanceMaxTime = (time - maxHoldTime) * maxHoldTime
            if travelDistanceMaxTime <= distance {
                maxHoldTime -= 1
            }

            guard maxHoldTime >= minHoldTime else {
                return nil
            }

            return minHoldTime...maxHoldTime
        }

        let result = ranges
            .map(\.count)
            .filter({ $0 > 0 })
            .reduce(1, *)

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

        let lines = input.components(separatedBy: "\n").filter(\.isNotEmpty)
        let time: Int = Int(lines.first!
            .components(separatedBy: .whitespaces)
            .dropFirst()
            .filter(\.isNotEmpty)
            .joined()
        )!
        let distance: Int = Int(lines.last!
            .components(separatedBy: .whitespaces)
            .dropFirst()
            .filter(\.isNotEmpty)
            .joined()
        )!

        print(time, distance)

        let disc = Double(time * time - 4 * distance)
        guard disc >= 0 else {
            return
        }
        var minHoldTime = Int(ceil((Double(time) - sqrt(disc)) / 2))
        var maxHoldTime = Int(floor((Double(time) + sqrt(disc)) / 2))

        let travelDistanceMinTime = (time - minHoldTime) * minHoldTime
        if travelDistanceMinTime <= distance {
            minHoldTime += 1
        }

        let travelDistanceMaxTime = (time - maxHoldTime) * maxHoldTime
        if travelDistanceMaxTime <= distance {
            maxHoldTime -= 1
        }

        guard maxHoldTime >= minHoldTime else {
            return
        }

        let range = minHoldTime...maxHoldTime

        print(range)

        let result = range.count

        await MainActor.run {
            answerSecond = result
        }
    }
}

extension ClosedRange where Bound: BinaryInteger {
    var count: Int {
        Int(upperBound - lowerBound) + 1
    }
}

#Preview {
    Puzzle06(input: Input.puzzle06.testInput)
}
