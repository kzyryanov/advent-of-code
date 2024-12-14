//
//  Puzzle14ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-14.
//

import SwiftUI

@Observable
final class Puzzle14ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String) async -> String {
        let robots = data(from: input)

        let fieldSize = Size(width: 101, height: 103)

        let seconds = 100

        let movedRobots = robots.map { robot in

            let endLocation = Point(
                x: (robot.location.x + (seconds * robot.speed.x) + seconds * fieldSize.width) % fieldSize.width,
                y: (robot.location.y + (seconds * robot.speed.y) + seconds * fieldSize.height) % fieldSize.height
            )
            return Robot(location: endLocation, speed: robot.speed)
        }

        let halfSize = Size(width: fieldSize.width / 2, height: fieldSize.height / 2)

        let topLeft =  Rect(origin: .zero, size: halfSize)
        let topRight = Rect(origin: Point(x: halfSize.width + 1, y: 0), size: halfSize)
        let bottomLeft =  Rect(origin: Point(x: 0, y: halfSize.height + 1), size: halfSize)
        let bottomRight = Rect(origin: Point(x: halfSize.width + 1, y: halfSize.height + 1), size: halfSize)

        let quadrants = Dictionary(grouping: movedRobots.filter({ $0.location.x != halfSize.width && $0.location.y != halfSize.height })) { robot -> Quadrant in
            if topLeft.isPointInside(robot.location) {
                return .topLeft
            }
            if topRight.isPointInside(robot.location) {
                return .topRight
            }
            if bottomLeft.isPointInside(robot.location) {
                return .bottomLeft
            }
            if bottomRight.isPointInside(robot.location) {
                return .bottomRight
            }
            assertionFailure()
            return .topLeft
        }

        let safetyFactor = quadrants.values.map(\.count).reduce(1, *)

        return "\(safetyFactor)"
    }

    func solveTwo(input: String) async -> String {
        let robots = data(from: input)

        let fieldSize = Size(width: 101, height: 103)

        let seconds = 7687

        let movedRobots = robots.map { robot in

            let endLocation = Point(
                x: (robot.location.x + (seconds * robot.speed.x) + seconds * fieldSize.width) % fieldSize.width,
                y: (robot.location.y + (seconds * robot.speed.y) + seconds * fieldSize.height) % fieldSize.height
            )
            return Robot(location: endLocation, speed: robot.speed)
        }

        let grouped = Dictionary(grouping: movedRobots, by: \.location)

        for y in 0..<fieldSize.height {
            for x in 0..<fieldSize.width {
                let count = grouped[Point(x: x, y: y), default: []].count

                if count > 0 {
                    print(count, terminator: "")
                } else {
                    print(".", terminator: "")
                }
            }
            print("")
        }

        print("=====")

        return ""
    }

    private enum Quadrant: CaseIterable {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }

    private struct Robot: Hashable {
        let location: Point
        let speed: Point
    }

    private func data(from input: String) -> [Robot] {
        let lines = input.lines.filter(\.isNotEmpty)

        let regex = /p=(?<x>\d+),(?<y>\d+) v=(?<vx>-?\d+),(?<vy>-?\d+)/

        return lines.map { line in
            let match = try? regex.firstMatch(in: line)

            guard let sx = match?.output.x,
                  let sy = match?.output.y,
                  let svx = match?.output.vx,
                  let svy = match?.output.vy,
                  let x = Int(sx),
                  let y = Int(sy),
                  let vx = Int(svx),
                  let vy = Int(svy) else {
                fatalError("Invalid input")
            }

            return Robot(location: Point(x: x, y: y), speed: Point(x: vx, y: vy))
        }
    }
}
