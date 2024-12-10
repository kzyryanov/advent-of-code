//
//  Puzzle10ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-10.
//

import SwiftUI

@Observable
final class Puzzle10ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String) async -> String {
        let map = data(from: input)
        let rect = Rect(origin: .zero, size: Size(width: map.first!.count, height: map.count))

        var zeros: Set<Point> = []

        for y in 0..<map.count {
            for x in 0..<map[y].count {
                if map[y][x] == 0 {
                    zeros.insert(Point(x: x, y: y))
                }
            }
        }

        var paths: [Point: [Int: Set<Point>]] = [:]

        for zero in zeros {
            paths[zero] = [0: [zero]]

            for step in 0...8 {
                if paths[zero, default: [:]][step, default: []].isEmpty {
                    break
                }
                for direction in Direction.noDiagonals {
                    for point in paths[zero, default: [:]][step, default: []] {
                        let nextPoint = direction.move(from: point)
                        if rect.isPointInside(nextPoint) && map[nextPoint.y][nextPoint.x] == step + 1 {
                            var nextPoints = paths[zero, default: [:]][step + 1, default: []]
                            nextPoints.insert(nextPoint)
                            paths[zero]?[step + 1] = nextPoints
                        }
                    }
                }
            }
        }

        let result = paths.values.map {
            $0[9, default: []].count
        }.reduce(0, +)

        return "\(result)"
    }

    func solveTwo(input: String) async -> String {
        let map = data(from: input)
        let rect = Rect(origin: .zero, size: Size(width: map.first!.count, height: map.count))

        var zeros: Set<Point> = []

        for y in 0..<map.count {
            for x in 0..<map[y].count {
                if map[y][x] == 0 {
                    zeros.insert(Point(x: x, y: y))
                }
            }
        }

        var paths: [Point: [Int: [Point]]] = [:]

        for zero in zeros {
            paths[zero] = [0: [zero]]

            for step in 0...8 {
                if paths[zero, default: [:]][step, default: []].isEmpty {
                    break
                }
                for direction in Direction.noDiagonals {
                    for point in paths[zero, default: [:]][step, default: []] {
                        let nextPoint = direction.move(from: point)
                        if rect.isPointInside(nextPoint) && map[nextPoint.y][nextPoint.x] == step + 1 {
                            var nextPoints = paths[zero, default: [:]][step + 1, default: []]
                            nextPoints.append(nextPoint)
                            paths[zero]?[step + 1] = nextPoints
                        }
                    }
                }
            }
        }

        let result = paths.values.map {
            $0[9, default: []].count
        }.reduce(0, +)

        return "\(result)"
    }

    func data(from input: String) -> [[Int?]] {
        let lines = input.lines.filter(\.isNotEmpty)

        return lines.map { $0.map { $0.wholeNumberValue } }
    }
}
