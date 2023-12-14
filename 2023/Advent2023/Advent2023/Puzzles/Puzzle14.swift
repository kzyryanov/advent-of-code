//
//  Puzzle14.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-14.
//

import SwiftUI

struct Puzzle14: View {
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

        let map: [[(location: Point, type: Rock)]] = input
            .components(separatedBy: .newlines)
            .filter(\.isNotEmpty)
            .map { Array($0) }
            .transpose
            .enumerated()
            .map { columnIndex, column in
                column.enumerated().compactMap { rowIndex, character in
                    Rock(rawValue: character).map {
                        (Point(x: columnIndex, y: rowIndex), $0)
                    }
                }
            }

        let size = map.count

        let sortedMap: [[(location: Point, type: Rock)]] = map.map { column in
            var newColumn: [(Point, Rock)] = []
            var fix = -1
            for rock in column {
                switch rock.type {
                case .cube:
                    newColumn.append(rock)
                    fix = rock.location.y
                case .round:
                    fix += 1
                    newColumn.append((Point(x: rock.location.x, y: fix), .round))
                }
            }

            return newColumn
        }

        let result = sortedMap.flatMap {
            $0.compactMap { (location: Point, type: Rock) -> Int? in
                switch type {
                case .cube: return nil
                case .round: return size - location.y
                }
            }
        }.reduce(0, +)

        await MainActor.run {
            print("Result 1: \(result)")
            answerFirst = result
        }
    }

    private func solveSecond() async {
        answerSecond = nil

        var size = Point(x: 0, y: 0)

        let map: [Point: Rock] = Dictionary(
            uniqueKeysWithValues: input
                .components(separatedBy: .newlines)
                .filter(\.isNotEmpty)
                .enumerated()
                .flatMap { row, line in
                    line.enumerated().compactMap { column, element in
                        size = Point(x: column+1, y: row+1)
                        return Rock(rawValue: element).map {
                            (Point(x: column, y: row), $0)
                        }
                    }
                }
        )

        var cache: [CacheKey: [Point: Rock]] = [:]
        var lastIndices: [CacheKey: Int] = [:]

        var sortedMap: [Point: Rock] = map

        func transform() {
            Direction.allCases.forEach { direction in

                let cacheKey = CacheKey(direction: direction, map: sortedMap)

                if let cachedMap = cache[cacheKey] {
                    sortedMap = cachedMap
                    return
                }

                switch direction {
                case .north:
                    (0..<size.x).forEach { x in
                        var fix = -1
                        for y in 0..<size.y {
                            let location = Point(x: x, y: y)
                            guard let rock = sortedMap[location] else {
                                continue
                            }
                            switch rock {
                            case .cube:
                                fix = location.y
                            case .round:
                                fix += 1
                                sortedMap[location] = nil
                                sortedMap[Point(x: x, y: fix)] = .round
                            }
                        }
                    }
                case .west:
                    (0..<size.y).forEach { y in
                        var fix = -1
                        for x in 0..<size.x {
                            let location = Point(x: x, y: y)
                            guard let rock = sortedMap[location] else {
                                continue
                            }
                            switch rock {
                            case .cube:
                                fix = location.x
                            case .round:
                                fix += 1
                                sortedMap[location] = nil
                                sortedMap[Point(x: fix, y: y)] = .round
                            }
                        }
                    }
                case .south:
                    (0..<size.x).forEach { x in
                        var fix = size.y
                        for y in (0..<size.y).reversed() {
                            let location = Point(x: x, y: y)
                            guard let rock = sortedMap[location] else {
                                continue
                            }
                            switch rock {
                            case .cube:
                                fix = location.y
                            case .round:
                                fix -= 1
                                sortedMap[location] = nil
                                sortedMap[Point(x: x, y: fix)] = .round
                            }
                        }
                    }
                case .east:
                    (0..<size.y).forEach { y in
                        var fix = size.x
                        for x in (0..<size.x).reversed() {
                            let location = Point(x: x, y: y)
                            guard let rock = sortedMap[location] else {
                                continue
                            }
                            switch rock {
                            case .cube:
                                fix = location.x
                            case .round:
                                fix -= 1
                                sortedMap[location] = nil
                                sortedMap[Point(x: fix, y: y)] = .round
                            }
                        }
                    }
                }
                cache[cacheKey] = sortedMap
            }
        }

        let iterations = 1_000_000_000

        func repeatTransform(startIndex: Int, iterations: Int) {
            for index in startIndex..<iterations {
                if let lastIndex = lastIndices[CacheKey(direction: .north, map: sortedMap)] {
                    let cycleLength = index - lastIndex
                    let endMapIndex = (iterations - lastIndex) % cycleLength + lastIndex
                    sortedMap = lastIndices.first(where: { $0.value == endMapIndex })!.key.map
                    return
                }
                lastIndices[CacheKey(direction: .north, map: sortedMap)] = index
                transform()
            }
        }

        repeatTransform(startIndex: 0, iterations: iterations)

        (0..<size.y).forEach { y in
            (0..<size.x).forEach { x in
                if let rock = sortedMap[Point(x: x, y: y)] {
                    print(rock.rawValue, terminator: "")
                } else {
                    print(".", terminator: "")
                }
            }
            print("")
        }

        let result = (0..<size.y).flatMap { y in
            (0..<size.x).compactMap { x in
                if sortedMap[Point(x: x, y: y)] == .round {
                    return size.y - y
                }
                return nil
            }
        }.reduce(0, +)

        await MainActor.run {
            print("Result 2: \(result)")
            answerSecond = result
        }
    }
}

private struct CacheKey: Hashable, Equatable {
    let direction: Direction
    let map: [Point: Rock]
}

private enum Direction: Hashable, Equatable, CaseIterable {
    case north, west, south, east
}

private enum Rock: Character, Equatable, Hashable, CustomStringConvertible {
    case round = "O"
    case cube = "#"

    var description: String { String(rawValue) }
}

#Preview {
    Puzzle14(input: Input.puzzle14.testInput)
}
