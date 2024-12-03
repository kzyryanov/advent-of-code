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
    func testSolveOne(index: Int) async {
        let clock = ContinuousClock()
        let result = await clock.measure {
            answer.oneTest[index] = await solveOne(input: puzzle.testInputs[index])
        }
        debugPrint("Time \(puzzle.name) test one: \(result)")
    }

    func testSolveTwo(index: Int) async {
        let clock = ContinuousClock()
        let result = await clock.measure {
            answer.twoTest[index] = await solveTwo(input: puzzle.testInputs[index])
        }
        debugPrint("Time \(puzzle.name) test two: \(result)")
    }

    func solveOne() async {
        let clock = ContinuousClock()
        let result = await clock.measure {
            answer.one = await solveOne(input: puzzle.input)
        }
        debugPrint("Time \(puzzle.name) one: \(result)")
    }

    func solveTwo() async {
        let clock = ContinuousClock()
        let result = await clock.measure {
            answer.two = await solveTwo(input: puzzle.input)
        }
        debugPrint("Time \(puzzle.name) two: \(result)")
    }
}

struct Answer: Sendable {
    var oneTest: [Int: String] = [:]
    var twoTest: [Int: String] = [:]
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
