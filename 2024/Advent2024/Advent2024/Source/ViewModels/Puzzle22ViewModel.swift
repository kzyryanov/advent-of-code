//
//  Puzzle22ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2025-01-16.
//

import SwiftUI

@Observable
final class Puzzle22ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    private func mix(value: Int, secret: Int) -> Int {
        value ^ secret
    }

    private func prune(value: Int) -> Int {
        value % 16777216
    }

    private func nextSecret(secret: Int) -> Int {
        let step1 = prune(value: mix(value: secret * 64, secret: secret))
        let step2 = prune(value: mix(value: step1 / 32, secret: step1))
        let step3 = prune(value: mix(value: step2 * 2048, secret: step2))
        return step3
    }

    private func getMostBananas(from numbers: [Int], limit: Int = 2000) -> Int {
        var sequences: [[Int]] = Array(repeating: [], count: numbers.count)
        var sequencePrices: [[[Int]: Int]] = Array(repeating: [:], count: numbers.count)

        var secrets = numbers

        for _ in 0...limit {
            let prices = secrets.map { $0 % 10 }
            let newSecrets = secrets.map(nextSecret)
            let newPrices = newSecrets.map { $0 % 10 }

            let diffs = zip(prices, newPrices).map { $0.1 - $0.0 }

            for i in 0..<numbers.count {
                let sequence = Array((sequences[i] + [diffs[i]]).suffix(4))
                sequences[i] = sequence
                if nil == sequencePrices[i][sequence] {
                    sequencePrices[i][sequence] = newPrices[i]
                }
            }

            secrets = newSecrets
        }

        let allPossibleSequences: Set<[Int]> = Set(sequencePrices.flatMap { $0.keys.filter { $0.count == 4 } })

        let mostBananas = allPossibleSequences.map { s in
            sequencePrices.reduce(0) { acc, dict in
                acc + dict[s, default: 0]
            }
        }

        return mostBananas.max() ?? 0
    }

    private func findSequence(for number: Int) -> [Int] {
        var cache: Set<Int> = []

        var sequence: [Int] = []

        var secret = number

        var maxPrice = number % 10

        while !cache.contains(secret) {
            cache.insert(secret)
            let prev = secret % 10
            secret = nextSecret(secret: secret)
            let price = secret % 10

            sequence.append(price - prev)

            if sequence.suffix(4) == [-2, 1, -1, 3] {
                print(sequence.count, price)
                return sequence.suffix(4)
            }

            if price > maxPrice {
                maxPrice = price
            }
        }

//        var sequence: [Int] = []
//        var secret = number
//
//        while true {
//            let price = secret % 10
//            let next = nextSecret(secret: secret)
//            let nextPrice = next % 10
//            let diff = nextPrice - price
//
//            if diff < 0, sequence.count >= 4, let last = sequence.last, last >= 0 {
//                return sequence.suffix(4)
//            }
//
//            sequence.append(diff)
//            secret = next
//        }

        return sequence
    }

    func solveOne(input: String, isTest: Bool) async -> String {
        var numbers = data(from: input)

        for _ in 1...2000 {
            numbers = numbers.map(nextSecret)
        }

        let result = numbers.reduce(0, +)

        return "\(result)"
    }

    func solveTwo(input: String, isTest: Bool) async -> String {
        let numbers = data(from: input)

        let mostBananas = getMostBananas(from: numbers)

        return "\(mostBananas)"
    }

    private func data(from input: String) -> [Int] {
        let lines = input.lines.filter(\.isNotEmpty)

        return lines.map { Int($0)! }
    }
}
