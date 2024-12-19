//
//  Puzzle06ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-06.
//

import SwiftUI

@Observable
final class Puzzle06ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String, isTest: Bool) async -> String {
        let (map, size, startingLocation, startingDirection) = data(from: input)

        let rect = Rect(origin: .zero, size: size)

        let visited = getVisited(map: map, rect: rect, startingLocation: startingLocation, startingDirection: startingDirection)

        let result = visited.count

        return "\(result)"
    }

    struct Move: Hashable {
        let position: Point
        let direction: Direction
    }

    private func getVisited(map: [Point: Bool], rect: Rect, startingLocation: Point, startingDirection: Direction) -> Set<Point> {
        var path: Set<Point> = []

        var position = startingLocation
        var direction = startingDirection

        repeat {
            path.insert(position)

            var newPosition = direction.move(from: position)

            while map[newPosition] == true {
                direction = direction.rotated90Right
                newPosition = direction.move(from: position)
            }

            position = newPosition

        } while rect.isPointInside(position)

        return path

    }

    func solveTwo(input: String, isTest: Bool) async -> String {
        let (map, size, startingLocation, startingDirection) = data(from: input)

        let rect = Rect(origin: .zero, size: size)

        let visited = getVisited(map: map, rect: rect, startingLocation: startingLocation, startingDirection: startingDirection)

        let possibleObstacles: Set<Point> = visited.filter { $0 != startingLocation }

        let result = await withTaskGroup(of: Bool.self) { group in
            for obstacle in possibleObstacles {
                group.addTask {
                    var mapWithObstacle = map

                    mapWithObstacle[obstacle] = true

                    var visited: Set<Move> = []

                    var position = startingLocation
                    var direction = startingDirection

                    repeat {
                        visited.insert(Move(position: position, direction: direction))

                        var newPosition = direction.move(from: position)

                        while mapWithObstacle[newPosition] == true {
                            direction = direction.rotated90Right
                            newPosition = direction.move(from: position)
                        }

                        position = newPosition

                        if visited.contains(Move(position: position, direction: direction)) {
                            return true
                        }
                    } while rect.isPointInside(position)

                    return false
                }
            }

            return await group.reduce([], { $0 + [$1] }).filter { $0 }.count
        }

        return "\(result)"
    }

    func printMap(map: [Point: Bool], visited: Set<Point>, size: Size, position: Point, direction: Direction, obstacles: Set<Point> = []) {
        for y in 0..<size.height {
            for x in 0..<size.width {
                let point = Point(x: x, y: y)
                if map[point] == true {
                    print("#", terminator: "")
                } else if obstacles.contains(point) {
                    print("O", terminator: "")
                } else if visited.contains(point) {
                    print("X", terminator: "")
                } else if point == position {
                    switch direction {
                        case .up:
                        print("^", terminator: "")
                    case .right:
                        print(">", terminator: "")
                    case .down:
                        print("v", terminator: "")
                    case .left:
                        print("<", terminator: "")
                    default: break
                    }
                } else {
                    print(".", terminator: "")
                }
            }
            print("")
        }
    }

    func data(from input: String) -> (map: [Point: Bool], size: Size, startingLocation: Point, startingDirection: Direction) {
        let lines = input.lines.filter(\.isNotEmpty)

        var map: [Point: Bool] = [:]
        var startingLocation: Point = .zero
        let direction: Direction = .up
        var size: Size = .zero

        for (y, line) in lines.enumerated() {
            for (x, character) in line.enumerated() {
                switch character {
                case "#": map[Point(x: x, y: y)] = true
                case "^": startingLocation = Point(x: x, y: y)
                default: break
                }
            }
            size.width = max(size.width, line.count)
        }
        size.height = lines.count
        return (map, size, startingLocation, direction)
    }
}
