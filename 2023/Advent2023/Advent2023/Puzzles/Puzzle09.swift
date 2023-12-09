//
//  Puzzle09.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-09.
//

import SwiftUI

struct Puzzle09: View {
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
                        HStack {
                            Text("Result 1: ").font(.headline)
                            Text("\(answerFirst)")
                                .textSelection(.enabled)
                        }
                    }
                    if let answerSecond {
                        HStack {
                            Text("Result 2: ").font(.headline)
                            Text("\(answerSecond)")
                                .textSelection(.enabled)
                        }
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

        let history = input.components(separatedBy: .newlines)
            .filter(\.isNotEmpty)
            .map {
                $0.components(separatedBy: .whitespaces)
                    .filter(\.isNotEmpty)
                    .compactMap(Int.init)
            }

        let extrapolatedValues = history.map { sequence in
            var historyDiffs: [[Int]] = [sequence]

            while let last = historyDiffs.last, last.allSatisfy({ $0 == 0 }) != true {
                historyDiffs.append(diffs(in: last))
            }

            let value = historyDiffs.compactMap(\.last).reduce(0, +)

            return value
        }

        let result = extrapolatedValues.reduce(0, +)

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

        let history = input.components(separatedBy: .newlines)
            .filter(\.isNotEmpty)
            .map {
                $0.components(separatedBy: .whitespaces)
                    .filter(\.isNotEmpty)
                    .compactMap(Int.init)
            }

        let extrapolatedValues = history.map { sequence in
            var historyDiffs: [[Int]] = [sequence]

            while let last = historyDiffs.last, last.allSatisfy({ $0 == 0 }) != true {
                historyDiffs.append(diffs(in: last))
            }

            let value = historyDiffs.reversed().compactMap(\.first).reduce(0, { $1 - $0 })

            return value
        }

        let result = extrapolatedValues.reduce(0, +)

        await MainActor.run {
            answerSecond = result
        }
    }

    private func diffs(in sequence: [Int]) -> [Int] {
        if sequence.allSatisfy({ $0 == 0 }) {
            return sequence
        }

        guard sequence.count > 1 else {
            return [0]
        }

        var diffs: [Int] = []
        for index in 0..<(sequence.count-1) {
            diffs.append(sequence[index+1] - sequence[index])
        }

        return diffs
    }
}

#Preview {
    Puzzle09(input: Input.puzzle09.testInput)
}
