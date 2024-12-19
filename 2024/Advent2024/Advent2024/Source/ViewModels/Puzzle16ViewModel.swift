//
//  Puzzle16ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-16.
//

import SwiftUI

@Observable
final class Puzzle16ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String, isTest: Bool) async -> String {
        let (maze, start, end) = data(from: input)

        var nodes: [Point: Set<Direction>] = [:]
        var edges: [Point: [Direction: Point]] = [:]

        let verticalDirections: Set<Direction> = [.up, .down]
        let horizontalDirections: Set<Direction> = [.left, .right]

        for y in 1...start.y {
            for x in 1...end.x {
                let point = Point(x: x, y: y)
                let verticalConnections = verticalDirections.filter {
                    let connectedPoint = $0.move(from: point)
                    return !maze[connectedPoint, default: false]
                }

                let horizontalConnections = horizontalDirections.filter {
                    let connectedPoint = $0.move(from: point)
                    return !maze[connectedPoint, default: false]
                }
                if (verticalConnections.isNotEmpty && horizontalConnections.isNotEmpty) || point == start || point == end {
                    nodes[point] = verticalConnections.union(horizontalConnections)
                }
            }
        }

        for (node, directions) in nodes {
            let connectedNodes: [Direction: Point] = Dictionary(uniqueKeysWithValues: directions.compactMap { direction in
                var connectedNode = direction.move(from: node)
                while !maze[connectedNode, default: false] && nodes[connectedNode] == nil {
                    connectedNode = direction.move(from: connectedNode)
                }
                if nodes[connectedNode] != nil {
                    return (direction, connectedNode)
                }
                return nil
            })
            edges[node] = connectedNodes
        }

        let startingPosition = Move(point: start, direction: .right)
        var pointsOfInterest: Set<Move> = [startingPosition]
        var score: [Move: Int] = [startingPosition: 0]

        printMaze(maze, start: start, end: end, nodes: nodes)

        while pointsOfInterest.isNotEmpty {
            let pointOfInterest = pointsOfInterest.removeFirst()
            let possibleEdges = edges[pointOfInterest.point, default: [:]].filter { $0.key != pointOfInterest.direction.opposite }

            let scoreAt = score[pointOfInterest, default: 0]

            for (direction, destination) in possibleEdges {
                let move = Move(point: destination, direction: direction)
                let turningScore = direction == pointOfInterest.direction ? 0 : 1000
                let resultScore = scoreAt + pointOfInterest.point.distance(from: destination) + turningScore

                let savedScoreAt = score[move, default: Int.max]
                if resultScore < savedScoreAt {
                    score[move] = resultScore
                    pointsOfInterest.insert(move)
                }
            }
        }

        if let result = score.filter({ $0.key.point == end }).values.min() {
            return "\(result)"
        }

        return ""
    }

    private struct Move: Hashable, CustomStringConvertible {
        let point: Point
        let direction: Direction

        var description: String {
            "{\(point) \(direction)}"
        }
    }

    func solveTwo(input: String, isTest: Bool) async -> String {
        let (maze, start, end) = data(from: input)

        var nodes: [Point: Set<Direction>] = [:]
        var edges: [Point: [Direction: Point]] = [:]

        let verticalDirections: Set<Direction> = [.up, .down]
        let horizontalDirections: Set<Direction> = [.left, .right]

        for y in 1...start.y {
            for x in 1...end.x {
                let point = Point(x: x, y: y)
                let verticalConnections = verticalDirections.filter {
                    let connectedPoint = $0.move(from: point)
                    return !maze[connectedPoint, default: false]
                }

                let horizontalConnections = horizontalDirections.filter {
                    let connectedPoint = $0.move(from: point)
                    return !maze[connectedPoint, default: false]
                }
                if (verticalConnections.isNotEmpty && horizontalConnections.isNotEmpty) || point == start || point == end {
                    nodes[point] = verticalConnections.union(horizontalConnections)
                }
            }
        }

        for (node, directions) in nodes {
            let connectedNodes: [Direction: Point] = Dictionary(uniqueKeysWithValues: directions.compactMap { direction in
                var connectedNode = direction.move(from: node)
                while !maze[connectedNode, default: false] && nodes[connectedNode] == nil {
                    connectedNode = direction.move(from: connectedNode)
                }
                if nodes[connectedNode] != nil {
                    return (direction, connectedNode)
                }
                return nil
            })
            edges[node] = connectedNodes
        }

        let startingPosition = Move(point: start, direction: .right)
        var pointsOfInterest: Set<Move> = [startingPosition]
        var score: [Move: Int] = [startingPosition: 0]
        var paths: [Point: [Int: Set<Point>]] = [:]

        printMaze(maze, start: start, end: end, nodes: nodes)

        while pointsOfInterest.isNotEmpty {
            var newPointsOfInterest: Set<Move> = []
            for pointOfInterest in pointsOfInterest {
                let possibleEdges = edges[pointOfInterest.point, default: [:]].filter { $0.key != pointOfInterest.direction.opposite }

                let scoreAt = score[pointOfInterest, default: 0]

                for (direction, destination) in possibleEdges {
                    let move = Move(point: destination, direction: direction)
                    let turningScore = direction == pointOfInterest.direction ? 0 : 1000
                    let resultScore = scoreAt + pointOfInterest.point.distance(from: destination) + turningScore

                    let savedScoreAt = score[move, default: Int.max]
                    if resultScore <= savedScoreAt {
                        score[move] = resultScore
                        newPointsOfInterest.insert(move)
                    }

                    var previousPoints = paths[destination, default: [:]]
                    var list = previousPoints[resultScore, default: []]
                    list.insert(pointOfInterest.point)
                    previousPoints[resultScore] = list
                    paths[destination] = previousPoints
                }
            }
            pointsOfInterest = newPointsOfInterest
        }

        guard let targetScore = score.filter({ $0.key.point == end }).values.min() else {
            fatalError()
        }

        var resultPoints: Set<Point> = []

        for (p, s) in paths {
            print(p, s)
        }

        var tracePoints: Set<TracePoint> = [TracePoint(point: end, targetScore: targetScore, source: nil)]
        while tracePoints.isNotEmpty {
            let node = tracePoints.removeFirst()
            let paths = paths[node.point, default: [:]]
            for (s, points) in paths {
                let filteredPoints = points.filter { p in
                    var diff = 0
                    if let source = node.source {
                        diff += (source.x == p.x || source.y == p.y) ? 0 : 1000
                    }
                    return s <= (node.targetScore - diff)
                }

                tracePoints = tracePoints.union(filteredPoints.map {
                    let ts = s - $0.distance(from: node.point)
                    return TracePoint(point: $0, targetScore: ts, source: node.point)
                })
                filteredPoints.forEach { p in
                    for x in min(p.x, node.point.x)...(max(p.x, node.point.x)) {
                        for y in min(p.y, node.point.y)...(max(p.y, node.point.y)) {
                            resultPoints.insert(Point(x: x, y: y))
                        }
                    }
                }
            }
        }

        printMaze(maze, start: start, end: end, nodes: nodes, result: resultPoints)

        let result = resultPoints.count

        return "\(result)"
    }

    struct TracePoint: Hashable {
        let point: Point
        let targetScore: Int
        let source: Point?
    }

    private func printMaze(_ maze: [Point: Bool], start: Point, end: Point, nodes: [Point: Set<Direction>], result: Set<Point> = []) {
        for y in 0...(start.y + 1) {
            for x in 0...(end.x + 1) {
                let point = Point(x: x, y: y)

                if result.contains(point) {
                    print("O", terminator: "")
                } else if point == start {
                    print("S", terminator: "")
                } else if point == end {
                    print("E", terminator: "")
                } else if maze[point, default: false] {
                    print("#", terminator: "")
                } else
//                if nil != nodes[point] {
//                    print("N", terminator: "")
//                } else
                {
                    print(".", terminator: "")
                }
            }
            print()
        }
    }

    private func data(from input: String) -> (maze: [Point: Bool], start: Point, end: Point) {
        let lines = input.lines.filter(\.isNotEmpty)

        var start: Point = .zero
        var end: Point = .zero

        var maze: [Point: Bool] = [:]

        for (y, line) in lines.enumerated() {
            for (x, character) in line.enumerated() {
                let point = Point(x: x, y: y)
                
                switch character {
                case "#":
                    maze[point] = true
                case "S":
                    start = point
                case "E":
                    end = point
                default: break
                }
            }
        }

        return (maze, start, end)
    }
}

private extension Point {
    func distance(from point: Point) -> Int {
        return abs(x - point.x) + abs(y - point.y)
    }
}
