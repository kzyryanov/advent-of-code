//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

private let clusterTest = """
1,2,2
3,2,2
2,3,2
2,2,3
2,1,2
2,2,1
"""

func puzzle18() {
    print("Test")
    print("One")
    one(input: testInput18)
    print("Two")
    two(input: testInput18)

    print("")
    print("Real")
    print("One")
    one(input: input18)
    print("Two")
    two(input: input18)
}

private struct Coordinate: Hashable, CustomStringConvertible {
    let x, y, z: Int

    init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }

    init(_ coordinates: [Int]) {
        x = coordinates[0]
        y = coordinates[1]
        z = coordinates[2]
    }

    var description: String {
        "\(x),\(y),\(z)"
    }
}

private enum Side: Hashable {
    enum Position: Hashable {
        case frontBack(Coordinate)
        case topBottom(Coordinate)
        case leftRight(Coordinate)
    }

    case top(Coordinate)
    case bottom(Coordinate)
    case front(Coordinate)
    case back(Coordinate)
    case left(Coordinate)
    case right(Coordinate)

    var coordinate: Coordinate {
        switch self {
        case .top(let coordinate),
                .bottom(let coordinate),
                .front(let coordinate),
                .back(let coordinate),
                .left(let coordinate),
                .right(let coordinate):
            return coordinate
        }
    }

    var adjacent: Set<Side> {
        switch self {
        case .top(let coordinate):
            return [
                .left(Coordinate(x: coordinate.x - 5, y: coordinate.y, z: coordinate.z + 5)),
                .left(Coordinate(x: coordinate.x - 5, y: coordinate.y, z: coordinate.z - 5)),
                .left(Coordinate(x: coordinate.x + 5, y: coordinate.y, z: coordinate.z + 5)),
                .left(Coordinate(x: coordinate.x + 5, y: coordinate.y, z: coordinate.z - 5)),

                .right(Coordinate(x: coordinate.x - 5, y: coordinate.y, z: coordinate.z + 5)),
                .right(Coordinate(x: coordinate.x - 5, y: coordinate.y, z: coordinate.z - 5)),
                .right(Coordinate(x: coordinate.x + 5, y: coordinate.y, z: coordinate.z + 5)),
                .right(Coordinate(x: coordinate.x + 5, y: coordinate.y, z: coordinate.z - 5)),

                .front(Coordinate(x: coordinate.x, y: coordinate.y + 5, z: coordinate.z + 5)),
                .front(Coordinate(x: coordinate.x, y: coordinate.y + 5, z: coordinate.z - 5)),
                .front(Coordinate(x: coordinate.x, y: coordinate.y - 5, z: coordinate.z + 5)),
                .front(Coordinate(x: coordinate.x, y: coordinate.y - 5, z: coordinate.z - 5)),

                .back(Coordinate(x: coordinate.x, y: coordinate.y + 5, z: coordinate.z + 5)),
                .back(Coordinate(x: coordinate.x, y: coordinate.y + 5, z: coordinate.z - 5)),
                .back(Coordinate(x: coordinate.x, y: coordinate.y - 5, z: coordinate.z + 5)),
                .back(Coordinate(x: coordinate.x, y: coordinate.y - 5, z: coordinate.z - 5)),

                .top(Coordinate(x: coordinate.x + 10, y: coordinate.y, z: coordinate.z)),
                .top(Coordinate(x: coordinate.x - 10, y: coordinate.y, z: coordinate.z)),
                .top(Coordinate(x: coordinate.x, y: coordinate.y + 10, z: coordinate.z)),
                .top(Coordinate(x: coordinate.x, y: coordinate.y - 10, z: coordinate.z)),
            ]
        case .bottom(let coordinate):
            return [
                .left(Coordinate(x: coordinate.x - 5, y: coordinate.y, z: coordinate.z + 5)),
                .left(Coordinate(x: coordinate.x - 5, y: coordinate.y, z: coordinate.z - 5)),
                .left(Coordinate(x: coordinate.x + 5, y: coordinate.y, z: coordinate.z + 5)),
                .left(Coordinate(x: coordinate.x + 5, y: coordinate.y, z: coordinate.z - 5)),

                .right(Coordinate(x: coordinate.x - 5, y: coordinate.y, z: coordinate.z + 5)),
                .right(Coordinate(x: coordinate.x - 5, y: coordinate.y, z: coordinate.z - 5)),
                .right(Coordinate(x: coordinate.x + 5, y: coordinate.y, z: coordinate.z + 5)),
                .right(Coordinate(x: coordinate.x + 5, y: coordinate.y, z: coordinate.z - 5)),

                .front(Coordinate(x: coordinate.x, y: coordinate.y + 5, z: coordinate.z + 5)),
                .front(Coordinate(x: coordinate.x, y: coordinate.y + 5, z: coordinate.z - 5)),
                .front(Coordinate(x: coordinate.x, y: coordinate.y - 5, z: coordinate.z + 5)),
                .front(Coordinate(x: coordinate.x, y: coordinate.y - 5, z: coordinate.z - 5)),

                .back(Coordinate(x: coordinate.x, y: coordinate.y + 5, z: coordinate.z + 5)),
                .back(Coordinate(x: coordinate.x, y: coordinate.y + 5, z: coordinate.z - 5)),
                .back(Coordinate(x: coordinate.x, y: coordinate.y - 5, z: coordinate.z + 5)),
                .back(Coordinate(x: coordinate.x, y: coordinate.y - 5, z: coordinate.z - 5)),

                .bottom(Coordinate(x: coordinate.x + 10, y: coordinate.y, z: coordinate.z)),
                .bottom(Coordinate(x: coordinate.x - 10, y: coordinate.y, z: coordinate.z)),
                .bottom(Coordinate(x: coordinate.x, y: coordinate.y + 10, z: coordinate.z)),
                .bottom(Coordinate(x: coordinate.x, y: coordinate.y - 10, z: coordinate.z)),
            ]
        case .front(let coordinate):
            return [
                .left(Coordinate(x: coordinate.x - 5, y: coordinate.y + 5, z: coordinate.z)),
                .left(Coordinate(x: coordinate.x - 5, y: coordinate.y - 5, z: coordinate.z)),
                .left(Coordinate(x: coordinate.x + 5, y: coordinate.y + 5, z: coordinate.z)),
                .left(Coordinate(x: coordinate.x + 5, y: coordinate.y - 5, z: coordinate.z)),

                .right(Coordinate(x: coordinate.x - 5, y: coordinate.y + 5, z: coordinate.z)),
                .right(Coordinate(x: coordinate.x - 5, y: coordinate.y - 5, z: coordinate.z)),
                .right(Coordinate(x: coordinate.x + 5, y: coordinate.y + 5, z: coordinate.z)),
                .right(Coordinate(x: coordinate.x + 5, y: coordinate.y - 5, z: coordinate.z)),

                .top(Coordinate(x: coordinate.x, y: coordinate.y + 5, z: coordinate.z + 5)),
                .top(Coordinate(x: coordinate.x, y: coordinate.y - 5, z: coordinate.z + 5)),
                .top(Coordinate(x: coordinate.x, y: coordinate.y + 5, z: coordinate.z - 5)),
                .top(Coordinate(x: coordinate.x, y: coordinate.y - 5, z: coordinate.z - 5)),

                .bottom(Coordinate(x: coordinate.x, y: coordinate.y + 5, z: coordinate.z + 5)),
                .bottom(Coordinate(x: coordinate.x, y: coordinate.y - 5, z: coordinate.z + 5)),
                .bottom(Coordinate(x: coordinate.x, y: coordinate.y + 5, z: coordinate.z - 5)),
                .bottom(Coordinate(x: coordinate.x, y: coordinate.y - 5, z: coordinate.z - 5)),

                .front(Coordinate(x: coordinate.x - 10, y: coordinate.y, z: coordinate.z)),
                .front(Coordinate(x: coordinate.x + 10, y: coordinate.y, z: coordinate.z)),
                .front(Coordinate(x: coordinate.x, y: coordinate.y, z: coordinate.z + 10)),
                .front(Coordinate(x: coordinate.x, y: coordinate.y, z: coordinate.z - 10)),
            ]
        case .back(let coordinate):
            return [
                .left(Coordinate(x: coordinate.x - 5, y: coordinate.y + 5, z: coordinate.z)),
                .left(Coordinate(x: coordinate.x - 5, y: coordinate.y - 5, z: coordinate.z)),
                .left(Coordinate(x: coordinate.x + 5, y: coordinate.y + 5, z: coordinate.z)),
                .left(Coordinate(x: coordinate.x + 5, y: coordinate.y - 5, z: coordinate.z)),

                .right(Coordinate(x: coordinate.x - 5, y: coordinate.y + 5, z: coordinate.z)),
                .right(Coordinate(x: coordinate.x - 5, y: coordinate.y - 5, z: coordinate.z)),
                .right(Coordinate(x: coordinate.x + 5, y: coordinate.y + 5, z: coordinate.z)),
                .right(Coordinate(x: coordinate.x + 5, y: coordinate.y - 5, z: coordinate.z)),

                .top(Coordinate(x: coordinate.x, y: coordinate.y + 5, z: coordinate.z + 5)),
                .top(Coordinate(x: coordinate.x, y: coordinate.y - 5, z: coordinate.z + 5)),
                .top(Coordinate(x: coordinate.x, y: coordinate.y + 5, z: coordinate.z - 5)),
                .top(Coordinate(x: coordinate.x, y: coordinate.y - 5, z: coordinate.z - 5)),

                .bottom(Coordinate(x: coordinate.x, y: coordinate.y + 5, z: coordinate.z + 5)),
                .bottom(Coordinate(x: coordinate.x, y: coordinate.y - 5, z: coordinate.z + 5)),
                .bottom(Coordinate(x: coordinate.x, y: coordinate.y + 5, z: coordinate.z - 5)),
                .bottom(Coordinate(x: coordinate.x, y: coordinate.y - 5, z: coordinate.z - 5)),

                .back(Coordinate(x: coordinate.x - 10, y: coordinate.y, z: coordinate.z)),
                .back(Coordinate(x: coordinate.x + 10, y: coordinate.y, z: coordinate.z)),
                .back(Coordinate(x: coordinate.x, y: coordinate.y, z: coordinate.z + 10)),
                .back(Coordinate(x: coordinate.x, y: coordinate.y, z: coordinate.z - 10))
            ]
        case .left(let coordinate):
            return [
                .front(Coordinate(x: coordinate.x - 5, y: coordinate.y + 5, z: coordinate.z)),
                .front(Coordinate(x: coordinate.x - 5, y: coordinate.y - 5, z: coordinate.z)),
                .front(Coordinate(x: coordinate.x + 5, y: coordinate.y + 5, z: coordinate.z)),
                .front(Coordinate(x: coordinate.x + 5, y: coordinate.y - 5, z: coordinate.z)),

                .back(Coordinate(x: coordinate.x - 5, y: coordinate.y + 5, z: coordinate.z)),
                .back(Coordinate(x: coordinate.x - 5, y: coordinate.y - 5, z: coordinate.z)),
                .back(Coordinate(x: coordinate.x + 5, y: coordinate.y + 5, z: coordinate.z)),
                .back(Coordinate(x: coordinate.x + 5, y: coordinate.y - 5, z: coordinate.z)),

                .top(Coordinate(x: coordinate.x - 5, y: coordinate.y, z: coordinate.z + 5)),
                .top(Coordinate(x: coordinate.x - 5, y: coordinate.y, z: coordinate.z - 5)),
                .top(Coordinate(x: coordinate.x + 5, y: coordinate.y, z: coordinate.z + 5)),
                .top(Coordinate(x: coordinate.x + 5, y: coordinate.y, z: coordinate.z - 5)),

                .bottom(Coordinate(x: coordinate.x - 5, y: coordinate.y, z: coordinate.z + 5)),
                .bottom(Coordinate(x: coordinate.x - 5, y: coordinate.y, z: coordinate.z - 5)),
                .bottom(Coordinate(x: coordinate.x + 5, y: coordinate.y, z: coordinate.z + 5)),
                .bottom(Coordinate(x: coordinate.x + 5, y: coordinate.y, z: coordinate.z - 5)),

                .left(Coordinate(x: coordinate.x, y: coordinate.y + 10, z: coordinate.z)),
                .left(Coordinate(x: coordinate.x, y: coordinate.y - 10, z: coordinate.z)),
                .left(Coordinate(x: coordinate.x, y: coordinate.y, z: coordinate.z + 10)),
                .left(Coordinate(x: coordinate.x, y: coordinate.y, z: coordinate.z - 10)),
            ]
        case .right(let coordinate):
            return [
                .front(Coordinate(x: coordinate.x - 5, y: coordinate.y + 5, z: coordinate.z)),
                .front(Coordinate(x: coordinate.x - 5, y: coordinate.y - 5, z: coordinate.z)),
                .front(Coordinate(x: coordinate.x + 5, y: coordinate.y + 5, z: coordinate.z)),
                .front(Coordinate(x: coordinate.x + 5, y: coordinate.y - 5, z: coordinate.z)),

                .back(Coordinate(x: coordinate.x - 5, y: coordinate.y + 5, z: coordinate.z)),
                .back(Coordinate(x: coordinate.x - 5, y: coordinate.y - 5, z: coordinate.z)),
                .back(Coordinate(x: coordinate.x + 5, y: coordinate.y + 5, z: coordinate.z)),
                .back(Coordinate(x: coordinate.x + 5, y: coordinate.y - 5, z: coordinate.z)),

                .top(Coordinate(x: coordinate.x - 5, y: coordinate.y, z: coordinate.z + 5)),
                .top(Coordinate(x: coordinate.x - 5, y: coordinate.y, z: coordinate.z - 5)),
                .top(Coordinate(x: coordinate.x + 5, y: coordinate.y, z: coordinate.z + 5)),
                .top(Coordinate(x: coordinate.x + 5, y: coordinate.y, z: coordinate.z - 5)),

                .bottom(Coordinate(x: coordinate.x - 5, y: coordinate.y, z: coordinate.z + 5)),
                .bottom(Coordinate(x: coordinate.x - 5, y: coordinate.y, z: coordinate.z - 5)),
                .bottom(Coordinate(x: coordinate.x + 5, y: coordinate.y, z: coordinate.z + 5)),
                .bottom(Coordinate(x: coordinate.x + 5, y: coordinate.y, z: coordinate.z - 5)),

                .right(Coordinate(x: coordinate.x, y: coordinate.y + 10, z: coordinate.z)),
                .right(Coordinate(x: coordinate.x, y: coordinate.y - 10, z: coordinate.z)),
                .right(Coordinate(x: coordinate.x, y: coordinate.y, z: coordinate.z + 10)),
                .right(Coordinate(x: coordinate.x, y: coordinate.y, z: coordinate.z - 10))
            ]
        }
    }

    var position: Position {
        switch self {
        case .left(let coordinate), .right(let coordinate): return .leftRight(coordinate)
        case .front(let coordinate), .back(let coordinate): return .frontBack(coordinate)
        case .top(let coordinate), .bottom(let coordinate): return .topBottom(coordinate)
        }
    }

    static func cubeSides(cube: Coordinate) -> [Self] {
        [
            .top(   Coordinate(x: cube.x,     y: cube.y,     z: cube.z + 5)),
            .bottom(Coordinate(x: cube.x,     y: cube.y,     z: cube.z - 5)),
            .left(  Coordinate(x: cube.x - 5, y: cube.y,     z: cube.z)),
            .right( Coordinate(x: cube.x + 5, y: cube.y,     z: cube.z)),
            .front( Coordinate(x: cube.x,     y: cube.y + 5, z: cube.z)),
            .back(  Coordinate(x: cube.x,     y: cube.y - 5, z: cube.z)),
        ]
    }

    var flipped: Self {
        switch self {
        case .top(let coordinate):
            return .bottom(coordinate)
        case .bottom(let coordinate):
            return .top(coordinate)
        case .front(let coordinate):
            return .back(coordinate)
        case .back(let coordinate):
            return .front(coordinate)
        case .left(let coordinate):
            return .right(coordinate)
        case .right(let coordinate):
            return .left(coordinate)
        }
    }
}

private func one(input: String) {
    let cubes = input.components(separatedBy: "\n").map {
        Coordinate($0.components(separatedBy: ",").map { Int($0)! * 10 })
    }

    var sidePositions: Set<Side.Position> = []
    var sides: Set<Side> = []

    for cube in cubes {
        let cubeSides = Side.cubeSides(cube: cube)
        for side in cubeSides {
            let position = side.position
            if sidePositions.contains(position) {
                sides.remove(side)
                sides.remove(side.flipped)
                sidePositions.remove(position)
            } else {
                sides.insert(side)
                sidePositions.insert(position)
            }
        }
    }

    print("Result: \(sides.count)")
}

private func two(input: String) {
    let cubes = input.components(separatedBy: "\n").map {
        Coordinate($0.components(separatedBy: ",").map { Int($0)! * 10 })
    }

    var sidePositions: Set<Side.Position> = []
    var sides: Set<Side> = []

    for cube in cubes {
        let cubeSides = Side.cubeSides(cube: cube)
        for side in cubeSides {
            let position = side.position
            if sidePositions.contains(position) {
                sides.remove(side)
                sides.remove(side.flipped)
                sidePositions.remove(position)
            } else {
                sides.insert(side)
                sidePositions.insert(position)
            }
        }
    }

    var clusters: [Set<Side>] = []

    let clusterSides = sides
    var visited: Set<Side> = []

    func findClusters(side: Side) -> Set<Side> {
        if visited == clusterSides {
            return []
        }

        visited.insert(side)

        let adjacentSides = side.adjacent
        let adjacentFigureSides = clusterSides.intersection(adjacentSides)

        var intersection: Set<Side> = []

        for adjacentSide in adjacentFigureSides {
            var blocked = false
            switch side {
            case .top:
                switch adjacentSide {
                case .front(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .back(Coordinate(x: coordinate.x, y: coordinate.y, z: coordinate.z + 10))
                    )
                case .back(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .front(Coordinate(x: coordinate.x, y: coordinate.y, z: coordinate.z + 10))
                    )
                case .left(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .right(Coordinate(x: coordinate.x, y: coordinate.y, z: coordinate.z + 10))
                    )
                case .right(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .left(Coordinate(x: coordinate.x, y: coordinate.y, z: coordinate.z + 10))
                    )
                default: break
                }
            case .bottom:
                switch adjacentSide {
                case .front(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .back(Coordinate(x: coordinate.x, y: coordinate.y, z: coordinate.z - 10))
                    )
                case .back(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .front(Coordinate(x: coordinate.x, y: coordinate.y, z: coordinate.z - 10))
                    )
                case .left(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .right(Coordinate(x: coordinate.x, y: coordinate.y, z: coordinate.z - 10))
                    )
                case .right(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .left(Coordinate(x: coordinate.x, y: coordinate.y, z: coordinate.z - 10))
                    )
                default: break
                }
            case .left:
                switch adjacentSide {
                case .front(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .back(Coordinate(x: coordinate.x - 10, y: coordinate.y, z: coordinate.z))
                    )
                case .back(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .front(Coordinate(x: coordinate.x - 10, y: coordinate.y, z: coordinate.z))
                    )
                case .top(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .bottom(Coordinate(x: coordinate.x - 10, y: coordinate.y, z: coordinate.z))
                    )
                case .bottom(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .top(Coordinate(x: coordinate.x - 10, y: coordinate.y, z: coordinate.z))
                    )
                default: break
                }
            case .right:
                switch adjacentSide {
                case .front(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .back(Coordinate(x: coordinate.x + 10, y: coordinate.y, z: coordinate.z))
                    )
                case .back(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .front(Coordinate(x: coordinate.x + 10, y: coordinate.y, z: coordinate.z))
                    )
                case .top(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .bottom(Coordinate(x: coordinate.x + 10, y: coordinate.y, z: coordinate.z))
                    )
                case .bottom(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .top(Coordinate(x: coordinate.x + 10, y: coordinate.y, z: coordinate.z))
                    )
                default: break
                }
            case .front:
                switch adjacentSide {
                case .top(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .bottom(Coordinate(x: coordinate.x, y: coordinate.y + 10, z: coordinate.z))
                    )
                case .bottom(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .top(Coordinate(x: coordinate.x, y: coordinate.y + 10, z: coordinate.z))
                    )
                case .left(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .right(Coordinate(x: coordinate.x, y: coordinate.y + 10, z: coordinate.z))
                    )
                case .right(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .left(Coordinate(x: coordinate.x, y: coordinate.y + 10, z: coordinate.z))
                    )
                default: break
                }
            case .back:
                switch adjacentSide {
                case .top(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .bottom(Coordinate(x: coordinate.x, y: coordinate.y - 10, z: coordinate.z))
                    )
                case .bottom(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .top(Coordinate(x: coordinate.x, y: coordinate.y - 10, z: coordinate.z))
                    )
                case .left(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .right(Coordinate(x: coordinate.x, y: coordinate.y - 10, z: coordinate.z))
                    )
                case .right(let coordinate):
                    blocked = adjacentFigureSides.contains(
                        .left(Coordinate(x: coordinate.x, y: coordinate.y - 10, z: coordinate.z))
                    )
                default: break
                }
            }
            if !blocked && !visited.contains(adjacentSide) {
                intersection.insert(adjacentSide)
            }
        }


        intersection.forEach { side in
            visited.insert(side)
        }

        var result: Set<Side> = [side]

        intersection.forEach {
            result.insert($0)
            let miniCluster = findClusters(side: $0)
            miniCluster.forEach { result.insert($0) }
        }

        return result
    }

    while visited != clusterSides {
        guard let side = clusterSides.first(where: { !visited.contains($0) }) else {
            break
        }

        let cluster = findClusters(side: side)
        clusters.append(cluster)
    }

    let result = clusters.map(\.count).max()!

    print("Result: \(result)")
}
