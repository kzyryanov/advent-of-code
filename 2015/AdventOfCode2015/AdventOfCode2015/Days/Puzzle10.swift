//
//  Puzzle10.swift
//  AdventOfCode2015
//
//  Created by Konstantin Zyrianov on 2023-12-15.
//

import SwiftUI

struct Puzzle10: View {
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

        let result = solve(repetitions: 40)

        await MainActor.run {
            print("Result 1: \(result)")
            answerFirst = result
        }
    }

    private func solveSecond() async {
        answerSecond = nil

        let result = solve(repetitions: 50)

        await MainActor.run {
            print("Result 2: \(result)")
            answerSecond = result
        }
    }

    private func solve(repetitions: Int) -> Int {
        var resultString = input

        for _ in 0..<repetitions {
            let string = Array(resultString)
            var newResult = ""
            var index = 0
            var number = 0
            var count = 0
            while index < string.count {
                let readNumber = Int(String(string[index]))!
                if readNumber != number {
                    if count > 0 {
                        newResult.append("\(count)\(number)")
                    }
                    count = 0
                    number = 0
                }
                number = readNumber
                count += 1
                index += 1
            }
            if count > 0 {
                newResult.append("\(count)\(number)")
            }

            resultString = newResult
        }

        let result = resultString.count

        return result
    }
}

#Preview {
    Puzzle10(input: "1")
}
