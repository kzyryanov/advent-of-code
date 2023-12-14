//
//  Puzzle11.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-11.
//

import SwiftUI

struct Puzzle11: View {
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
        isSolving = true
        defer {
            isSolving = false
        }

        var galaxyId = 0
        let universe: [Int: Point] = Dictionary(uniqueKeysWithValues: input.components(separatedBy: .newlines).filter(\.isNotEmpty).enumerated().flatMap { row, line in
            line.enumerated().compactMap { column, symbol in
                if symbol == "#" {
                    let pair = (galaxyId, Point(x: column, y: row))
                    galaxyId += 1
                    return pair
                }
                return nil
            }
        })

        var expandXFrom: [Int] = []
        var expandYFrom: [Int] = []

        let groupedByX = Dictionary(grouping: universe) { $1.x }
        let groupedByY = Dictionary(grouping: universe) { $1.y }

        let reversed = Dictionary(uniqueKeysWithValues: universe.map { ($1, $0) })
        let sizeX = reversed.keys.map(\.x).max() ?? 0
        let sizeY = reversed.keys.map(\.y).max() ?? 0

        for x in 0...sizeX {
            if nil == groupedByX[x] {
                expandXFrom.append(x)
            }
        }

        for y in 0...sizeY {
            if nil == groupedByY[y] {
                expandYFrom.append(y)
            }
        }

        let expandXGalaxies = Dictionary(grouping: expandXFrom.flatMap { expand in
            (expand...sizeX).flatMap { x in
                groupedByX[x, default: []].map { $0.key }
            }
        }) { $0 }

        let expandYGalaxies = Dictionary(grouping: expandYFrom.flatMap { expand in
            (expand...sizeY).flatMap { y in
                groupedByY[y, default: []].map { $0.key }
            }
        }) { $0 }

        let expandedUniverse: [Int: Point] = Dictionary(uniqueKeysWithValues: universe.map { galaxyId, location in
            let expandByX = expandXGalaxies[galaxyId, default: []].count
            let expandByY = expandYGalaxies[galaxyId, default: []].count
            return (galaxyId, Point(x: location.x + expandByX, y: location.y + expandByY))
        })

        let galaxyIds = expandedUniverse.keys.sorted(by: <)
        guard let maxGalaxyId = galaxyIds.max() else {
            assertionFailure("Something went wrong")
            return
        }

        var distancies: [Int] = []
        for galaxyIdOne in galaxyIds.dropLast() {
            for galaxyIdTwo in galaxyIdOne+1...maxGalaxyId {
                let one = expandedUniverse[galaxyIdOne]!
                let two = expandedUniverse[galaxyIdTwo]!
                let distance = abs(two.x - one.x) + abs(two.y - one.y)
                distancies.append(distance)
            }
        }

        let result = distancies.reduce(0, +)

        await MainActor.run {
            print("Result 1: \(result)")
            answerFirst = result
        }
    }

    private func solveSecond() async {
        answerSecond = nil
        isSolving = true
        defer {
            isSolving = false
        }

        var galaxyId = 0
        let universe: [Int: Point] = Dictionary(uniqueKeysWithValues: input.components(separatedBy: .newlines).filter(\.isNotEmpty).enumerated().flatMap { row, line in
            line.enumerated().compactMap { column, symbol in
                if symbol == "#" {
                    let pair = (galaxyId, Point(x: column, y: row))
                    galaxyId += 1
                    return pair
                }
                return nil
            }
        })

        var expandXFrom: [Int] = []
        var expandYFrom: [Int] = []

        let groupedByX = Dictionary(grouping: universe) { $1.x }
        let groupedByY = Dictionary(grouping: universe) { $1.y }

        let reversed = Dictionary(uniqueKeysWithValues: universe.map { ($1, $0) })
        let sizeX = reversed.keys.map(\.x).max() ?? 0
        let sizeY = reversed.keys.map(\.y).max() ?? 0

        for x in 0...sizeX {
            if nil == groupedByX[x] {
                expandXFrom.append(x)
            }
        }

        for y in 0...sizeY {
            if nil == groupedByY[y] {
                expandYFrom.append(y)
            }
        }

        let expandXGalaxies = Dictionary(grouping: expandXFrom.flatMap { expand in
            (expand...sizeX).flatMap { x in
                groupedByX[x, default: []].map { $0.key }
            }
        }) { $0 }

        let expandYGalaxies = Dictionary(grouping: expandYFrom.flatMap { expand in
            (expand...sizeY).flatMap { y in
                groupedByY[y, default: []].map { $0.key }
            }
        }) { $0 }

        let expandedUniverse: [Int: Point] = Dictionary(uniqueKeysWithValues: universe.map { galaxyId, location in
            let expandByX = expandXGalaxies[galaxyId, default: []].count * (1_000_000 - 1)
            let expandByY = expandYGalaxies[galaxyId, default: []].count * (1_000_000 - 1)
            return (galaxyId, Point(x: location.x + expandByX, y: location.y + expandByY))
        })

        let galaxyIds = expandedUniverse.keys.sorted(by: <)
        guard let maxGalaxyId = galaxyIds.max() else {
            assertionFailure("Something went wrong")
            return
        }

        var distancies: [Int] = []
        for galaxyIdOne in galaxyIds.dropLast() {
            for galaxyIdTwo in galaxyIdOne+1...maxGalaxyId {
                let one = expandedUniverse[galaxyIdOne]!
                let two = expandedUniverse[galaxyIdTwo]!
                let distance = abs(two.x - one.x) + abs(two.y - one.y)
                distancies.append(distance)
            }
        }

        let result = distancies.reduce(0, +)

        await MainActor.run {
            print("Result 2: \(result)")
            answerSecond = result
        }
    }

    private func printUniverse(_ universe: [Int: Point]) {
        let reversed = Dictionary(uniqueKeysWithValues: universe.map { ($1, String($0)) })
        let sizeX = reversed.keys.map(\.x).max() ?? 0
        let sizeY = reversed.keys.map(\.y).max() ?? 0
        for row in 0...sizeY {
            for column in 0...sizeX {
                print(reversed[Point(x: column, y: row), default: "."], terminator: "")
            }
            print("")
        }
    }
}

#Preview {
    Puzzle11(input: Input.puzzle11.testInput)
}
