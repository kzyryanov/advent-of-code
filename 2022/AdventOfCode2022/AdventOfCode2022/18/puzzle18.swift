//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle18() {
    print("Test")
    print("One")
    one(input: testInput18)
    print("Two")
    two(input: testInput18)

//    print("")
//    print("Real")
//    print("One")
//    one(input: input18)
//    print("Two")
//    two(input: input18)
}

private struct Cube: Hashable, CustomStringConvertible {
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

private func one(input: String) {
    let cubes = input.components(separatedBy: "\n").map {
        Cube($0.components(separatedBy: ",").map { Int($0)! * 10 })
    }

    var sides: Set<Cube> = []

    let offsets = [
        Cube(x: 0, y: 5, z: 0),
        Cube(x: 0, y: -5, z: 0),
        Cube(x: 5, y: 0, z: 0),
        Cube(x: -5, y: 0, z: 0),
        Cube(x: 0, y: 0, z: 5),
        Cube(x: 0, y: 0, z: -5),
    ]

    for cube in cubes {
        for offset in offsets {
            let side = Cube(
                x: cube.x - offset.x,
                y: cube.y - offset.y,
                z: cube.z - offset.z
            )

            if sides.contains(side) {
                sides.remove(side)
            } else {
                sides.insert(side)
            }
        }
    }

    print("Result: \(sides.count)")
}

private func two(input: String) {
    let cubes = input.components(separatedBy: "\n").map {
        Cube($0.components(separatedBy: ",").map { Int($0)! * 10 })
    }

    var sides: Set<Cube> = []
    var allSides: [Set<Cube>] = []

    let offsets = [
        Cube(x: 0, y: 5, z: 0),
        Cube(x: 0, y: -5, z: 0),
        Cube(x: 5, y: 0, z: 0),
        Cube(x: -5, y: 0, z: 0),
        Cube(x: 0, y: 0, z: 5),
        Cube(x: 0, y: 0, z: -5),
    ]

    for cube in cubes {
        var cubeSides: Set<Cube> = []
        for offset in offsets {
            let side = Cube(
                x: cube.x - offset.x,
                y: cube.y - offset.y,
                z: cube.z - offset.z
            )

            if sides.contains(side) {
                sides.remove(side)
            } else {
                sides.insert(side)
            }

            cubeSides.insert(side)
        }
        allSides.append(cubeSides)
    }

    var trapped = 0

    for allSide in allSides {
        if sides.intersection(allSide).isEmpty {
            trapped += 6
            print(allSide)
        }
    }

//    let groupped = Dictionary(grouping: allSides) { $0 }
//    print(groupped.values.map(\.count))

    print("Result: \(sides.count - trapped)")
}
