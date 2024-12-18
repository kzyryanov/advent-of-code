//
//  Puzzle15ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-15.
//

import SwiftUI

@Observable
final class Puzzle15ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String) async -> String {
        let (map, size, startingLocation, instructions) = dataOne(from: input)

        var newMap = map

        func move(point: Point, in direction: Direction) -> Bool {
            let newPoint = direction.move(from: point)

            switch newMap[newPoint] {
            case .some(.wall):
                return false
            case .some(.box):
                if move(point: newPoint, in: direction) {
                    let pushedPoint = direction.move(from: newPoint)
                    newMap[newPoint] = nil
                    newMap[pushedPoint] = .box
                    return true
                }
                newMap[newPoint] = .box
                return false
            default:
                break
            }
            return true
        }

        var robotLocation = startingLocation

        print("Initial state")
        printMap(newMap, size: size, robotLocation: robotLocation)

        for instruction in instructions {
            if move(point: robotLocation, in: instruction) {
                robotLocation = instruction.move(from: robotLocation)
            }
        }

        print()
        print("After")
        printMap(newMap, size: size, robotLocation: robotLocation)

        let result = newMap
            .filter { $0.value == .box }
            .keys
            .reduce(0, { $0 + (100 * $1.y + $1.x) })

        return "\(result)"
    }

    private func printMap(_ map: [Point: Object], size: Size, robotLocation: Point) {
        for y in 0..<size.height {
            for x in 0..<size.width {
                let point = Point(x: x, y: y)
                if point == robotLocation {
                    print("@", terminator: "")
                } else {
                    switch map[point] {
                    case .some(.wall):
                        print("#", terminator: "")
                    case .some(.box):
                        print("O", terminator: "")
                    case .some(.boxLeft):
                        print("[", terminator: "")
                    case .some(.boxRight):
                        print("]", terminator: "")
                    case .none:
                        print(".", terminator: "")
                    }
                }
            }
            print()
        }
        
    }

    func solveTwo(input: String) async -> String {
        let (map, size, startingLocation, instructions) = dataTwo(from: input)

        var newMap = map
        var robotLocation = startingLocation

        print("Initial state")
        printMap(newMap, size: size, robotLocation: robotLocation)

        func boxesToMove(from point: Point, in direction: Direction) -> Set<Point>? {
            let newPoint = direction.move(from: point)

            switch newMap[newPoint] {
            case .some(.wall):
                return nil
            case .some(.boxLeft):
                let boxRightPoint = Point(x: newPoint.x + 1, y: newPoint.y)
                switch direction {
                case .right:
                    guard let extraBoxes = boxesToMove(from: boxRightPoint, in: direction) else {
                        return nil
                    }
                    return extraBoxes.union([newPoint, boxRightPoint])
                case .up, .down:
                    guard let extraBoxesLeft = boxesToMove(from: newPoint, in: direction),
                          let extraBoxesRight = boxesToMove(from: boxRightPoint, in: direction) else {
                        return nil
                    }
                    return extraBoxesLeft.union(extraBoxesRight).union([newPoint, boxRightPoint])
                default:
                    assertionFailure()
                    return nil
                }
            case .some(.boxRight):
                let boxLeftPoint = Point(x: newPoint.x - 1, y: newPoint.y)
                switch direction {
                case .left:
                    guard let extraBoxes = boxesToMove(from: boxLeftPoint, in: direction) else {
                        return nil
                    }
                    return extraBoxes.union([newPoint, boxLeftPoint])
                case .down, .up:
                    guard let extraBoxesLeft = boxesToMove(from: boxLeftPoint, in: direction),
                          let extraBoxesRight = boxesToMove(from: newPoint, in: direction) else {
                        return nil
                    }
                    return extraBoxesLeft.union(extraBoxesRight).union([newPoint, boxLeftPoint])
                default:
                    assertionFailure()
                    return nil
                }
            default: break
            }

            return []
        }

        for instruction in instructions {
            guard let boxesToMove = boxesToMove(from: robotLocation, in: instruction) else {
                continue
            }
            robotLocation = instruction.move(from: robotLocation)

            let oldMap = newMap
            var replaced: Set<Point> = []

            for boxToMove in boxesToMove {
                let newPoint = instruction.move(from: boxToMove)
                let box = oldMap[boxToMove]
                if !replaced.contains(boxToMove) {
                    newMap[boxToMove] = nil
                }
                newMap[newPoint] = box
                replaced.insert(newPoint)
            }
        }

        print()
        print("After")
        printMap(newMap, size: size, robotLocation: robotLocation)

        let result = newMap
            .filter { $0.value == .boxLeft }
            .keys
            .reduce(0, { $0 + (100 * $1.y + $1.x) })


        return "\(result)"
    }

    private enum Object {
        case wall
        case box
        case boxLeft
        case boxRight
    }

    private func dataOne(from input: String) -> (map: [Point: Object], size: Size, robotLocation: Point, instuctions: [Direction]) {
        let lines = input.lines

        var map: [Point: Object] = [:]

        var robotLocation: Point = .zero

        var width = 0
        var height = 0
        for (y, line) in lines.enumerated() {
            if line.isEmpty {
                height = y
                break
            }

            for (x, character) in line.enumerated() {
                width = max(width, x + 1)
                switch character {
                case "#":
                    map[Point(x: x, y: y)] = .wall
                case "O":
                    map[Point(x: x, y: y)] = .box
                case "@":
                    robotLocation = Point(x: x, y: y)
                default:
                    break
                }
            }
        }

        var instructions: [Direction] = []

        for i in height..<lines.count {
            instructions += lines[i].compactMap { character in
                switch character {
                case "^":
                    return .up
                case "v":
                    return .down
                case "<":
                    return .left
                case">":
                    return .right
                default:
                    return nil
                }
            }
        }

        return (map, Size(width: width, height: height), robotLocation, instructions)
    }

    private func dataTwo(from input: String) -> (map: [Point: Object], size: Size, robotLocation: Point, instuctions: [Direction]) {
        let lines = input.lines

        var map: [Point: Object] = [:]

        var robotLocation: Point = .zero

        var width = 0
        var height = 0
        for (y, line) in lines.enumerated() {
            if line.isEmpty {
                height = y
                break
            }

            for (x, character) in line.enumerated() {
                width = max(width, (x + 1) * 2)
                switch character {
                case "#":
                    map[Point(x: x * 2, y: y)] = .wall
                    map[Point(x: x * 2 + 1, y: y)] = .wall
                case "O":
                    map[Point(x: x * 2, y: y)] = .boxLeft
                    map[Point(x: x * 2 + 1, y: y)] = .boxRight
                case "@":
                    robotLocation = Point(x: x * 2, y: y)
                default:
                    break
                }
            }
        }

        var instructions: [Direction] = []

        for i in height..<lines.count {
            instructions += lines[i].compactMap { character in
                switch character {
                case "^":
                    return .up
                case "v":
                    return .down
                case "<":
                    return .left
                case">":
                    return .right
                default:
                    return nil
                }
            }
        }

        return (map, Size(width: width, height: height), robotLocation, instructions)
    }
}
