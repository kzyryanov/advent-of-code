//
//  PuzzleView.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-01.
//

import SwiftUI

@MainActor
protocol PuzzleViewModel: Observable, AnyObject {
    var answer: Answer { get set }
    var puzzle: Puzzle { get }

    func solveOne(input: String) async -> String
    func solveTwo(input: String) async -> String
}

extension PuzzleViewModel {
    func testSolveOne() async {
        let input = puzzle.testInput
        answer.oneTest = await solveOne(input: input)
    }

    func testSolveTwo() async {
        answer.twoTest = await solveTwo(input: puzzle.testInput)
    }

    func solveOne() async {
        answer.one = await solveOne(input: puzzle.input)
    }

    func solveTwo() async {
        answer.two = await solveTwo(input: puzzle.input)
    }
}

struct Answer: Sendable {
    var oneTest: String = "One test"
    var twoTest: String = "Two test"
    var one: String = "One"
    var two: String = "Two"
}

struct PuzzleView: View {
    @State var viewModel: PuzzleViewModel

    var body: some View {
        VStack(spacing: 32) {
            VStack {
                Text("Example data result")
                    .font(.headline)
                VStack {
                    HStack {
                        Text(viewModel.answer.oneTest)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        AsyncButton(title: "Solve") {
                            await viewModel.testSolveOne()
                        }
                    }
                    HStack {
                        Text(viewModel.answer.twoTest)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        AsyncButton(title: "Solve") {
                            await viewModel.testSolveTwo()
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
