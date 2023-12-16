//
//  Puzzle11.swift
//  AdventOfCode2015
//
//  Created by Konstantin Zyrianov on 2023-12-15.
//

import SwiftUI

struct Puzzle11: View {
    let input: String

    @State private var presentInput: Bool = false

    @State private var isSolving: Bool = false
    @State private var answerFirst: String?
    @State private var answerSecond: String?

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

        var p = input

        repeat {
            p = iterate(password: p)
        } while !isCorrect(password: p)

        let result = p

        await MainActor.run {
            print("Result 1: \(result)")
            answerFirst = result
        }
    }

    private func solveSecond() async {
        answerSecond = nil

        var p = input

        repeat {
            p = iterate(password: p)
        } while !isCorrect(password: p)

        repeat {
            p = iterate(password: p)
        } while !isCorrect(password: p)

        let result = p

        await MainActor.run {
            print("Result 2: \(result)")
            answerSecond = result
        }
    }

    func isCorrect(password: String) -> Bool {
        let invalidCharacters: Set<Character> = ["i", "o", "l"]

        guard !password.contains(where: invalidCharacters.contains) else {
            return false
        }

        var pairs: Set<Int> = []
        var hasThree = false
        var prevDiff: Int = 0
        var prev: Int?

        for character in password {
            guard let asciiValue = character.asciiValue else {
                return false
            }
            let ascii = Int(asciiValue)
            if let prev {
                let diff = ascii - prev
                if prevDiff == 1 && diff == 1 {
                    hasThree = true
                }
                if diff == 0 {
                    pairs.insert(ascii)
                }
                prevDiff = diff
            }

            prev = ascii

            if hasThree && pairs.count > 1 {
                return true
            }
        }

        return false
    }

    func iterate(password: String) -> String {
        let asciiA = Character("a").asciiValue!
        let asciiZ = Character("z").asciiValue!

        var result = ""

        var add = true

        password.reversed().forEach { character in
            var ascii = character.asciiValue!
            if add {
                ascii += 1
                if ascii > asciiZ {
                    ascii = asciiA
                } else {
                    add = false
                }
            }
            result.append(String(UnicodeScalar(ascii)))
        }

        return String(result.reversed())
    }
}

#Preview {
    Puzzle11(input: "vzbxkghb")
}
