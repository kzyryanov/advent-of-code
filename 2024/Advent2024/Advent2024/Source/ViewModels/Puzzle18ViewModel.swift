//
//  Puzzle18ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-18.
//

import SwiftUI

@Observable
final class Puzzle18ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String, isTest: Bool) async -> String {
        let bytes = data(from: input)

        let memorySize: Size
        if isTest {
            memorySize = Size(width: 7, height: 7)
        } else {
            memorySize = Size(width: 71, height: 71)
        }

        let rect = Rect(origin: .zero, size: memorySize)

        let length: Int
        if isTest {
            length = 12
        } else {
            length = 1024
        }

        let prefixBytes = bytes.prefix(length)

        var memory: [Point: Bool] = [:]

        for x in 0..<memorySize.width {
            for y in 0..<memorySize.height {
                let point = Point(x: x, y: y)
                if prefixBytes.contains(point) {
                    memory[point] = true
                } else {
                    memory[point] = false
                }
            }
        }

        var pointsOfInterest: Set<Point> = [.zero]
        var costs: [Point: (cost: Int, path: [Point])] = [.zero: (0, [])]

        while pointsOfInterest.isNotEmpty {
            let pointOfInterest = pointsOfInterest.removeFirst()
            guard let costInPoint = costs[pointOfInterest] else {
                fatalError("No cost for visited point")
            }

            let directions = Direction.noDiagonals
            for direction in directions {
                let moved = direction.move(from: pointOfInterest)
                guard rect.isPointInside(moved) && !memory[moved, default: false] else {
                    continue
                }
                let cost = costInPoint.cost + 1
                let path = costInPoint.path + [moved]
                let savedCost = costs[moved, default: (Int.max, [])]
                if cost < savedCost.cost {
                    pointsOfInterest.insert(moved)
                    costs[moved] = (cost, path)
                }
            }
        }

        printMap(memory, size: memorySize)
        guard let cost = costs[Point(x: memorySize.width - 1, y: memorySize.height - 1)] else {
            return "Not found"
        }

        return "\(cost.cost)"
    }

    func solveTwo(input: String, isTest: Bool) async -> String {
        let bytes = data(from: input)

        let memorySize: Size
        if isTest {
            memorySize = Size(width: 7, height: 7)
        } else {
            memorySize = Size(width: 71, height: 71)
        }

        let rect = Rect(origin: .zero, size: memorySize)

        var passIndex: Int = 0
        var blockedIndex: Int = bytes.count - 1
        var iterations: Int = 0

        while passIndex != blockedIndex-1 {
            let index = (blockedIndex + passIndex) / 2

            let prefixBytes = bytes.prefix(index + 1)

            var memory: [Point: Bool] = [:]

            for x in 0..<memorySize.width {
                for y in 0..<memorySize.height {
                    let point = Point(x: x, y: y)
                    if prefixBytes.contains(point) {
                        memory[point] = true
                    } else {
                        memory[point] = false
                    }
                }
            }

            var pointsOfInterest: Set<Point> = [.zero]
            var costs: [Point: (cost: Int, path: [Point])] = [.zero: (0, [])]

            while pointsOfInterest.isNotEmpty {
                let pointOfInterest = pointsOfInterest.removeFirst()
                guard let costInPoint = costs[pointOfInterest] else {
                    fatalError("No cost for visited point")
                }

                let directions = Direction.noDiagonals
                for direction in directions {
                    let moved = direction.move(from: pointOfInterest)
                    guard rect.isPointInside(moved) && !memory[moved, default: false] else {
                        continue
                    }
                    let cost = costInPoint.cost + 1
                    let path = costInPoint.path + [moved]
                    let savedCost = costs[moved, default: (Int.max, [])]
                    if cost < savedCost.cost {
                        pointsOfInterest.insert(moved)
                        costs[moved] = (cost, path)
                    }
                }
            }

            guard nil != costs[Point(x: memorySize.width - 1, y: memorySize.height - 1)] else {
                blockedIndex = index
                continue
            }

            passIndex = index
            iterations += 1
        }

        return "\(iterations) \(blockedIndex)/\(bytes.count) \(bytes[blockedIndex])"
    }

    private func printMap(_ map: [Point: Bool], size: Size) {
        for y in 0..<size.height {
            for x in 0..<size.width {
                let point = Point(x: x, y: y)
                print(map[point, default: false] ? "#" : ".", terminator: "")
            }
            print("")
        }
    }

    private func data(from input: String) -> [Point] {
        let lines = input.lines.filter(\.isNotEmpty)

        return lines.compactMap { line in
            let split = line.split(separator: ",").compactMap { Int($0) }

            if split.count != 2 {
                return nil
            }
            return Point(x: split[0], y: split[1])
        }
    }
}
