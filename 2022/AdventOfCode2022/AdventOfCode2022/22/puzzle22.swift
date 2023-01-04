//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle22() {
    print("Test")
    print("One")
    one(input: testInput22)
    print("Two")
    two(input: testInput22, testInput: true)

    print("")
    print("Real")
    print("One")
    one(input: input22)
    print("Two")
    two(input: input22, testInput: false)
}

private enum Move: CustomStringConvertible {
    case move(steps: Int)
    case turnRight
    case turnLeft

    var description: String {
        switch self {
        case .move(let steps): return "\(steps)"
        case .turnLeft: return "L"
        case .turnRight: return "R"
        }
    }
}

private enum Facing: Int, CaseIterable, CustomStringConvertible {
    case right = 0, down, left, up

    var description: String {
        switch self {
        case .up: return "^"
        case .down: return "v"
        case .left: return "<"
        case .right: return ">"
        }
    }

    var turnRight: Facing {
        let index = (Self.allCases.firstIndex(of: self)! + 1) % Self.allCases.count
        return Self.allCases[index]
    }

    var turnLeft: Facing {
        let index = (Self.allCases.firstIndex(of: self)! - 1 + Self.allCases.count) % Self.allCases.count
        return Self.allCases[index]
    }
}

private enum Tile: Character, CustomStringConvertible {
    case space = " "
    case wall = "#"
    case open = "."

    var description: String { String(rawValue) }
}

private struct Position: Hashable {
    let side: Coordinate
    let positionInSide: Coordinate
    let facing: Facing

    var turnLeft: Position {
        Position(
            side: side,
            positionInSide: positionInSide,
            facing: facing.turnLeft
        )
    }

    var turnRight: Position {
        Position(
            side: side,
            positionInSide: positionInSide,
            facing: facing.turnRight
        )
    }
}

private struct Coordinate: Hashable, CustomStringConvertible {
    var x, y: Int

    var description: String {
        "(\(x), \(y))"
    }
}

private enum Edge: String, CaseIterable, CustomStringConvertible {
    case top, left, bottom, right

    var description: String {
        rawValue
    }
}

private struct Connection {
    let top: (edge: Edge, side: Coordinate)
    let left: (edge: Edge, side: Coordinate)
    let bottom: (edge: Edge, side: Coordinate)
    let right: (edge: Edge, side: Coordinate)
}

private func parsePages(input: String) -> (sideSize: Int, sides: Map, moves: [Move]) {
    let components = input.components(separatedBy: "\n\n")
    let map = components[0]
    let count = map.reduce(0) { partialResult, character in
        if ["#", "."].contains(character) {
            return partialResult + 1
        }
        return partialResult
    }

    let sideSize = Int(sqrt(Double(count / 6)))
    let checkSideSize = (sideSize * sideSize * 6)

    guard count == checkSideSize else {
        fatalError("Check parsing for side size")
    }

    print("Side size: \(sideSize)")

    let mapLines = map.components(separatedBy: "\n")
    let maxLine = mapLines.map(\.count).max()

    guard let maxLine else {
        fatalError("Cannot find max line")
    }

    let verticalSidesCount = mapLines.count / sideSize
    let horizontalSidesCount = maxLine / sideSize

    print("Sides: vertical \(verticalSidesCount), horizontal \(horizontalSidesCount)")

    var sides: Map = Array(repeating: Array(repeating: Array(repeating: Array(repeating: .space, count: sideSize), count: sideSize), count: horizontalSidesCount), count: verticalSidesCount)

    for (row, line) in mapLines.enumerated() {
        let verticalSideIndex = row / sideSize
        let y = row - verticalSideIndex * sideSize

        for (column, character) in line.enumerated() {
            let horizontalSideIndex = column / sideSize
            let x = column - horizontalSideIndex * sideSize

            sides[verticalSideIndex][horizontalSideIndex][y][x] = Tile(rawValue: character)!
        }
    }

    var steps: Int? = nil
    var moves: [Move] = []

    components[1].forEach {
        switch $0 {
        case "R":
            if let parsedSteps = steps {
                moves.append(.move(steps: parsedSteps))
                steps = nil
            }
            moves.append(.turnRight)
        case "L":
            if let parsedSteps = steps {
                moves.append(.move(steps: parsedSteps))
                steps = nil
            }
            moves.append(.turnLeft)
        default:
            guard let number = Int(String($0)) else {
                fatalError("\($0) is not a number")
            }
            if let parsedSteps = steps {
                steps = parsedSteps * 10 + number
            } else {
                steps = number
            }
        }
    }

    if let steps {
        moves.append(.move(steps: steps))
    }

    return (sideSize, sides, moves)
}

private typealias Map = [[[[Tile]]]]

private func tile(in map: Map, for side: Coordinate, and location: Coordinate) -> Tile {
    return map[side.y][side.x][location.y][location.x]
}

private func performStep(
    in map: Map,
    sideSize: Int,
    currentPosition: Position
) -> Position {
    switch currentPosition.facing {
    case .right:
        var newSide = currentPosition.side
        var newPosition = currentPosition.positionInSide
        newPosition.x += 1

        if newPosition.x >= sideSize {
            newSide = Coordinate(
                x: (newSide.x + 1) % map[newSide.y].count,
                y: newSide.y
            )
            newPosition.x = 0
        }
        if tile(in: map, for: newSide, and: newPosition) == .space {
            newSide.x = map[newSide.y].firstIndex(where: { $0[newPosition.y][newPosition.x] != .space })!
        }
        if tile(in: map, for: newSide, and: newPosition) == .wall {
            return currentPosition
        }
        return Position(
            side: newSide,
            positionInSide: newPosition,
            facing: currentPosition.facing
        )
    case .up:
        var newSide = currentPosition.side
        var newPosition = currentPosition.positionInSide
        newPosition.y -= 1

        if newPosition.y < 0 {
            newSide = Coordinate(
                x: newSide.x,
                y: (newSide.y - 1 + map.count) % map.count
            )
            newPosition.y = (sideSize - 1)
        }
        if tile(in: map, for: newSide, and: newPosition) == .space {
            newSide.y = map.lastIndex(where: { $0[newSide.x][newPosition.y][newPosition.x] != .space })!
        }
        if tile(in: map, for: newSide, and: newPosition) == .wall {
            return currentPosition
        }
        return Position(
            side: newSide,
            positionInSide: newPosition,
            facing: currentPosition.facing
        )
    case .down:
        var newSide = currentPosition.side
        var newPosition = currentPosition.positionInSide
        newPosition.y += 1

        if newPosition.y >= sideSize {
            newSide = Coordinate(
                x: newSide.x,
                y: (newSide.y + 1) % map.count
            )
            newPosition.y = 0
        }
        if tile(in: map, for: newSide, and: newPosition) == .space {
            newSide.y = map.firstIndex(where: { $0[newSide.x][newPosition.y][newPosition.x] != .space })!
        }
        if tile(in: map, for: newSide, and: newPosition) == .wall {
            return currentPosition
        }
        return Position(
            side: newSide,
            positionInSide: newPosition,
            facing: currentPosition.facing
        )
    case .left:
        var newSide = currentPosition.side
        var newPosition = currentPosition.positionInSide
        newPosition.x -= 1

        if newPosition.x < 0 {
            newSide = Coordinate(
                x: (newSide.x - 1 + map[newSide.y].count) % map[newSide.y].count,
                y: newSide.y
            )
            newPosition.x = (sideSize - 1)
        }
        if tile(in: map, for: newSide, and: newPosition) == .space {
            newSide.x = map[newSide.y].lastIndex(where: { $0[newPosition.y][newPosition.x] != .space })!
        }
        if tile(in: map, for: newSide, and: newPosition) == .wall {
            return currentPosition
        }
        return Position(
            side: newSide,
            positionInSide: newPosition,
            facing: currentPosition.facing
        )
    }
}

private func switchCubeEdge(from fromEdge: Edge, to toEdge: Edge, location: Coordinate, sideSize: Int) -> (location: Coordinate, facing: Facing) {
    switch (fromEdge, toEdge) {
    case (.left, .right):
        return (Coordinate(x: sideSize - 1, y: location.y), .left)
    case (.left, .bottom):
        return (Coordinate(x: (sideSize - 1) - location.y, y: sideSize - 1), .up)
    case (.left, .top):
        return (Coordinate(x: location.y, y: 0), .down)
    case (.left, .left):
        return (Coordinate(x: 0, y: (sideSize - 1) - location.y), .right)
    case (.right, .right):
        return (Coordinate(x: sideSize - 1, y: (sideSize - 1) - location.y), .left)
    case (.right, .bottom):
        return (Coordinate(x: location.y, y: sideSize - 1), .up)
    case (.right, .top):
        return (Coordinate(x: (sideSize - 1) - location.y, y: 0), .down)
    case (.right, .left):
        return (Coordinate(x: 0, y: location.y), .right)
    case (.bottom, .right):
        return (Coordinate(x: sideSize - 1, y: location.x), .left)
    case (.bottom, .bottom):
        return (Coordinate(x: (sideSize - 1) - location.x, y: sideSize - 1), .up)
    case (.bottom, .top):
        return (Coordinate(x: location.x, y: 0) , .down)
    case (.bottom, .left):
        return (Coordinate(x: 0, y: (sideSize - 1) - location.x), .right)
    case (.top, .right):
        return (Coordinate(x: sideSize - 1, y: (sideSize - 1) - location.x), .left)
    case (.top, .bottom):
        return (Coordinate(x: location.x, y: sideSize - 1), .up)
    case (.top, .top):
        return (Coordinate(x: (sideSize - 1) - location.x, y: 0), .down)
    case (.top, .left):
        return (Coordinate(x: 0, y: location.x), .right)
    }
}

private func performCubeStep(
    in map: Map,
    with cubeConnections: [Coordinate: Connection],
    sideSize: Int,
    currentPosition: Position
) -> Position {
    var newSide = currentPosition.side
    var newPosition = currentPosition.positionInSide
    var newFacing = currentPosition.facing

    switch currentPosition.facing {
    case .right:
        newPosition.x += 1

        if newPosition.x >= sideSize {
            let connection = cubeConnections[currentPosition.side]!.right
            newSide = connection.side

            let (location, facing) = switchCubeEdge(from: .right, to: connection.edge, location: currentPosition.positionInSide, sideSize: sideSize)
            newPosition = location
            newFacing = facing
        }
        if tile(in: map, for: newSide, and: newPosition) == .wall {
            return currentPosition
        }
        return Position(
            side: newSide,
            positionInSide: newPosition,
            facing: newFacing
        )
    case .left:
        newPosition.x -= 1

        if newPosition.x < 0 {
            let connection = cubeConnections[currentPosition.side]!.left
            newSide = connection.side

            let (location, facing) = switchCubeEdge(from: .left, to: connection.edge, location: currentPosition.positionInSide, sideSize: sideSize)
            newPosition = location
            newFacing = facing
        }
        if tile(in: map, for: newSide, and: newPosition) == .wall {
            return currentPosition
        }
        return Position(
            side: newSide,
            positionInSide: newPosition,
            facing: newFacing
        )
    case .up:
        newPosition.y -= 1

        if newPosition.y < 0 {
            let connection = cubeConnections[currentPosition.side]!.top
            newSide = connection.side

            let (location, facing) = switchCubeEdge(from: .top, to: connection.edge, location: currentPosition.positionInSide, sideSize: sideSize)
            newPosition = location
            newFacing = facing
        }
        if tile(in: map, for: newSide, and: newPosition) == .wall {
            return currentPosition
        }
        return Position(
            side: newSide,
            positionInSide: newPosition,
            facing: newFacing
        )
    case .down:
        newPosition.y += 1

        if newPosition.y >= sideSize {
            let connection = cubeConnections[currentPosition.side]!.bottom
            newSide = connection.side

            let (location, facing) = switchCubeEdge(from: .bottom, to: connection.edge, location: currentPosition.positionInSide, sideSize: sideSize)
            newPosition = location
            newFacing = facing
        }
        if tile(in: map, for: newSide, and: newPosition) == .wall {
            return currentPosition
        }
        return Position(
            side: newSide,
            positionInSide: newPosition,
            facing: newFacing
        )
    }
}

private func one(input: String) {
    let (sideSize, sides, moves) = parsePages(input: input)

    let firstNonEmptySideIndex = sides[0].firstIndex(where: { [Tile.open, Tile.wall].contains($0[0][0]) })!
    var position = Position(
        side: Coordinate(x: firstNonEmptySideIndex, y: 0),
        positionInSide: Coordinate(x: 0, y: 0),
        facing: .right
    )

    for move in moves {
        switch move {
        case .move(let steps):
            for _ in 0..<steps {
                let newPosition = performStep(in: sides, sideSize: sideSize, currentPosition: position)
                guard newPosition != position else {
                    break
                }
                position = newPosition
            }
        case .turnRight:
            position = position.turnRight
        case .turnLeft:
            position = position.turnLeft
        }
    }

    let password = (sideSize * position.side.y + (position.positionInSide.y + 1)) * 1000 +
                   (sideSize * position.side.x + (position.positionInSide.x + 1)) * 4 +
                   position.facing.rawValue

    print("Result: \(password)")

}

private func two(input: String, testInput: Bool) {
    let (sideSize, sides, moves) = parsePages(input: input)

    let firstNonEmptySideIndex = sides[0].firstIndex(where: { [Tile.open, Tile.wall].contains($0[0][0]) })!
    var position = Position(
        side: Coordinate(x: firstNonEmptySideIndex, y: 0),
        positionInSide: Coordinate(x: 0, y: 0),
        facing: .right
    )

    let cubeConnections: [Coordinate: Connection]

    if testInput {
        cubeConnections = [
            Coordinate(x: 2, y: 0): Connection(
                top: (.top, Coordinate(x: 0, y: 1)),
                left: (.top, Coordinate(x: 1, y: 1)),
                bottom: (.top, Coordinate(x: 2, y: 1)),
                right: (.right, Coordinate(x: 3, y: 2))
            ),
            Coordinate(x: 0, y: 1): Connection(
                top: (.top, Coordinate(x: 2, y: 0)),
                left: (.bottom, Coordinate(x: 3, y: 2)),
                bottom: (.bottom, Coordinate(x: 2, y: 2)),
                right: (.left, Coordinate(x: 1, y: 1))
            ),
            Coordinate(x: 1, y: 1): Connection(
                top: (.left, Coordinate(x: 2, y: 0)),
                left: (.right, Coordinate(x: 0, y: 1)),
                bottom: (.left, Coordinate(x: 2, y: 2)),
                right: (.left, Coordinate(x: 2, y: 1))
            ),
            Coordinate(x: 2, y: 1): Connection(
                top: (.bottom, Coordinate(x: 2, y: 0)),
                left: (.right, Coordinate(x: 1, y: 1)),
                bottom: (.top, Coordinate(x: 2, y: 2)),
                right: (.top, Coordinate(x: 3, y: 2))
            ),
            Coordinate(x: 2, y: 2): Connection(
                top: (.bottom, Coordinate(x: 2, y: 1)),
                left: (.bottom, Coordinate(x: 1, y: 1)),
                bottom: (.bottom, Coordinate(x: 0, y: 1)),
                right: (.left, Coordinate(x: 3, y: 2))
            ),
            Coordinate(x: 3, y: 2): Connection(
                top: (.right, Coordinate(x: 2, y: 1)),
                left: (.right, Coordinate(x: 2, y: 2)),
                bottom: (.left, Coordinate(x: 0, y: 1)),
                right: (.right, Coordinate(x: 2, y: 0))
            ),
        ]
    } else {
        cubeConnections = [
            Coordinate(x: 1, y: 0): Connection(
                top: (.left, Coordinate(x: 0, y: 3)),
                left: (.left, Coordinate(x: 0, y: 2)),
                bottom: (.top, Coordinate(x: 1, y: 1)),
                right: (.left, Coordinate(x: 2, y: 0))
            ),
            Coordinate(x: 2, y: 0): Connection(
                top: (.bottom, Coordinate(x: 0, y: 3)),
                left: (.right, Coordinate(x: 1, y: 0)),
                bottom: (.right, Coordinate(x: 1, y: 1)),
                right: (.right, Coordinate(x: 1, y: 2))
            ),
            Coordinate(x: 1, y: 1): Connection(
                top: (.bottom, Coordinate(x: 1, y: 0)),
                left: (.top, Coordinate(x: 0, y: 2)),
                bottom: (.top, Coordinate(x: 1, y: 2)),
                right: (.bottom, Coordinate(x: 2, y: 0))
            ),
            Coordinate(x: 0, y: 2): Connection(
                top: (.left, Coordinate(x: 1, y: 1)),
                left: (.left, Coordinate(x: 1, y: 0)),
                bottom: (.top, Coordinate(x: 0, y: 3)),
                right: (.left, Coordinate(x: 1, y: 2))
            ),
            Coordinate(x: 1, y: 2): Connection(
                top: (.bottom, Coordinate(x: 1, y: 1)),
                left: (.right, Coordinate(x: 0, y: 2)),
                bottom: (.right, Coordinate(x: 0, y: 3)),
                right: (.right, Coordinate(x: 2, y: 0))
            ),
            Coordinate(x: 0, y: 3): Connection(
                top: (.bottom, Coordinate(x: 0, y: 2)),
                left: (.top, Coordinate(x: 1, y: 0)),
                bottom: (.top, Coordinate(x: 2, y: 0)),
                right: (.bottom, Coordinate(x: 1, y: 2))
            ),
        ]
    }


    for move in moves {
        switch move {
        case .move(let steps):
            for _ in 0..<steps {
                let newPosition = performCubeStep(in: sides, with: cubeConnections, sideSize: sideSize, currentPosition: position)
                guard newPosition != position else {
                    break
                }
                position = newPosition
            }
        case .turnRight:
            position = position.turnRight
        case .turnLeft:
            position = position.turnLeft
        }
    }

    let password = (sideSize * position.side.y + (position.positionInSide.y + 1)) * 1000 +
                   (sideSize * position.side.x + (position.positionInSide.x + 1)) * 4 +
                   position.facing.rawValue

    print("Result: \(password)")
}
