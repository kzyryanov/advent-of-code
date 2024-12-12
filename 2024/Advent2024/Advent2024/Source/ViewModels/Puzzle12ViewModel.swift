//
//  Puzzle12ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-12.
//

import SwiftUI

@Observable
final class Puzzle12ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    private struct Region: Hashable {
        let name: Character
        let area: Set<Point>
        let perimeter: [Point: Int]
        let sides: Int
    }

    private func regions(from plants: [[Character]]) -> Set<Region> {
        let regions: [Point: Character] = Dictionary(
            uniqueKeysWithValues: plants.enumerated().flatMap { y, row in
                row.enumerated().map { x, character in
                    return (Point(x: x, y: y), character)
                }
            }
        )

        var visited: Set<Point> = []

        var calculatedRegions: Set<Region> = []

        for y in plants.indices {
            for x in plants[y].indices {
                let point = Point(x: x, y: y)
                if visited.contains(point) {
                    continue
                }

                let character = regions[point]

                var region: Set<Point> = [point]

                var pointsToVisit: Set<Point> = [point]

                var perimeter: [Point: Int] = [:]

                var verticals: [Point] = []
                var horizontals: [Point] = []

                while pointsToVisit.isNotEmpty {
                    let point = pointsToVisit.removeFirst()
                    for direction in Direction.noDiagonals {
                        let neighbor = direction.move(from: point)
                        if !region.contains(neighbor) {
                            if regions[neighbor] == character {
                                region.insert(neighbor)
                                pointsToVisit.insert(neighbor)
                            } else {
                                perimeter[neighbor] = perimeter[neighbor, default: 0] + 1
                                if direction == .left || direction == .right {
                                    verticals.append(neighbor)
                                } else if direction == .up || direction == .down {
                                    horizontals.append(neighbor)
                                }
                            }
                        }
                    }
                }

                var groupedVerticals = Dictionary(grouping: verticals, by: { $0.x })
                var groupedHorizontals = Dictionary(grouping: horizontals, by: { $0.y })

                var sides: Int = 0

                for (x, verticals) in groupedVerticals {
                    var ys = verticals.map(\.y).sorted(by: >)

                    var increment: Int = 1
                    while ys.isNotEmpty {
                        let y = ys.removeLast()
                        if ys.last == y { // overlap
                            ys.removeLast()
                            increment = 2
                        }
                        if ys.last != y + 1 {
                            sides += increment
                            increment = 1
                        } else {
                            let p1Left = Point(x: x - 1, y: y)
                            let p2Left = Point(x: x - 1, y: y + 1)

                            let p1Right = Point(x: x + 1, y: y)
                            let p2Right = Point(x: x + 1, y: y + 1)

                            if region.contains(p1Left), region.contains(p2Left) {
                                continue
                            }

                            if region.contains(p1Right), region.contains(p2Right) {
                                continue
                            }

                            sides += increment
                            increment = 1
                        }
                    }
                }

                for (y, horizontals) in groupedHorizontals {
                    var xs = horizontals.map(\.x).sorted(by: >)

                    var increment: Int = 1
                    while xs.isNotEmpty {
                        let x = xs.removeLast()
                        if xs.last == x { // overlap
                            xs.removeLast()
                            increment = 2
                        }
                        if xs.last != x + 1 {
                            sides += increment
                            increment = 1
                        } else {
                            let p1Up = Point(x: x, y: y - 1)
                            let p2Up = Point(x: x + 1, y: y - 1)

                            let p1Down = Point(x: x, y: y + 1)
                            let p2Down = Point(x: x + 1, y: y + 1)

                            if region.contains(p1Up), region.contains(p2Up) {
                                continue
                            }

                            if region.contains(p1Down), region.contains(p2Down) {
                                continue
                            }

                            sides += increment
                            increment = 1
                        }
                    }
                }

                calculatedRegions.insert(Region(
                    name: character!,
                    area: region,
                    perimeter: perimeter,
                    sides: sides
                ))
                visited = visited.union(region)
            }
        }
        return calculatedRegions
    }

    func solveOne(input: String) async -> String {
        let plants = data(from: input)

        let regions = regions(from: plants)

        let result = regions.reduce(0, { $0 + $1.area.count * $1.perimeter.values.reduce(0, +) })

        return "\(result)"
    }

    func solveTwo(input: String) async -> String {
        let plants = data(from: input)

        let regions = regions(from: plants)

        let result: Int = regions.map { $0.area.count * $0.sides }.reduce(0, +)

        return "\(result)"
    }

    func data(from input: String) -> [[Character]] {
        let lines = input.lines.filter(\.isNotEmpty)

        return lines.map { $0.map { $0 } }
    }
}
