//
//  Puzzle17.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-17.
//

import SwiftUI

struct Puzzle17: View {
    let input: String

    @State private var presentInput: Bool = false

    @State private var isSolving: Bool = false
    @State private var answerFirst: Int?
    @State private var answerSecond: Int?
    @State private var paths: Int = 0

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text("Paths: \(paths)")
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

//        let input = Input.puzzle17.testInput
        let (map, size) = Self.parse(input: input)

        var minLossMap: [Point: [Path.Straight: Int]] = [:]

        for y in 0..<size.height {
            for x in 0..<size.width {
                print(map[Point(x: x, y: y), default: -1], terminator: "")
            }
            print("")
        }

        var pathCache: Set<Path> = Set(Direction.allCases.map { direction in
            Path(location: .zero, heatLoss: 0, goingStraight: .init(distance: 0, direction: direction))
        })

        var paths: Set<Path> = [pathCache.removeFirst()]

        while paths.isNotEmpty {
            let count = paths.count
            if count % 1000 == 0 {
                await MainActor.run {
                    self.paths = count
                }
            }

            let path = paths.removeFirst()
            if pathCache.contains(path) {
                continue
            }

            pathCache.insert(path)

            let point = path.location

            let neighbors: [(direction: Direction, point: Point)] = Direction.allCases.filter {
                !(path.goingStraight.distance >= 3 && (path.goingStraight.direction == $0 || path.goingStraight.direction.opposite == $0))
            }.map {
                (direction: $0, point: point.location(for: $0))
            }.filter { direction, point in
                size.isPointInside(point)
            }

            guard neighbors.isNotEmpty else {
                continue
            }

            for neighbor in neighbors {
                let newStraight: Path.Straight

                if path.goingStraight.distance <= 0 {
                    newStraight = Path.Straight(distance: 1, direction: neighbor.direction)
                } else if path.goingStraight.direction != neighbor.direction {
                    newStraight = Path.Straight(distance: 1, direction: neighbor.direction)
                } else {
                    guard path.goingStraight.direction == neighbor.direction else {
                        assertionFailure("Something went wrong")
                        return
                    }
                    newStraight = Path.Straight(distance: path.goingStraight.distance + 1, direction: neighbor.direction)
                }

                let heatLoss = path.heatLoss + map[neighbor.point]!
                var minLossDict = minLossMap[neighbor.point, default: [:]]
                guard heatLoss <= minLossDict[newStraight, default: Int.max] else {
                    continue
                }
                minLossDict[newStraight] = heatLoss
                minLossMap[neighbor.point] = minLossDict

                let path = Path(
                    location: neighbor.point,
                    heatLoss: heatLoss,
                    goingStraight: newStraight
                )

                if !pathCache.contains(path) && neighbor.point != Point(x: size.width-1, y: size.height-1) {
                    paths.insert(path)
                }
            }
        }

//        print("=====")
//
//        for y in 0..<size.height {
//            for x in 0..<size.width {
//                print(minLossMap[Point(x: x, y: y), default: -1], terminator: "\t")
//            }
//            print("")
//        }

        let result = minLossMap[Point(x: size.width - 1, y: size.height - 1), default: [:]].values.min() ?? -1

        await MainActor.run {
            print("Result 1: \(result)")
            answerFirst = result
        }
    }

    private func solveSecond() async {
        answerSecond = nil

        let result = 0

        await MainActor.run {
            print("Result 2: \(result)")
            answerSecond = result
        }
    }

    private static func parse(input: String) -> (map: [Point: Int], size: Size) {
        var size = Size.zero
        let map: [Point: Int] = Dictionary(uniqueKeysWithValues: input
            .components(separatedBy: .newlines)
            .filter(\.isNotEmpty)
//            .prefix(80)
            .enumerated().flatMap { row, line in
                size.height = row + 1
                return line
//                    .prefix(80)
                    .enumerated().map { column, character in
                        size.width = column + 1
                        return (Point(x: column, y: row), Int(String(character))!)
                    }
            }
        )

        return (map, size)
    }
}

private struct Path: Hashable, CustomStringConvertible {
    let location: Point
    let heatLoss: Int
    let goingStraight: Straight

    struct Straight: Hashable {
        let distance: Int
        let direction: Direction

        func hash(into hasher: inout Hasher) {
            hasher.combine(distance)
            if distance == 3 {
                switch direction {
                case .north, .south:
                    hasher.combine("Vertical")
                case .west, .east:
                    hasher.combine("Horizontal")
                }
            } else {
                hasher.combine(direction.rawValue)
            }
        }

        static func ==(lhs: Self, rhs: Self) -> Bool {
            (lhs.distance == 3 && rhs.distance == 3 && (lhs.direction == rhs.direction || lhs.direction.opposite == rhs.direction)) || (lhs.distance == rhs.distance && lhs.direction == rhs.direction)
        }
    }

    var description: String {
        """
Location: \(location)
Heatloss: \(heatLoss)
GoingStraight in \(goingStraight.direction) for \(goingStraight.distance)
"""
    }
}

#Preview {
    Puzzle17(input: Input.puzzle17.testInput)
}
