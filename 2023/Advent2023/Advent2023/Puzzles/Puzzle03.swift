//
//  Puzzle.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-04.
//

import SwiftUI

struct Puzzle03: View {
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

        let lines = input.components(separatedBy: "\n").filter(\.isNotEmpty)

        var symbolsLocations: [Point] = []

        let numbers = lines.enumerated().flatMap { row, line in
            var numbers: [(number: Int, rect: Rect)] = []
            var numberString = ""
            var startColumn: Int?
            for (column, character) in line.enumerated() {
                switch character {
                case character where character.isNumber:
                    startColumn = startColumn ?? column
                    numberString.append(character)
                default:
                    if let startColumn, numberString.isNotEmpty {
                        numbers.append((
                            number: Int(numberString)!,
                            rect: Rect(
                                point: Point(x: startColumn - 1, y: row - 1),
                                size: Size(width: numberString.count + 2, height: 3)
                            )
                        ))
                    }
                    numberString = ""
                    startColumn = nil

                    if character != "." {
                        symbolsLocations.append(Point(
                            x: column,
                            y: row
                        ))
                    }
                }
            }

            if let startColumn, numberString.isNotEmpty {
                numbers.append((
                    number: Int(numberString)!,
                    rect: Rect(
                        point: Point(x: startColumn - 1, y: row - 1),
                        size: Size(width: numberString.count + 2, height: 3)
                    )
                ))
            }
            numberString = ""
            startColumn = nil

            return numbers
        }

        let filterredNumbers = numbers.compactMap { number in
            for symbol in symbolsLocations {
                if number.rect.contains(symbol) {
                    return number.number
                }
            }
            return nil
        }

        let result = filterredNumbers.reduce(0, +)

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

        let lines = input.components(separatedBy: "\n").filter(\.isNotEmpty)

        var gearsLocations: [Point] = []

        let numbers = lines.enumerated().flatMap { row, line in
            var numbers: [(number: Int, rect: Rect)] = []
            var numberString = ""
            var startColumn: Int?
            for (column, character) in line.enumerated() {
                switch character {
                case character where character.isNumber:
                    startColumn = startColumn ?? column
                    numberString.append(character)
                default:
                    if let startColumn, numberString.isNotEmpty {
                        numbers.append((
                            number: Int(numberString)!,
                            rect: Rect(
                                point: Point(x: startColumn - 1, y: row - 1),
                                size: Size(width: numberString.count + 2, height: 3)
                            )
                        ))
                    }
                    numberString = ""
                    startColumn = nil

                    if character == "*" {
                        gearsLocations.append(Point(
                            x: column,
                            y: row
                        ))
                    }
                }
            }

            if let startColumn, numberString.isNotEmpty {
                numbers.append((
                    number: Int(numberString)!,
                    rect: Rect(
                        point: Point(x: startColumn - 1, y: row - 1),
                        size: Size(width: numberString.count + 2, height: 3)
                    )
                ))
            }
            numberString = ""
            startColumn = nil

            return numbers
        }

        var ratios: [Int] = []
        for gear in gearsLocations {
            var gearNumbers: [Int] = []
            for number in numbers {
                if number.rect.contains(gear) {
                    gearNumbers.append(number.number)
                }
            }
            if gearNumbers.count == 2 {
                ratios.append(gearNumbers.reduce(1, *))
            }
        }

        let result = ratios.reduce(0, +)

        await MainActor.run {
            answerSecond = result
        }
    }
}

private struct Size: CustomStringConvertible {
    let width, height: Int

    var description: String {
        "(width: \(width), height: \(height))"
    }
}

private struct Rect: CustomStringConvertible {
    let point: Point
    let size: Size

    var description: String {
        "(point: \(point), size: \(size))"
    }

    func contains(_ point: Point) -> Bool {
        self.point.x <= point.x &&
        self.point.y <= point.y &&
        self.point.x + size.width > point.x &&
        self.point.y + size.height > point.y
    }
}



#Preview {
    Puzzle03(input: Input.puzzle03.testInput)
}
