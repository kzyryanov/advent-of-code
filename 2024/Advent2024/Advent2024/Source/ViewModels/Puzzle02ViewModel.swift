//
//  Puzzle02ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-02.
//

import SwiftUI

@Observable
final class Puzzle02ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String, isTest: Bool) async -> String {
        let reports = data(from: input)

        let result = reports.count(where: isReportSafe)

        return "\(result)"
    }

    func solveTwo(input: String, isTest: Bool) async -> String {
        let reports = data(from: input)

        let result = reports.count { report in
            let isSafe = isReportSafe(report)

            if !isSafe {
                for index in 0..<report.count {
                    var newReport = report
                    newReport.remove(at: index)
                    if isReportSafe(newReport) {
                        return true
                    }
                }
                return false
            }

            return true
        }

        return "\(result)"
    }

    func isReportSafe(_ report: [Int]) -> Bool {
        var order: ComparisonResult = .orderedSame

        for index in 0..<(report.count-1) {
            let diff = report[index+1] - report[index]
            switch diff {
            case (-3)...(-1):
                if order == .orderedSame {
                    order = .orderedDescending
                } else if order == .orderedAscending {
                    return false
                }
            case 1...3:
                if order == .orderedSame {
                    order = .orderedAscending
                } else if order == .orderedDescending {
                    return false
                }
            default: return false
            }
        }
        return true
    }

    func data(from input: String) -> [[Int]] {
        input.lines
            .filter(\.isNotEmpty)
            .map {
                $0.split(whereSeparator: \.isWhitespace)
                    .filter(\.isNotEmpty)
                    .map { Int($0)! }
            }
    }
}
