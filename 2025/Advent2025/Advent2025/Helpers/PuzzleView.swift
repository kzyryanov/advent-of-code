//
//  PuzzleView.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-01.
//

import SwiftUI

struct PuzzleView: View {
    @State var viewModel: PuzzleViewModel
    @State var answer: Answer = Answer()

    var body: some View {
        VStack(spacing: 32) {
            VStack {
                Text("Example data result")
                    .font(.headline)
                VStack {
                    ForEach(viewModel.puzzle.testInputs.indices, id: \.self) { index in
                        HStack {
                            Text(answer.oneTest[index, default: "One test \(index)"])
                                .frame(maxWidth: .infinity, alignment: .leading)

                            AsyncButton(title: "Solve") {
                                answer.oneTest[index] = await viewModel.testSolveOne(index: index)
                            }
                        }
                        HStack {
                            Text(answer.twoTest[index, default: "Two test \(index)"])
                                .frame(maxWidth: .infinity, alignment: .leading)

                            AsyncButton(title: "Solve") {
                                answer.twoTest[index] = await viewModel.testSolveTwo(index: index)
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
                        Text(answer.one)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        AsyncButton(title: "Solve") {
                            answer.one = await viewModel.solveOne()
                        }
                    }
                    HStack {
                        Text(answer.two)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        AsyncButton(title: "Solve") {
                            answer.two = await viewModel.solveTwo()
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
