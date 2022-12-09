//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle09() {
    print("Test")
    print("One")
    one(input: testInput09)
    print("Two")
    two(input: testInput09_01)

    print("")
    print("Real")
    print("One")
    one(input: input09)
    print("Two")
    two(input: input09)
}

private func moves(input: String) -> [Move] {
    let moves = input.components(separatedBy: "\n").map {
        let moveDescription = $0.components(separatedBy: " ")
        let steps = Int(moveDescription.last!)!
        switch moveDescription.first! {
        case "L": return Move.left(steps)
        case "R": return Move.right(steps)
        case "U": return Move.up(steps)
        case "D": return Move.down(steps)
        default: fatalError("Unknown move")
        }
    }

    return moves
}

private func one(input: String) {
    solve(input: input, knotsCount: 2)
}

private func two(input: String) {
    solve(input: input, knotsCount: 10)
}

private func solve(input: String, knotsCount: Int) {
    let moves = moves(input: input)

    var knots = Array(repeating: Position.zero, count: knotsCount)

    var tailPositions: Set<Position> = [knots.last!]

    moves.forEach { move in
        switch move {
        case .left(let steps):
            for _ in 1...steps {
                knots[0].x -= 1
                for i in 1..<knots.count {
                    knots[i] = moveTail(headPosition: knots[i-1], tailPosition: knots[i])
                }
                tailPositions.insert(knots.last!)
            }
        case .right(let steps):
            for _ in 1...steps {
                knots[0].x += 1
                for i in 1..<knots.count {
                    knots[i] = moveTail(headPosition: knots[i-1], tailPosition: knots[i])
                }
                tailPositions.insert(knots.last!)
            }
        case .up(let steps):
            for _ in 1...steps {
                knots[0].y += 1
                for i in 1..<knots.count {
                    knots[i] = moveTail(headPosition: knots[i-1], tailPosition: knots[i])
                }
                tailPositions.insert(knots.last!)
            }
        case .down(let steps):
            for _ in 1...steps {
                knots[0].y -= 1
                for i in 1..<knots.count {
                    knots[i] = moveTail(headPosition: knots[i-1], tailPosition: knots[i])
                }
                tailPositions.insert(knots.last!)
            }
        }
    }

    print(tailPositions.count)
}

private enum Move {
    case left(Int)
    case right(Int)
    case up(Int)
    case down(Int)
}

private struct Position: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int

    static let zero = Position(x: 0, y: 0)

    var description: String {
        "(\(x), \(y))"
    }
}

private func moveTail(headPosition: Position, tailPosition: Position) -> Position {
    guard abs(headPosition.x - tailPosition.x) > 1 || abs(headPosition.y - tailPosition.y) > 1 else {
        return tailPosition
    }

    func sign(_ a: Int, _ b: Int) -> Int {
        guard abs(a - b) > 0 else {
            return 0
        }
        return (a - b) / abs(a - b)
    }
    return Position(
        x: tailPosition.x + sign(headPosition.x, tailPosition.x),
        y: tailPosition.y + sign(headPosition.y, tailPosition.y)
    )
}
