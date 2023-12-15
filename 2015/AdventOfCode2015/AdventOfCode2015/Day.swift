//
//  Day.swift
//  AdventOfCode2015
//
//  Created by Konstantin Zyrianov on 2023-07-12.
//

import Foundation
import SwiftUI

enum Days {
    fileprivate static let maxDay = 25

    static let days = (1...maxDay).map(Day.init)
    private static let solved: Set<Day.ID> = [1, 9]

    static func isSolved(_ day: Day) -> Bool {
        solved.contains(day.id)
    }
}

struct Day: Identifiable, Hashable {
    let day: Int

    var id: Int { day }

    var title: String { "Day \(day)" }

    @ViewBuilder
    var contentView: some View {
        switch day {
        case 1: Day1()
        case 9: Puzzle09(input: Input.puzzle09.input)
        default: EmptyView()
        }
    }

    var treeString: [TreeSymbol] {
        let count = (Days.maxDay - day) * 2 + 1

        if count <= 1 {
            return [TreeSymbol.star]
        }

        if count <= 3 {
            return [.leftBorder, .orange, .rightBorder]
        }

        let rest = count - 2

        return [TreeSymbol.leftBorder] + (0..<rest).compactMap { _ in TreeSymbol.allCases.randomElement() } + [TreeSymbol.rightBorder]
    }
}

enum TreeSymbol: Character, CaseIterable {
    case leftBorder = ">"
    case rightBorder = "<"
    case red = "@"
    case blue = "O"
    case orange = "o"
    case star = "*"

    var color: Color {
        switch self {
        case .leftBorder, .rightBorder: return Color.green
        case .red: return Color.red
        case .blue: return Color.blue
        case .orange: return Color.orange
        case .star: return Color.yellow
        }
    }

    static let nonSolvedColor: Color = .gray
}
