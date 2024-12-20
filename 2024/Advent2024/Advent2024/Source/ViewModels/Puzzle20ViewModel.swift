//
//  Puzzle20ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-20.
//

import SwiftUI

@Observable
final class Puzzle20ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String, isTest: Bool) async -> String {
        let (map, size, start, end) = data(from: input)

        printMap(map, size: size, start: start, end: end)

        var cost: [Point: Int] = [start: 0]

        var pointsToVisit: Set<Point> = [start]
        var visited: Set<Point> = []

        while pointsToVisit.isNotEmpty {
            let point = pointsToVisit.removeFirst()
            guard let costInPoint = cost[point] else {
                fatalError("Cannot be nil")
            }

            for direction in Direction.noDiagonals {
                let nextPoint = direction.move(from: point)
                if map[nextPoint, default: false] || visited.contains(nextPoint) {
                    continue
                }
                visited.insert(nextPoint)

                let savedCost = cost[nextPoint, default: Int.max]
                let newCost = costInPoint + 1
                if newCost < savedCost {
                    cost[nextPoint] = newCost
                    pointsToVisit.insert(nextPoint)
                }
            }
        }

        var cheats: [Point: Int] = [:]

        for point in map.keys {
            // Check horizontal
            let left = Direction.left.move(from: point)
            let right = Direction.right.move(from: point)
            if let costInLeft = cost[left], let costInRight = cost[right] {
                let diff = abs(costInRight - costInLeft) - 2
                cheats[point] = diff
            }

            // Check vertical
            let up = Direction.up.move(from: point)
            let down = Direction.down.move(from: point)
            if let costInUp = cost[up], let costInDown = cost[down] {
                let diff = abs(costInDown - costInUp) - 2
                cheats[point] = diff
            }

        }

        let result = cheats.filter { $0.value >= (isTest ? 1 : 100) }

        return "\(result.count)"
    }

    func solveTwo(input: String, isTest: Bool) async -> String {
        let result = solve(input: input, cheatPower: isTest ? 50 : 100, distanceRange: 2...20)

        return "\(result)"
    }

    private func solve(input: String, cheatPower: Int, distanceRange: ClosedRange<Int>) -> Int {
        let (map, size, start, end) = data(from: input)

        printMap(map, size: size, start: start, end: end)

        var costs: [Point: Int] = [start: 0]

        var pointsToVisit: Set<Point> = [start]
        var visited: Set<Point> = []

        while pointsToVisit.isNotEmpty {
            let point = pointsToVisit.removeFirst()
            guard let costInPoint = costs[point] else {
                fatalError("Cannot be nil")
            }

            for direction in Direction.noDiagonals {
                let nextPoint = direction.move(from: point)
                if map[nextPoint, default: false] || visited.contains(nextPoint) {
                    continue
                }
                visited.insert(nextPoint)

                let savedCost = costs[nextPoint, default: Int.max]
                let newCost = costInPoint + 1
                if newCost < savedCost {
                    costs[nextPoint] = newCost
                    pointsToVisit.insert(nextPoint)
                }
            }
        }

        var cheats: [Cheat: Int] = [:]

        for (point, cost) in costs {
            let moreCosts = costs.filter { (fPoint, fCost) in
                let distance = fPoint.distance(from: point)
                let costDiff = fCost - cost
                let withinDistance = distanceRange.contains(distance)
                return withinDistance && distance < costDiff
            }

            moreCosts.forEach { (cPoint, cCost) in
                let distance = cPoint.distance(from: point)
                cheats[Cheat(start: point, end: cPoint)] = (cCost - cost) - distance
            }
        }

        let result = cheats.filter { $0.value >= cheatPower }

        return result.count
    }

    private struct Cheat: Hashable {
        let start: Point
        let end: Point
    }

    private func printMap(_ map: [Point: Bool], size: Size, start: Point, end: Point) {
        for y in 0..<size.height {
            for x in 0..<size.width {
                let point = Point(x: x, y: y)
                if point == start {
                    print("S", terminator: "")
                } else if point == end {
                    print("E", terminator: "")
                } else if map[point, default: false] {
                    print("#", terminator: "")
                } else {
                    print(".", terminator: "")
                }
            }
            print()
        }

    }

    private func data(from input: String) -> (map: [Point: Bool], size: Size, start: Point, end: Point) {
        let lines = input.lines.filter(\.isNotEmpty)

        var start: Point = .zero
        var end: Point = .zero
        var map: [Point: Bool] = [:]
        let size = Size(width: lines.first?.count ?? 0, height: lines.count)

        for (y, line) in lines.enumerated() {
            for (x, character) in line.enumerated() {
                let point = Point(x: x, y: y)
                switch character {
                case "S":
                    start = point
                case "E":
                    end = point
                case "#":
                    map[point] = true
                default:
                    break
                }
            }
        }

        return (map, size, start, end)
    }
}
