//
//  Puzzle01.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-01.
//

import SwiftUI

struct Puzzle01: View {
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
            }
            Button(
                action: {
                    Task {
//                        await solveFirst()
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
        }
        .overlay {
            if isSolving {
                ProgressView()
            }
        }
        .navigationTitle("Puzzle 01")
        .navigationBarTitleDisplayMode(.inline)
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
                        .navigationBarTitleDisplayMode(.inline)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
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

        let result = input.components(separatedBy: "\n").filter(\.isNotEmpty).map { line in
            let numbers = line.filter { $0.isNumber }
            guard let first = numbers.first, let last = numbers.last else {
                assertionFailure("No numbers")
                return 0
            }
            let numberStirng = "\(first)\(last)"
            guard let number = Int(numberStirng) else {
                assertionFailure("Cannot find number")
                return 0
            }
            return number
        }.reduce(0, +)

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

        let result = input.components(separatedBy: "\n").filter(\.isNotEmpty).map { line in
            let numbers = Numbers.allCases
                .compactMap { number in
                    line.indicesOf(string: number.rawValue).map({
                        (number: number.number, index: $0)
                    })
                }
                .flatMap({ $0 })
                .sorted { left, right in
                    left.index < right.index
                }
                .map(\.number)

            guard let first = numbers.first, let last = numbers.last else {
                assertionFailure("No numbers")
                return 0
            }
            let numberStirng = "\(first)\(last)"
            print(numberStirng)
            guard let number = Int(numberStirng) else {
                assertionFailure("Cannot find number")
                return 0
            }
            return number
        }.reduce(0, +)

        await MainActor.run {
            answerSecond = result
        }
    }
}

private enum Numbers: String, CaseIterable {
    case one, two, three, four, five, six, seven, eight, nine
    case oneDigit = "1"
    case twoDigit = "2"
    case threeDigit = "3"
    case fourDigit = "4"
    case fiveDigit = "5"
    case sixDigit = "6"
    case sevenDigit = "7"
    case eightDigit = "8"
    case nineDigit = "9"

    var number: Int {
        switch self {
        case .one, .oneDigit:
            return 1
        case .two, .twoDigit:
            return 2
        case .three, .threeDigit:
            return 3
        case .four, .fourDigit:
            return 4
        case .five, .fiveDigit:
            return 5
        case .six, .sixDigit:
            return 6
        case .seven, .sevenDigit:
            return 7
        case .eight, .eightDigit:
            return 8
        case .nine, .nineDigit:
            return 9
        }
    }
}

#Preview {
    NavigationView {
        Puzzle01(input: Input.puzzle01.testInput(number: 1))
    }
}
