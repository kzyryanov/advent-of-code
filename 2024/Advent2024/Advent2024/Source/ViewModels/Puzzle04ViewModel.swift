//
//  Puzzle04ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-04.
//

import SwiftUI

@Observable
final class Puzzle04ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String) async -> String {
        let (map, _) = data(from: input)

        let xPoints = map.filter { point, character in
            return character == "X"
        }.keys

        var mPoints: [(location: Point, direction: Direction)] = []

        for xPoint in xPoints {
            for direction in Direction.allCases {
                let point = direction.move(from: xPoint)
                if map[point] == "M" {
                    mPoints.append((point, direction))
                }
            }
        }

        var aPoints: [(location: Point, direction: Direction)] = []

        for mPoint in mPoints {
            let point = mPoint.direction.move(from: mPoint.location)
            if map[point] == "A" {
                aPoints.append((point, mPoint.direction))
            }
        }

        var sPoints: [(location: Point, direction: Direction)] = []

        for aPoint in aPoints {
            let point = aPoint.direction.move(from: aPoint.location)
            if map[point] == "S" {
                sPoints.append((point, aPoint.direction))
            }
        }

        let result = sPoints.count

        return "\(result)"
    }

    func solveTwo(input: String) async -> String {
        let (map, _) = data(from: input)

        let aPoints = map.filter { point, character in
            return character == "A"
        }.keys

        let xVariations: [((m: Direction, s: Direction), (m: Direction, s: Direction))] = [
            ((.upLeft, .downRight), (.downLeft, .upRight)),
            ((.upLeft, .downRight), (.upRight, .downLeft)),
            ((.downRight, .upLeft), (.downLeft, .upRight)),
            ((.downRight, .upLeft), (.upRight, .downLeft)),
        ]

        var result: Int = 0

        for aPoint in aPoints {
            for variation in xVariations {
                let mPoint1 = variation.0.m.move(from: aPoint)
                let mPoint2 = variation.1.m.move(from: aPoint)
                let sPoint1 = variation.0.s.move(from: aPoint)
                let sPoint2 = variation.1.s.move(from: aPoint)

                if map[mPoint1] == "M" && map[mPoint2] == "M" && map[sPoint1] == "S" && map[sPoint2] == "S" {
                    result += 1
                }
            }
        }

        return "\(result)"
    }

    func data(from input: String) -> (map: [Point: Character], rect: Rect) {
        let lines = input.lines.filter(\.isNotEmpty)

        let rect = Rect(
            origin: Point(x: 0, y: 0),
            size: Size(width: lines.first?.count ?? 0, height: lines.count)
        )

        return (
            Dictionary(uniqueKeysWithValues: lines.enumerated().flatMap { y, line in
                line.enumerated().map { x, character in
                    (Point(x: x, y: y), character)
                }
            }),
            rect
        )
    }
}
