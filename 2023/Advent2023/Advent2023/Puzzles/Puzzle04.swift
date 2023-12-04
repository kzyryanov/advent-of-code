//
//  Puzzle04.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-04.
//

import SwiftUI

struct Puzzle04: View {
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

        let cards = input.components(separatedBy: "\n").filter(\.isNotEmpty).map { line in
            let cardComponents = line.components(separatedBy: ": ")
            let numbersComponents = cardComponents.last!.components(separatedBy: " | ")
            let winning = Set(numbersComponents.first!
                .components(separatedBy: " ")
                .compactMap({ Int($0) })
            )
            let have = Set(numbersComponents.last!
                .components(separatedBy: " ")
                .compactMap({ Int($0) })
            )
            return (winning, have)
        }

        let result = cards
            .map { $0.0.intersection($0.1).count }
            .map { Int(pow(Double(2.0), Double($0 - 1))) }
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
        let cards = input.components(separatedBy: "\n").filter(\.isNotEmpty).map { line in
            let cardComponents = line.components(separatedBy: ": ")
            let numbersComponents = cardComponents.last!.components(separatedBy: " | ")
            let winning = Set(numbersComponents.first!
                .components(separatedBy: " ")
                .compactMap({ Int($0) })
            )
            let have = Set(numbersComponents.last!
                .components(separatedBy: " ")
                .compactMap({ Int($0) })
            )
            return (w: winning, h: have)
        }

        let amounts = cards.map({ card in card.w.intersection(card.h).count })
        print(amounts)

        var cardCount = Array(repeating: 1, count: amounts.count)

        for (index, amount) in amounts.enumerated() {
            let count = cardCount[index]
            for i in 0..<amount {
                cardCount[index + i + 1] += count
            }
        }

        let result = cardCount.reduce(0, +)

        await MainActor.run {
            answerSecond = result
        }
    }
}

#Preview {
    Puzzle04(input: Input.puzzle04.testInput)
}
