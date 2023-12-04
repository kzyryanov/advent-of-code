//
//  Puzzle02.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-04.
//

import SwiftUI

struct Puzzle02: View {
    let input: String
    let bag: Bag

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

        let result = parse()
            .filter({ $0.possible(in: bag) })
            .map(\.id)
            .reduce(0, +)

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

        let result = parse()
            .map { game in
                let maxBag = game.sets.reduce(Bag(red: 0, green: 0, blue: 0)) { partialResult, set in
                    Bag(
                        red: max(partialResult.red, set.red),
                        green: max(partialResult.green, set.green),
                        blue: max(partialResult.blue, set.blue)
                    )
                }
                return maxBag.red * maxBag.green * maxBag.blue
            }
            .reduce(0, +)

        await MainActor.run {
            answerSecond = result
        }
    }

    private func parse() -> [Game] {
        input.components(separatedBy: "\n").filter(\.isNotEmpty).map { line in
            let gameComponents = line.components(separatedBy: ": ")
            let gameId = Int(gameComponents.first!.components(separatedBy: " ").last!)!
            let setsStrings = gameComponents.last!.components(separatedBy: "; ")
            let sets = setsStrings.map { setString in
                let colors = setString.components(separatedBy: ", ")
                let colorsDict = Dictionary(uniqueKeysWithValues: colors.map { colorString in
                    let components = colorString.components(separatedBy: " ")
                    let number = Int(components.first!)!
                    let color =  components.last!
                    return (color, number)
                })

                return Bag(
                    red: colorsDict["red", default: 0],
                    green: colorsDict["green", default: 0],
                    blue: colorsDict["blue", default: 0]
                )
            }

            let game = Game(id: gameId, sets: sets)
            return game
        }
    }
}

struct Bag: CustomStringConvertible {
    let red: Int
    let green: Int
    let blue: Int

    var description: String {
        "[red: \(red), green: \(green), blue: \(blue)]"
    }
}

private struct Game: CustomStringConvertible {
    let id: Int
    let sets: [Bag]

    var description: String {
        "Game \(id): \(sets)"
    }

    func possible(in bag: Bag) -> Bool {
        for set in sets {
            if set.red > bag.red || set.green > bag.green || set.blue > bag.blue {
                return false
            }
        }
        return true
    }
}

#Preview {
    NavigationView {
        Puzzle02(
            input: Input.puzzle02.testInput,
            bag: Bag(red: 12, green: 13, blue: 14)
        )
    }
}
