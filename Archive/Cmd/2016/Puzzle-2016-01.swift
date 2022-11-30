//
//  Data2.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-11-24.
//

import Foundation

func puzzle2016_01() {
    print("Start puzzle 2016.1")

    let input = "R2, L3, R2, R4, L2, L1, R2, R4, R1, L4, L5, R5, R5, R2, R2, R1, L2, L3, L2, L1, R3, L5, R187, R1, R4, L1, R5, L3, L4, R50, L4, R2, R70, L3, L2, R4, R3, R194, L3, L4, L4, L3, L4, R4, R5, L1, L5, L4, R1, L2, R4, L5, L3, R4, L5, L5, R5, R3, R5, L2, L4, R4, L1, R3, R1, L1, L2, R2, R2, L3, R3, R2, R5, R2, R5, L3, R2, L5, R1, R2, R2, L4, L5, L1, L4, R4, R3, R1, R2, L1, L2, R4, R5, L2, R3, L4, L5, L5, L4, R4, L2, R1, R1, L2, L3, L2, R2, L4, R3, R2, L1, L3, L2, L4, L4, R2, L3, L3, R2, L4, L3, R4, R3, L2, L1, L4, R4, R2, L4, L4, L5, L1, R2, L5, L2, L3, R2, L2"

    enum Movement {
        case left(Int)
        case right(Int)
    }

    enum Direction {
        case north, south, west, east
    }


    struct Position: Hashable {
        var x, y: Int

        static let zero = Position(x: 0, y: 0)
    }

    let data: [Movement] = input.components(separatedBy: ", ").map { d in
        var instruction = d
        let direction = instruction.remove(at: instruction.startIndex)
        let blocks = Int(instruction)!
        switch direction {
        case "R": return Movement.right(blocks)
        case "L": return Movement.left(blocks)
        default: fatalError()
        }
    }

    var position = Position.zero
    var direction: Direction = .north

    var locations: Set<Position> = [position]
    func addLocation(_ position: Position) {
        if locations.contains(position) {
            print("visited: \(position)")
        }
        locations.insert(position)
    }

    for instruction in data {
        switch instruction {
        case .left(let blocks):
            switch direction {
            case .north:
                var block = 0
                while block < blocks {
                    block += 1
                    addLocation(Position(x: position.x - block, y: position.y))
                }
                position.x -= blocks
                direction = .west
            case .south:
                var block = 0
                while block < blocks {
                    block += 1
                    addLocation(Position(x: position.x + block, y: position.y))
                }
                position.x += blocks
                direction = .east
            case .east:
                var block = 0
                while block < blocks {
                    block += 1
                    addLocation(Position(x: position.x, y: position.y + block))
                }
                position.y += blocks
                direction = .north
            case .west:
                var block = 0
                while block < blocks {
                    block += 1
                    addLocation(Position(x: position.x, y: position.y - block))
                }
                position.y -= blocks
                direction = .south
            }
        case .right(let blocks):
            switch direction {
            case .north:
                var block = 0
                while block < blocks {
                    block += 1
                    addLocation(Position(x: position.x + block, y: position.y))
                }
                position.x += blocks
                direction = .east
            case .south:
                var block = 0
                while block < blocks {
                    block += 1
                    addLocation(Position(x: position.x - block, y: position.y))
                }
                position.x -= blocks
                direction = .west
            case .east:
                var block = 0
                while block < blocks {
                    block += 1
                    addLocation(Position(x: position.x, y: position.y - block))
                }
                position.y -= blocks
                direction = .south
            case .west:
                var block = 0
                while block < blocks {
                    block += 1
                    addLocation(Position(x: position.x, y: position.y + block))
                }
                position.y += blocks
                direction = .north
            }
        }
    }

    print(position)

}
