//
//  Puzzle07.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-07.
//

import SwiftUI

struct Puzzle07: View {
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

        let ranking: [Character] = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]

        let hands = input.components(separatedBy: "\n").filter(\.isNotEmpty).map {
            let components = $0.components(separatedBy: " ")
            let cards = components.first!
            let bid = Int(components.last!)!
            return Hand(cards: cards, bid: bid, ranking: ranking, withJoker: false)
        }

        let sorted = hands.sorted(by: <)

        let result = sorted.enumerated().map({ ($0 + 1) * $1.bid }).reduce(0, +)

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

        let ranking: [Character] = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]

        let hands = input.components(separatedBy: "\n").filter(\.isNotEmpty).map {
            let components = $0.components(separatedBy: " ")
            let cards = components.first!
            let bid = Int(components.last!)!
            return Hand(cards: cards, bid: bid, ranking: ranking, withJoker: true)
        }

        let sorted = hands.sorted(by: <)

        let result = sorted.enumerated().map({ ($0 + 1) * $1.bid }).reduce(0, +)

        await MainActor.run {
            answerSecond = result
        }
    }
}

private enum Kind: String, CaseIterable {
    case five
    case four
    case fullHouse
    case three
    case twoPair
    case pair
    case high

    static func kind(for hand: String) -> Kind {
        let buckets = Dictionary(grouping: hand) { character in
            character
        }.values.map(\.count)

        if buckets.contains(5) {
            return .five
        }

        if buckets.contains(4) {
            return .four
        }

        if buckets.contains(3) {
            if buckets.contains(2) {
                return .fullHouse
            }
            return .three
        }

        if buckets.contains(2) {
            if buckets.filter({ $0 == 2 }).count > 1 {
                return .twoPair
            }
            return .pair
        }

        return .high
    }

    static func kindWithJoker(for hand: String) -> Kind {
        let buckets = Dictionary(grouping: hand) { character in
            character
        }

        let Js = buckets["J", default: []]
        if Js.isEmpty {
            return kind(for: hand)
        }

        if Js.count == 5 {
            return .five
        }

        if Js.count == 4 {
            return .five
        }

        let countsWithoutJs = buckets.filter {
            $0.key != "J"
        }.values.map(\.count)

        // At least one J below
        if countsWithoutJs.contains(4) {
            return .five
        }

        if countsWithoutJs.contains(3) {
            if Js.count == 2 {
                return .five
            }
            return .four
        }

        if countsWithoutJs.contains(2) {
            if Js.count == 3 {
                return .five
            }
            if Js.count == 2 {
                return .four
            }
            if countsWithoutJs.contains(1) {
                return .three
            }
            return .fullHouse
        }

        if Js.count == 3 {
            return .four
        }

        if Js.count == 2 {
            return .three
        }

        return .pair
    }
}

private struct Hand: CustomStringConvertible, Comparable {
    let cards: String
    let bid: Int

    let ranking: [Character]
    let withJoker: Bool

    var description: String {
        "\(cards) \(bid)"
    }

    static func < (lhs: Hand, rhs: Hand) -> Bool {
        let lhsKind: Kind
        if lhs.withJoker {
            lhsKind = Kind.kindWithJoker(for: lhs.cards)
        } else {
            lhsKind = Kind.kind(for: lhs.cards)
        }
        let rhsKind: Kind
        if rhs.withJoker {
            rhsKind = Kind.kindWithJoker(for: rhs.cards)
        } else {
            rhsKind = Kind.kind(for: rhs.cards)
        }

        let lhsIndex = Kind.allCases.firstIndex(of: lhsKind)!
        let rhsIndex = Kind.allCases.firstIndex(of: rhsKind)!

        if lhsIndex != rhsIndex {
            return lhsIndex > rhsIndex
        }

        for i in 0..<lhs.cards.count {
            let lhsIndex = lhs.ranking.firstIndex(of: Array(lhs.cards)[i])!
            let rhsIndex = rhs.ranking.firstIndex(of: Array(rhs.cards)[i])!

            if lhsIndex != rhsIndex {
                return lhsIndex > rhsIndex
            }
        }

        return false
    }
}

#Preview {
    Puzzle07(input: Input.puzzle07.testInput)
}
