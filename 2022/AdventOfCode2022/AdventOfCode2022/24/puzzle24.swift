//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle24() {
    print("Test")
    print("One")
    one(input: miniInput24)
    one(input: testInput24)
    print("Two")
    two(input: testInput24)

    print("")
    print("Real")
    print("One")
    one(input: input24)
    print("Two")
    two(input: input24)
}

private struct Coordinate: Hashable {
    let x, y: Int

    static func +(_ lhs: Coordinate, _ rhs: Coordinate) -> Coordinate {
        Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

private enum Direction: Character, CaseIterable, CustomStringConvertible {
    case up = "^"
    case down = "v"
    case left = "<"
    case right = ">"

    var coordinateOffset: Coordinate {
        switch self {
        case .up: return Coordinate(x: 0, y: -1)
        case .down: return Coordinate(x: 0, y: 1)
        case .left: return Coordinate(x: -1, y: 0)
        case .right: return Coordinate(x: 1, y: 0)
        }
    }

    var description: String { String(rawValue) }
}

private struct MinuteState: Hashable {
    let blizzards: [Coordinate: [Direction]]
    let expedition: Coordinate
}

private func parseMap(input: String) -> (walls: [Coordinate: Bool], blizzards: [Coordinate: [Direction]]) {
    var walls: [Coordinate: Bool] = [:]
    var blizzards: [Coordinate: [Direction]] = [:]

    input.components(separatedBy: "\n").enumerated().forEach { (row, line) in
        line.enumerated().forEach { (column, symbol) in
            let location = Coordinate(x: column, y: row)
            switch symbol {
            case "<", "^", "v", ">":
                blizzards[location] = [Direction(rawValue: symbol)!]
            case "#":
                walls[location] = true
            default: break
            }
        }
    }
    return (walls, blizzards)
}

private func printState(walls: [Coordinate: Bool], _ state: MinuteState) {
    let maxX = walls.keys.map(\.x).max()!
    let maxY = walls.keys.map(\.y).max()!

    for y in 0...maxY {
        for x in 0...maxX {
            let coordinate = Coordinate(x: x, y: y)
            if walls[coordinate, default: false] {
                print("#", terminator: "")
            } else if let blizzards = state.blizzards[coordinate] {
                if blizzards.count > 1 {
                    print(blizzards.count, terminator: "")
                } else if let blizzard = blizzards.first {
                    print(blizzard, terminator: "")
                }
            } else if coordinate == state.expedition {
                print("E", terminator: "")
            } else {
                print(".", terminator: "")
            }
        }
        print("")
    }
}

private func one(input: String) {
    let map = parseMap(input: input)
    let maxX = map.walls.keys.map(\.x).max()!
    let maxY = map.walls.keys.map(\.y).max()!

    let startLocation = Coordinate(x: 1, y: 0)
    let destination = Coordinate(x: maxX - 1, y: maxY)

    let result = solve(
        walls: map.walls,
        initialStates: [MinuteState(blizzards: map.blizzards, expedition: startLocation)],
        startLocation: startLocation,
        destination: destination
    )

    print("Result: \(result.minutes), \(result.states.count)")
}

private func solve(
    walls: [Coordinate: Bool],
    initialStates: Set<MinuteState>,
    startLocation: Coordinate,
    destination: Coordinate
) -> (states: Set<MinuteState>, minutes: Int) {
    var blizzards = initialStates.first!.blizzards
    let maxX = walls.keys.map(\.x).max()!
    let maxY = walls.keys.map(\.y).max()!

    var states: Set<MinuteState> = initialStates
    var minute: Int = 0

    var historicalStates: Set<MinuteState> = initialStates

    while states.isNotEmpty {
        let expeditionLocations = Set(states.map(\.expedition))
        let minEX = expeditionLocations.map(\.x).min()!
        let minEY = expeditionLocations.map(\.y).min()!
        let maxEX = expeditionLocations.map(\.x).max()!
        let maxEY = expeditionLocations.map(\.y).max()!
        print("Locations \(minEX)/\(maxEX)/\(destination.x), \(minEY)/\(maxEY)/\(destination.y)")
        if expeditionLocations.contains(destination) {
            return (states.filter({ $0.expedition == destination }), minute)
        }
        print("Minute \(minute + 1)")
        var newStates: Set<MinuteState> = []

        var newBlizzards: [Coordinate: [Direction]] = [:]
        // Wind blow
        for (location, blizzardsList) in blizzards {
            for blizzard in blizzardsList {
                var newLocationX = location.x + blizzard.coordinateOffset.x
                var newLocationY = location.y + blizzard.coordinateOffset.y
                if newLocationX < 1 {
                    newLocationX = maxX - 1
                }
                if newLocationX >= maxX {
                    newLocationX = 1
                }
                if newLocationY < 1 {
                    newLocationY = maxY - 1
                }
                if newLocationY >= maxY {
                    newLocationY = 1
                }
                let newLocation = Coordinate(x: newLocationX, y: newLocationY)
                var newBlizzardsList = newBlizzards[newLocation, default: []]
                newBlizzardsList.append(blizzard)
                newBlizzards[newLocation] = newBlizzardsList.sorted(by: { $0.rawValue.asciiValue! < $1.rawValue.asciiValue! })
            }
        }
        blizzards = newBlizzards

        states.forEach { state in
            // Move expedition

            func checkExpeditionLocation(_ newExpeditionLocation: Coordinate) -> Bool {
                if !(0...maxX).contains(newExpeditionLocation.x) ||
                    !(0...maxY).contains(newExpeditionLocation.y) ||
                    walls[newExpeditionLocation, default: false] ||
                    blizzards[newExpeditionLocation, default: []].isNotEmpty {
                    return false
                }
                return true
            }

            // Check moves
            for possibleDirection in Direction.allCases {
                let newExpeditionLocation = state.expedition + possibleDirection.coordinateOffset
                if checkExpeditionLocation(newExpeditionLocation) {
                    let newState = MinuteState(blizzards: blizzards, expedition: newExpeditionLocation)
                    if !historicalStates.contains(newState) {
                        newStates.insert(newState)
                        historicalStates.insert(newState)
                    }
                }
            }
            // Check wait
            if checkExpeditionLocation(state.expedition) {
                let newState = MinuteState(blizzards: blizzards, expedition: state.expedition)
                if !historicalStates.contains(newState) {
                    newStates.insert(newState)
                    historicalStates.insert(newState)
                }
            }
        }
        states = newStates
        print("Number of states \(states.count)")
//        for state in states {
//            printState(walls: walls, state)
//        }
        minute += 1
    }

    fatalError("Cannot reach the destination")
}

private func two(input: String) {
    let map = parseMap(input: input)
    let maxX = map.walls.keys.map(\.x).max()!
    let maxY = map.walls.keys.map(\.y).max()!

    let startLocation = Coordinate(x: 1, y: 0)
    let destination = Coordinate(x: maxX - 1, y: maxY)

    let resultThere = solve(
        walls: map.walls,
        initialStates: [MinuteState(blizzards: map.blizzards, expedition: startLocation)],
        startLocation: startLocation,
        destination: destination
    )

    let resultBack = solve(
        walls: map.walls,
        initialStates: resultThere.states,
        startLocation: destination,
        destination: startLocation
    )

    let result = solve(
        walls: map.walls,
        initialStates: resultBack.states,
        startLocation: startLocation,
        destination: destination
    )

    let resultMinutes = resultThere.minutes + resultBack.minutes + result.minutes

    print("Result: \(resultMinutes)")
}
