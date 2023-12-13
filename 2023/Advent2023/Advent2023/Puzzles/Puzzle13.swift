//
//  Puzzle13.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-13.
//

import SwiftUI

struct Puzzle13: View {
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

        let patterns = input.components(separatedBy: "\n\n").map {
            $0.components(separatedBy: .newlines).filter(\.isNotEmpty)
        }.filter(\.isNotEmpty)

        let indices = patterns.map { pattern in
            if let row = Self.findMirror(in: pattern) {
                return row * 100
            }
            if let column = Self.findMirror(in: pattern.transpose.map({ String($0) })) {
                return column
            }

            fatalError()
        }

        let result = indices.reduce(0, +)

        await MainActor.run {
            print("Result 1: \(result)")
            answerFirst = result
        }
    }

    private func solveSecond() async {
        answerSecond = nil

        let patterns = input.components(separatedBy: "\n\n").map {
            $0.components(separatedBy: .newlines).filter(\.isNotEmpty)
        }.filter(\.isNotEmpty)

        let indices = patterns.map { pattern in
            let transposed = pattern.transpose.map({ String($0) })

            if let row = Self.findFixedMirror(in: pattern) {
                return row * 100
            }

            if let column = Self.findFixedMirror(in: transposed) {
                return column
            }

            return 0
        }

        let result = indices.reduce(0, +)

        await MainActor.run {
            print("Result 2: \(result)")
            answerSecond = result
        }
    }

    private static func findMirror(in pattern: [String]) -> Int? {
        for i in 1..<pattern.count {
            let maxLength = min(pattern.count - i, i)
            let prefix: [String] = Array(pattern.prefix(i).suffix(maxLength))
            let suffix: [String] = Array(pattern.suffix(from: i).prefix(maxLength).reversed())

            if prefix == suffix {
                return i
            }
        }

        return nil
    }

    private static func findFixedMirror(in pattern: [String]) -> Int? {

        for i in 1..<pattern.count {
            let maxLength = min(pattern.count - i, i)
            let prefix: [String] = Array(pattern.prefix(i).suffix(maxLength))
            let suffix: [String] = Array(pattern.suffix(from: i).prefix(maxLength).reversed())

            guard prefix.count == suffix.count else {
                continue
            }

            let counts = prefix.enumerated().compactMap { offset, line in
                line.distanceFrom(string: suffix[offset])
            }

            if counts.reduce(0, +) == 1 {
                return i
            }
        }

        return nil
    }
}

private extension String {
    func distanceFrom(string: String) -> Int? {
        self.enumerated()
            .map { $0.element == Array(string)[$0.offset] ? 0 : 1 }
            .reduce(0, +)
    }
}

#Preview {
    Puzzle13(input: Input.puzzle13.testInput)
}
