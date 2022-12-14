//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle14() {
    print("Test")
    print("One")
    one(input: testInput14)
    print("Two")
    two(input: testInput14)

    print("")
    print("Real")
    print("One")
    one(input: input14)
    print("Two")
    two(input: input14)
}

private func buildCave(input: String, startSandCoordinate: Coordinate) -> (CaveMap, xRange: ClosedRange<Int>, yRange: ClosedRange<Int>) {
    let rocks = input.components(separatedBy: "\n").map { path in
        path.components(separatedBy: " -> ").map { coordinates in
            let components = coordinates.components(separatedBy: ",").map { Int($0)! }
            return Coordinate(x: components[0], y: components[1])
        }
    }

    let xCoordinates = rocks.flatMap { rock in
        rock.map(\.x)
    }

    let yCoordinates = rocks.flatMap { rock in
        rock.map(\.y)
    }

    let minX = xCoordinates.min()!
    let maxX = xCoordinates.max()!
    let minY = 0
    let maxY = yCoordinates.max()!

    var caveMap: CaveMap = [startSandCoordinate: .sandSource]

    rocks.forEach { path in
        var coordinate = path.first!
        for index in 1..<path.count {
            let nextCoordinate = path[index]
            if coordinate.x == nextCoordinate.x {
                (min(coordinate.y, nextCoordinate.y)...max(coordinate.y, nextCoordinate.y))
                    .forEach { y in
                        caveMap[Coordinate(x: coordinate.x, y: y)] = .rock
                    }
            } else if coordinate.y == nextCoordinate.y {
                (min(coordinate.x, nextCoordinate.x)...max(coordinate.x, nextCoordinate.x))
                    .forEach { x in
                        caveMap[Coordinate(x: x, y: coordinate.y)] = .rock
                    }
            }
            coordinate = nextCoordinate
        }
    }

    return (caveMap, xRange: minX...maxX, yRange: minY...maxY)
}

private func one(input: String) {
    let startSandCoordinate = Coordinate(x: 500, y: 0)
    let (caveMap, xRange, yRange) = buildCave(input: input, startSandCoordinate: startSandCoordinate)

    printCave(caveMap, xRange: xRange, yRange: yRange)

    var caveMapWithSand = caveMap
    var noVoidFall = true

    while noVoidFall {
        var sandCoordinate = startSandCoordinate
        while true {
            if sandCoordinate.isVoidIn(xRange: xRange, yRange: yRange) {
                noVoidFall = false
                break
            }
            let nextDown = sandCoordinate.nextDown
            if caveMapWithSand[nextDown, default: .air].isAir {
                sandCoordinate = nextDown
                continue // continue falling
            }

            let nextLeft = sandCoordinate.nextLeft
            if caveMapWithSand[nextLeft, default: .air].isAir {
                sandCoordinate = nextLeft
                continue // continue falling
            }

            let nextRight = sandCoordinate.nextRight
            if caveMapWithSand[nextRight, default: .air].isAir {
                sandCoordinate = nextRight
                continue // continue falling
            }
            // No possible ways to fall
            caveMapWithSand[sandCoordinate] = .sand
            break
        }
    }

    printCave(caveMapWithSand, xRange: xRange, yRange: yRange)

    let result = caveMapWithSand.values.filter(\.isSand).count

    print("Result: \(result)")
}

private func two(input: String) {
    let startSandCoordinate = Coordinate(x: 500, y: 0)
    let (caveMap, xRange, yRange) = buildCave(input: input, startSandCoordinate: startSandCoordinate)

    printCave(caveMap, xRange: xRange, yRange: yRange, extendedYRange: true)

    var caveMapWithSand = caveMap
    var extendedXRange = xRange

    var reachedStart = false

    while !reachedStart {
        var sandCoordinate = startSandCoordinate
        while true {
            let nextDown = sandCoordinate.nextDown
            if caveMapWithSand[nextDown, default: .air].isAir && nextDown.y < yRange.upperBound+2 {
                sandCoordinate = nextDown
                continue // continue falling
            }

            let nextLeft = sandCoordinate.nextLeft
            if caveMapWithSand[nextLeft, default: .air].isAir && nextLeft.y < yRange.upperBound+2 {
                extendedXRange = min(extendedXRange.lowerBound, nextLeft.x)...extendedXRange.upperBound
                sandCoordinate = nextLeft
                continue // continue falling
            }

            let nextRight = sandCoordinate.nextRight
            if caveMapWithSand[nextRight, default: .air].isAir && nextRight.y < yRange.upperBound+2 {
                extendedXRange = extendedXRange.lowerBound...max(extendedXRange.upperBound, nextRight.x)
                sandCoordinate = nextRight
                continue // continue falling
            }
            // No possible ways to fall
            caveMapWithSand[sandCoordinate] = .sand
            reachedStart = sandCoordinate == startSandCoordinate
            break
        }
    }

    printCave(caveMapWithSand, xRange: extendedXRange, yRange: yRange, extendedYRange: true)

    let result = caveMapWithSand.values.filter(\.isSand).count

    print("Result: \(result)")
}

private func printCave(_ caveMap: CaveMap, xRange: ClosedRange<Int>, yRange: ClosedRange<Int>, extendedYRange: Bool = false) {
    for y in yRange {
        for x in xRange {
            print(caveMap[Coordinate(x: x, y: y), default: .air].symbol, terminator: "")
        }
        print("")
    }
    if extendedYRange {
        for x in xRange {
            print(caveMap[Coordinate(x: x, y: yRange.upperBound + 1), default: .air].symbol, terminator: "")
        }
        print("")
        for x in xRange {
            print(caveMap[Coordinate(x: x, y: yRange.upperBound + 2), default: .rock].symbol, terminator: "")
        }
        print("")
    }

}

private typealias CaveMap = [Coordinate: Value]

private enum Value: Equatable {
    case rock
    case air
    case sand
    case sandSource

    var symbol: Character {
        switch self {
        case .rock: return "#"
        case .air: return "."
        case .sand: return "o"
        case .sandSource: return "+"
        }
    }

    var isAir: Bool {
        self == .air
    }

    var isSand: Bool {
        self == .sand
    }
}

private struct Coordinate: Hashable {
    let x, y: Int

    func isVoidIn(xRange: ClosedRange<Int>, yRange: ClosedRange<Int>) -> Bool {
        !xRange.contains(x) || !yRange.contains(y)
    }

    var nextDown: Coordinate {
        Coordinate(x: x, y: y + 1)
    }

    var nextLeft: Coordinate {
        Coordinate(x: x - 1, y: y + 1)
    }

    var nextRight: Coordinate {
        Coordinate(x: x + 1, y: y + 1)
    }
}
