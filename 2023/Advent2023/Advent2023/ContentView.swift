//
//  ContentView.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-01.
//

import SwiftUI

enum Puzzle: CaseIterable {
    case puzzle01

    var name: String {
        switch self {
        case .puzzle01:
            return "Puzzle 01"
        }
    }

    @ViewBuilder
    var body: some View {
        switch self {
        case .puzzle01:
            Puzzle01(input: Input.puzzle01.input)
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
