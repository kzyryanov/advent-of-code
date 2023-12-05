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

    var name: String { rawValue }

    @ViewBuilder
    var body: some View {
        switch self {
        case .puzzle01:
            Puzzle01(input: Input.puzzle01.input)
                .navigationTitle(self.name)
        case .puzzle02:
            Puzzle02(
                input: Input.puzzle02.input,
                bag: Bag(red: 12, green: 13, blue: 14)
            )
            .navigationTitle(self.name)
        case .puzzle03:
            Puzzle03(input: Input.puzzle03.input)
                .navigationTitle(self.name)
        case .puzzle04:
            Puzzle04(input: Input.puzzle04.input)
                .navigationTitle(self.name)
        case .puzzle05:
            Puzzle05(input: Input.puzzle05.input)
                .navigationTitle(self.name)
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
