//
//  Puzzle.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-04.
//

import SwiftUI

struct PuzzleView: View {
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

        let result = 0

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

        let result = 0

        await MainActor.run {
            answerSecond = result
        }
    }
}

#Preview {
    PuzzleView(input: "")
}