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
        }
    }
}

struct ContentView: View {
    @State private var path: [Puzzle] = []

    var body: some View {
        NavigationStack(path: $path) {
            List(Puzzle.allCases, id: \.self) { puzzle in
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
