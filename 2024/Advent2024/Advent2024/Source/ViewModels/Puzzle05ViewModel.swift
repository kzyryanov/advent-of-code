//
//  Puzzle05ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-05.
//

import SwiftUI

@Observable
final class Puzzle05ViewModel: PuzzleViewModel {
    var answer: Answer = Answer()

    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String) async -> String {
        let safetyProtocol = data(from: input)

        let result = safetyProtocol.pages.filter {
            isCorrectOrder(pages: $0, pageOrders: safetyProtocol.pageOrders)
        }.map {
            $0[$0.count / 2]
        }.reduce(0, +)

        return "\(result)"
    }

    func solveTwo(input: String) async -> String {
        let safetyProtocol = data(from: input)

        let incorrectUpdates = safetyProtocol.pages.filter {
            !isCorrectOrder(pages: $0, pageOrders: safetyProtocol.pageOrders)
        }

        let fixedUpdates = incorrectUpdates.map { update in
            update.sorted(by: { one, two in
                if safetyProtocol.pageOrders[one, default: []].contains(two) {
                    return true
                }
                if safetyProtocol.pageOrders[two, default: []].contains(one) {
                    return false
                }
                return true
            })
        }

        let result = fixedUpdates.map {
            $0[$0.count / 2]
        }.reduce(0, +)

        return "\(result)"
    }

    private func isCorrectOrder(pages: [Int], pageOrders: [Int: Set<Int>]) -> Bool {
        var source: Set<Int> = []

        for page in pages {
            for sourcePage in source {
                if pageOrders[page, default: []].contains(sourcePage) {
                    return false
                }
            }

            source.insert(page)
        }
        
        return true
    }

    func data(from input: String) -> SafetyProtocol {
        let lines = input.lines

        var pageOrders: [Int: Set<Int>] = [:]
        var pagesToPrint: [[Int]] = []

        for line in lines {
            if line.contains("|") {
                let pages = line.split(separator: "|")

                guard pages.count == 2 else {
                    fatalError("Wrong format")
                }

                let sourcePage = Int(pages.first!)!
                let targetPage = Int(pages.last!)!

                var pageOrder = pageOrders[sourcePage, default: []]
                pageOrder.insert(targetPage)
                pageOrders[sourcePage] = pageOrder
            } else if line.contains(",") {
                let pages = line.split(separator: ",").compactMap { Int($0) }
                pagesToPrint.append(pages)
            }
        }

        return SafetyProtocol(
            pageOrders: pageOrders,
            pages: pagesToPrint
        )
    }

    struct SafetyProtocol {
        let pageOrders: [Int: Set<Int>]
        let pages: [[Int]]
    }
}
