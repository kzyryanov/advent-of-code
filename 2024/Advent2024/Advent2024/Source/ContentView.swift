//
//  ContentView.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-01.
//

import SwiftUI

struct ContentView: View {
    @State private var path: [Puzzle] = []

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(Puzzle.allCases, id: \.self) { puzzle in
                    NavigationLink(value: puzzle) {
                        Text(puzzle.name)
                    }
                }
            }
            .navigationDestination(for: Puzzle.self) { puzzle in
                PuzzleView(viewModel: puzzle.viewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
