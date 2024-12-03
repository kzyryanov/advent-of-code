//
//  PuzzleView.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-01.
//

import SwiftUI

struct PuzzleView: View {
    @State var viewModel: PuzzleViewModel

    var body: some View {
        VStack(spacing: 32) {
            VStack {
                Text("Example data result")
                    .font(.headline)
                VStack {
                    ForEach(viewModel.puzzle.testInputs.indices, id: \.self) { index in
                        HStack {
                            Text(viewModel.answer.oneTest[index, default: "One test \(index)"])
                                .frame(maxWidth: .infinity, alignment: .leading)

                            AsyncButton(title: "Solve") {
                                await viewModel.testSolveOne(index: index)
                            }
                        }
                        HStack {
                            Text(viewModel.answer.twoTest[index, default: "Two test \(index)"])
                                .frame(maxWidth: .infinity, alignment: .leading)

                            AsyncButton(title: "Solve") {
                                await viewModel.testSolveTwo(index: index)
                            }
                        }
                    }
                }
            }

            VStack {
                Text("Data result")
                    .font(.headline)
                VStack {
                    HStack {
                        Text(viewModel.answer.one)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        AsyncButton(title: "Solve") {
                            await viewModel.solveOne()
                        }
                    }
                    HStack {
                        Text(viewModel.answer.two)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        AsyncButton(title: "Solve") {
                            await viewModel.solveTwo()
                        }
                    }
                }
            }
        }
        .textSelection(.enabled)
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .navigationTitle(viewModel.puzzle.name)
    }
}

#Preview {
    PuzzleView(viewModel: Puzzle01ViewModel(puzzle: .puzzle01))
}
