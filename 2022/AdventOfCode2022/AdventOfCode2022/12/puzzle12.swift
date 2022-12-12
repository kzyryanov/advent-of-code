//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle12() {
    print("Test")
    print("One")
    one(input: testInput12)
    print("Two")
    two(input: testInput12)

    print("")
    print("Real")
    print("One")
    one(input: input12)
    print("Two")
    two(input: input12)
}

private func one(input: String) {
    let grid = input.components(separatedBy: "\n").map { $0.map { $0 } }
    let startRow = grid.firstIndex(where: { $0.contains(where: { $0 == "S" }) })!
    let startColumn = grid[startRow].firstIndex(of: "S")!
    let endRow = grid.firstIndex(where: { $0.contains(where: { $0 == "E" }) })!
    let endColumn = grid[endRow].firstIndex(of: "E")!

    let startPosition = Position(row: startRow, column: startColumn)
    let endPosition = Position(row: endRow, column: endColumn)

    let destinationDiffs = [
        Position(row: -1, column: 0),
        Position(row: +1, column: 0),
        Position(row: 0, column: -1),
        Position(row: 0, column: +1),
    ]

    var steps = Array(repeating: Array(repeating: Int.max, count: grid.first!.count), count: grid.count)

    steps[startPosition.row][startPosition.column] = 0

    // Make start destinations
    var possibleDestinations = Set(destinationDiffs.compactMap { diff -> Position? in
        let destination = Position(
            row: startPosition.row + diff.row,
            column: startPosition.column + diff.column
        )

        guard grid.indices.contains(destination.row),
              grid[destination.row].indices.contains(destination.column) else {
            return nil // Outside of the grid
        }

        let destinationElement = grid[destination.row][destination.column]
        if destinationElement == "a" || destinationElement == "b" {
            return destination
        }

        return nil
    })

    possibleDestinations.forEach {
        steps[$0.row][$0.column] = 1
    }


    while possibleDestinations.isNotEmpty {

        let currentPosition = possibleDestinations.removeFirst()

        let newPossibleDestinations = Set(destinationDiffs.compactMap { diff -> Position? in
            let destination = Position(
                row: currentPosition.row + diff.row,
                column: currentPosition.column + diff.column
            )

            if checkDestination(currentPosition: currentPosition, destination: destination, grid: grid) {
                if steps[destination.row][destination.column] > steps[currentPosition.row][currentPosition.column] + 1 {
                    steps[destination.row][destination.column] = steps[currentPosition.row][currentPosition.column] + 1
                    return destination
                }
            }

            return nil
        })

        possibleDestinations = possibleDestinations.union(newPossibleDestinations)
    }

    print("Result: \(steps[endPosition.row][endPosition.column])")
}

private func two(input: String) {
    var grid = input.components(separatedBy: "\n").map { $0.map { $0 } }
    let startRow = grid.firstIndex(where: { $0.contains(where: { $0 == "S" }) })!
    let startColumn = grid[startRow].firstIndex(of: "S")!
    grid[startRow][startColumn] = "a" // "S" can be replaced to "a" for simplicity, it has "a" height anyway

    let endRow = grid.firstIndex(where: { $0.contains(where: { $0 == "E" }) })!
    let endColumn = grid[endRow].firstIndex(of: "E")!
    let endPosition = Position(row: endRow, column: endColumn)

    var startPositions: [Position] = []

    for (rowIndex, row) in grid.enumerated() {
        for (columnIndex, element) in row.enumerated() {
            if element == "a" {
                startPositions.append(Position(row: rowIndex, column: columnIndex))
            }
        }
    }

    print(startPositions.count)

    let results = startPositions.map { startPosition in

        let destinationDiffs = [
            Position(row: -1, column: 0),
            Position(row: +1, column: 0),
            Position(row: 0, column: -1),
            Position(row: 0, column: +1),
        ]

        var steps = Array(repeating: Array(repeating: Int.max, count: grid.first!.count), count: grid.count)

        steps[startPosition.row][startPosition.column] = 0

        // Make start destinations
        var possibleDestinations = Set(destinationDiffs.compactMap { diff -> Position? in
            let destination = Position(
                row: startPosition.row + diff.row,
                column: startPosition.column + diff.column
            )

            guard grid.indices.contains(destination.row),
                  grid[destination.row].indices.contains(destination.column) else {
                return nil // Outside of the grid
            }

            let destinationElement = grid[destination.row][destination.column]
            if destinationElement == "a" {
                return nil
            }
            if destinationElement == "b" {
                return destination
            }

            return nil
        })

        possibleDestinations.forEach {
            steps[$0.row][$0.column] = 1
        }


        while possibleDestinations.isNotEmpty {

            let currentPosition = possibleDestinations.removeFirst()

            for diff in destinationDiffs {
                let destination = Position(
                    row: currentPosition.row + diff.row,
                    column: currentPosition.column + diff.column
                )

                if checkDestination(
                    currentPosition: currentPosition,
                    destination: destination,
                    grid: grid
                ) {
                    if steps[destination.row][destination.column] > steps[currentPosition.row][currentPosition.column] + 1 {
                        steps[destination.row][destination.column] = steps[currentPosition.row][currentPosition.column] + 1
                        possibleDestinations.insert(destination)
                    }
                }
            }
        }

        return steps[endPosition.row][endPosition.column]
    }

    guard let result = results.min() else {
        print("Cannot find min path")
        return
    }
    print("Result: \(result)")
}

private func checkDestination(
    currentPosition: Position,
    destination: Position,
    grid: [[Character]]
) -> Bool {
    guard grid.indices.contains(destination.row),
          grid[destination.row].indices.contains(destination.column) else {
        return false // Outside of the grid
    }

    let destinationElement = grid[destination.row][destination.column]
    let currentElement = grid[currentPosition.row][currentPosition.column]

    if (currentElement == "z" || currentElement == "y") && destinationElement == "E" {
        return true // Reached the end
    }

    if currentElement == "S" && (destinationElement == "a" || destinationElement == "b") {
        return true
    }

    if destinationElement == "S" {
        return false
    }

    guard currentElement != "S",
          destinationElement != "E" else {
        return false
    }

    let dav = Int(destinationElement.asciiValue!)
    let cav = Int(currentElement.asciiValue!)

    if (dav - cav) <= 1 {
        return true
    }

    return false
}

private struct Position: Hashable, CustomStringConvertible {
    let row: Int
    let column: Int

    var description: String {
        "(\(row), \(column))"
    }
}
