//
//  ContentView.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-01.
//

import SwiftUI

enum Puzzle: String, CaseIterable {
    case puzzle01 = "Puzzle 01"
    case puzzle02 = "Puzzle 02"
    case puzzle03 = "Puzzle 03"
    case puzzle04 = "Puzzle 04"
    case puzzle05 = "Puzzle 05"
    case puzzle06 = "Puzzle 06"
    case puzzle07 = "Puzzle 07"
    case puzzle08 = "Puzzle 08"
    case puzzle09 = "Puzzle 09"
    case puzzle10 = "Puzzle 10"
    case puzzle11 = "Puzzle 11"
    case puzzle12 = "Puzzle 12"
    case puzzle13 = "Puzzle 13"
    case puzzle14 = "Puzzle 14"
    case puzzle15 = "Puzzle 15"
    case puzzle16 = "Puzzle 16"
    case puzzle17 = "Puzzle 17"
    case puzzle18 = "Puzzle 18"
    case puzzle19 = "Puzzle 19"
    case puzzle20 = "Puzzle 20"
    case puzzle21 = "Puzzle 21"
    case puzzle22 = "Puzzle 22"
    case puzzle23 = "Puzzle 23"
    case puzzle24 = "Puzzle 24"
    case puzzle25 = "Puzzle 25"

    var name: String { rawValue }

    @ViewBuilder
    var body: some View {
        switch self {
        case .puzzle01:
            Puzzle01(input: Input.puzzle01.input)
                .navigationTitle(name)
        case .puzzle02:
            Puzzle02(
                input: Input.puzzle02.input,
                bag: Bag(red: 12, green: 13, blue: 14)
            )
            .navigationTitle(name)
        case .puzzle03:
            Puzzle03(input: Input.puzzle03.input)
                .navigationTitle(name)
        case .puzzle04:
            Puzzle04(input: Input.puzzle04.input)
                .navigationTitle(name)
        case .puzzle05:
            Puzzle05(input: Input.puzzle05.input)
                .navigationTitle(name)
        case .puzzle06:
            Puzzle06(input: Input.puzzle06.input)
                .navigationTitle(name)
        case .puzzle07:
            Puzzle07(input: Input.puzzle07.input)
                .navigationTitle(name)
        case .puzzle08:
            Puzzle08(input: Input.puzzle08.input)
                .navigationTitle(name)
        case .puzzle09:
            Puzzle09(input: Input.puzzle09.input)
                .navigationTitle(name)
        case .puzzle10:
            Puzzle10(input: Input.puzzle10.input)
                .navigationTitle(name)
        case .puzzle11:
            Puzzle11(input: Input.puzzle11.input)
                .navigationTitle(name)
        case .puzzle12:
            Puzzle12(input: Input.puzzle12.input)
                .navigationTitle(name)
        case .puzzle13:
            Puzzle13(input: Input.puzzle13.input)
                .navigationTitle(name)
        case .puzzle14:
            Puzzle14(input: Input.puzzle14.input)
                .navigationTitle(name)
        case .puzzle15:
            Puzzle15(input: Input.puzzle15.input)
                .navigationTitle(name)
        case .puzzle16:
            Puzzle16(input: Input.puzzle16.input)
                .navigationTitle(name)
        case .puzzle17:
            Puzzle17(input: Input.puzzle17.input)
                .navigationTitle(name)
        case .puzzle18:
            Puzzle18(input: Input.puzzle18.input)
                .navigationTitle(name)
        case .puzzle19:
            Puzzle19(input: Input.puzzle19.input)
                .navigationTitle(name)
        case .puzzle20:
            Puzzle20(input: Input.puzzle20.input)
                .navigationTitle(name)
        case .puzzle21:
            Puzzle21(input: Input.puzzle21.input)
                .navigationTitle(name)
        default: EmptyView()
        }
    }
}

struct ContentView: View {
    @State private var path: [Puzzle] = []

    var body: some View {
        NavigationStack(path: $path) {
            List(Puzzle.allCases.reversed(), id: \.self) { puzzle in
                NavigationLink(value: puzzle, label: {
                    Text(puzzle.name)
                })
            }
            .navigationTitle("Advent of Code 2023")
            .navigationDestination(for: Puzzle.self) { puzzle in
                puzzle.body
            }
        }
    }
}

#Preview {
    ContentView()
}
