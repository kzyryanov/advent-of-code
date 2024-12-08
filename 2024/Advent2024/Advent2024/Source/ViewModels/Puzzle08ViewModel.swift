//
//  Puzzle08ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-08.
//

import SwiftUI

@Observable
final class Puzzle08ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String) async -> String {
        let (antennas, mapSize) = data(from: input)

        let rect = Rect(origin: .zero, size: mapSize)

        var antinodes: Set<Point> = []

        for (_, locations) in antennas {
            for i in 0..<(locations.count - 1) {
                for j in i+1..<locations.count {
                    let one = locations[i]
                    let two = locations[j]

                    let antinode1 = Point(
                        x: two.x + (two.x - one.x),
                        y: two.y + (two.y - one.y)
                    )

                    let antinode2 = Point(
                        x: one.x - (two.x - one.x),
                        y: one.y - (two.y - one.y)
                    )

                    if rect.isPointInside(antinode1) {
                        antinodes.insert(antinode1)
                    }
                    if rect.isPointInside(antinode2) {
                        antinodes.insert(antinode2)
                    }
                }
            }
        }

        let result = antinodes.count

        return "\(result)"
    }

    func printMap(antnodes: Set<Point>, size: Size) {
        for y in 0..<size.height {
            for x in 0..<size.width {
                let point = Point(x: x, y: y)
                if antnodes.contains(point) {
                    print("#", terminator: "")
                } else {
                    print(".", terminator: "")
                }
            }
            print("")
        }
    }

    func solveTwo(input: String) async -> String {
        let (antennas, mapSize) = data(from: input)

        let rect = Rect(origin: .zero, size: mapSize)

        var antinodes: Set<Point> = []

        for (_, locations) in antennas {
            for i in 0..<(locations.count - 1) {
                for j in i+1..<locations.count {
                    let one = locations[i]
                    let two = locations[j]

                    let diffX = (two.x - one.x)
                    let diffY = (two.y - one.y)

                    var i = 0
                    while true {
                        let antinode = Point(
                            x: two.x + diffX * i,
                            y: two.y + diffY * i
                        )
                        i += 1
                        if rect.isPointInside(antinode) {
                            antinodes.insert(antinode)
                        } else {
                            break
                        }
                    }

                    i = 0
                    while true {
                        let antinode = Point(
                            x: one.x - diffX * i,
                            y: one.y - diffY * i
                        )
                        i += 1
                        if rect.isPointInside(antinode) {
                            antinodes.insert(antinode)
                        } else {
                            break
                        }
                    }
                }
            }
        }

        printMap(antnodes: antinodes, size: mapSize)

        let result = antinodes.count

        return "\(result)"
    }

    func data(from input: String) -> (antennas: [Character: [Point]], mapSize: Size) {
        let lines = input.lines.filter(\.isNotEmpty)

        var size: Size = .zero
        var antennas: [Character: [Point]] = [:]

        for (y, line) in lines.enumerated() {
            for (x, character) in line.enumerated() {
                if character != "." {
                    var locations = antennas[character, default: []]
                    locations.append(Point(x: x, y: y))
                    antennas[character] = locations
                }
                size.width = max(size.width, x + 1)
            }
            size.height = max(size.height, y + 1)
        }

        return (antennas, size)
    }
}
