//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle23() {
    print("Test")
    print("One")
//    one(input: miniInput23)
    one(input: testInput23)
    print("Two")
    two(input: testInput23)

    print("")
    print("Real")
    print("One")
    one(input: input23)
    print("Two")
    two(input: input23)
}

private struct Coordinate: Hashable {
    let x, y: Int

    static func +(_ lhs: Coordinate, _ rhs: Coordinate) -> Coordinate {
        Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

private enum Direction: Hashable, CaseIterable {
    case n, s, w, e
    case nw, ne
    case sw, se

    static var northDirections: [Self] { [.n, .nw, .ne] }
    static var southDirections: [Self] { [.s, .sw, .se] }
    static var westDirections: [Self] { [.w, .sw, .nw] }
    static var eastDirections: [Self] { [.e, .se, .ne] }

    static var checkOrder: [[Self]] {
        [ northDirections, southDirections, westDirections, eastDirections ]
    }

    var coordinateOffset: Coordinate {
        switch self {
        case .n: return Coordinate(x: 0, y: -1)
        case .s: return Coordinate(x: 0, y: 1)
        case .w: return Coordinate(x: -1, y: 0)
        case .e: return Coordinate(x: 1, y: 0)
        case .nw: return Coordinate(x: -1, y: -1)
        case .ne: return Coordinate(x: 1, y: -1)
        case .sw: return Coordinate(x: -1, y: 1)
        case .se: return Coordinate(x: 1, y: 1)
        }
    }
}

private func parseElves(input: String) -> [Coordinate: Bool] {
    Dictionary(
        uniqueKeysWithValues: input.components(separatedBy: "\n").enumerated().flatMap { row, line in
            line.enumerated().compactMap { column, character in
                if character == "#" {
                    return (Coordinate(x: column, y: row), true)
                }
                return nil
            }
        }
    )
}

private func printMap(_ map: [Coordinate: Bool]) {
    let xValues = map.keys.map(\.x)
    let yValues = map.keys.map(\.y)
    let minX = xValues.min()!
    let maxX = xValues.max()!
    let minY = yValues.min()!
    let maxY = yValues.max()!

    for y in minY...maxY {
        for x in minX...maxX {
            if map[Coordinate(x: x, y: y), default: false] {
                print("#", terminator: "")
            } else {
                print(".", terminator: "")
            }
        }
        print("")
    }
}

private func performRound(round: Int, _ elvesMap: [Coordinate: Bool]) -> (map: [Coordinate: Bool], hasMoved: Bool) {
    var elvesMap = elvesMap

    let elvesLocations = elvesMap.filter { $0.value }.keys

    var proposals: [Coordinate: [Coordinate]] = [:]

    let firstProposalIndex = round % Direction.checkOrder.count

    // Make proposals
    for elfLocation in elvesLocations {
        var noElves = true
        for direction in Direction.allCases {
            let checkLocation = elfLocation + direction.coordinateOffset
            if elvesMap[checkLocation, default: false] {
                noElves = false
                break
            }
        }

        if noElves {
            continue
        }

        for offset in 0..<Direction.checkOrder.count {
            let checkIndex = (firstProposalIndex + offset) % Direction.checkOrder.count
            let check = Direction.checkOrder[checkIndex]
            var hasElf = false
            for direction in check {
                let checkLocation = elfLocation + direction.coordinateOffset
                if elvesMap[checkLocation, default: false] {
                    hasElf = true
                    break
                }
            }
            if !hasElf {
                let newLocation = elfLocation + check.first!.coordinateOffset
                var newLocations = proposals[newLocation, default: []]
                newLocations.append(elfLocation)
                proposals[newLocation] = newLocations
                break
            }
        }
    }

    // Filter proposals
    proposals = proposals.filter { $0.value.count == 1 }

    // Commit proposals
    for (newLocation, oldLocations) in proposals {
        let oldLocation = oldLocations.first!
        elvesMap[oldLocation] = nil
        elvesMap[newLocation] = true
    }

    return (elvesMap, proposals.isNotEmpty)
}

private func one(input: String) {
    var elvesMap = parseElves(input: input)
    let initialElvesCount = elvesMap.filter { $0.value }.keys.count

    let rounds = 10

    for round in 0..<rounds {
        let result = performRound(round: round, elvesMap)
        elvesMap = result.map
    }

    let xValues = elvesMap.keys.map(\.x)
    let yValues = elvesMap.keys.map(\.y)
    let minX = xValues.min()!
    let maxX = xValues.max()!
    let minY = yValues.min()!
    let maxY = yValues.max()!
    let elvesCount = elvesMap.filter { $0.value }.keys.count
    guard elvesCount == initialElvesCount else {
        fatalError("Lost elf! 😭")
    }

    let area = (maxX - minX + 1) * (maxY - minY + 1)
    print("Result: \(area - elvesCount)")

}

private func two(input: String) {
    var elvesMap = parseElves(input: input)

    var round = 0
    var hasMoved = true

    while hasMoved {
        let result = performRound(round: round, elvesMap)
        elvesMap = result.map
        hasMoved = result.hasMoved
        round += 1
    }

    print("Result: \(round)")
}
