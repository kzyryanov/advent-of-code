//
//  Puzzle21.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-21.
//

import SwiftUI

struct Puzzle21: View {
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
                        isSolving = true
                        defer {
                            isSolving = false
                        }
                        let clock = ContinuousClock()
                        let result1 = await clock.measure {
                            await solveFirst()
                        }
                        print("Result 1: \(result1)")
                        let result2 = await clock.measure {
                            await solveSecond()
                        }
                        print("Result 2: \(result2)")
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

        let (rocks, size, startingPosition) = Self.parse(input: input)

        var possibleLocations: Set<Point> = [startingPosition]

        let steps = 64

        for _ in 1...steps {
            possibleLocations = Set(possibleLocations.flatMap { location in
                Direction.allCases.compactMap { direction in
                    let newLocation = location.location(for: direction)
                    if size.isPointInside(newLocation) && !rocks.contains(newLocation) {
                        return newLocation
                    }
                    return nil
                }
            })
        }

        let result = possibleLocations.count

        await MainActor.run {
            print("Result 1: \(result)")
            answerFirst = result
        }
    }

    private func solveSecond() async {
        answerSecond = nil

//        let input = Input.puzzle21.testInput
//        let (rocks, size, startingPosition) = Self.parse(input: input)
//
//        let steps = 6
//
//        let maxLocations = pow(Decimal((steps + 1)), 2)
//
//        for y in (-steps)...steps {
//            let xCount = (steps - abs(y)) + 1
//            for x in 0...xCount {
//                let point = Point(x: <#T##Int#>, y: <#T##Int#>)
//            }
//        }

//        for rock in rocks {
//            let diffX = abs(rock.x - startingPosition.x)
//            let diffY = abs(rock.y - startingPosition.y)
//            if steps % 2 == 0 {
//                let distance
//            }
//        }

//        print(maxLocations)

//        for _ in 1...steps {
//            possibleLocations = Set(possibleLocations.flatMap { location in
//                Direction.allCases.compactMap { direction in
//                    let newLocation = location.location(for: direction)
//                    if size.isPointInside(newLocation) && !rocks.contains(newLocation) {
//                        return newLocation
//                    }
//                    return nil
//                }
//            })
//        }

        let result = 0// possibleLocations.count

        await MainActor.run {
            print("Result 2: \(result)")
            answerSecond = result
        }
    }

    private static func parse(input: String) -> (rocks: Set<Point>, size: Size, startingPosition: Point) {
        var startingPosition: Point = .zero
        var size: Size = .zero

        let rocks = Set(input.components(separatedBy: .newlines).filter(\.isNotEmpty).enumerated().flatMap { row, line in
            size.height = row + 1
            return line.enumerated().compactMap { column, character in
                size.width = column + 1
                switch character {
                case "#": return Point(x: column, y: row)
                case "S":
                    startingPosition = Point(x: column, y: row)
                    return nil
                default:
                    return nil
                }
            }
        })

        return (rocks, size, startingPosition)
    }
}

#Preview {
    Puzzle21(input: Input.puzzle21.testInput)
}
