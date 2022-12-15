//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle15() {
    print("Test")
    print("One")
    one(input: testInput15, testRow: 10)
    print("Two")
    two(input: testInput15, testRange: 0...20)

    print("")
    print("Real")
    print("One")
    one(input: input15, testRow: 2_000_000)
    print("Two")
    two(input: input15, testRange: 0...4000000)
}

private func parseSensors(input: String) -> [Coordinate: Int] {
    let sensors: [(sensor: Coordinate, distance: Int)] = input.components(separatedBy: "\n").map { line in
        let components = line.components(separatedBy: ":")
        let sensorCoordinates = components[0]
            .replacingOccurrences(of: "Sensor at ", with: "")
            .components(separatedBy: ", ")
            .map {
                $0.replacingOccurrences(of: "x=", with: "")
                    .replacingOccurrences(of: "y=", with: "")
            }
        let sensorX = Int(sensorCoordinates[0])!
        let sensorY = Int(sensorCoordinates[1])!

        let beaconCoordinates = components[1]
            .replacingOccurrences(of: " closest beacon is at ", with: "")
            .components(separatedBy: ", ")
            .map {
                $0.replacingOccurrences(of: "x=", with: "")
                    .replacingOccurrences(of: "y=", with: "")
            }

        let beaconX = Int(beaconCoordinates[0])!
        let beaconY = Int(beaconCoordinates[1])!

        let sensorCoordinate = Coordinate(x: sensorX, y: sensorY)
        let beaconCoordinate = Coordinate(x: beaconX, y: beaconY)

        return (sensorCoordinate, sensorCoordinate.distance(to: beaconCoordinate))
    }

    return Dictionary(uniqueKeysWithValues: sensors)
}

private func one(input: String, testRow: Int) {
    let sensors = parseSensors(input: input)

    var xRanges: [ClosedRange<Int>] = []

    for (coordinate, distance) in sensors {
        let yDistance = abs(testRow - coordinate.y)
        if yDistance > distance {
            continue
        }
        let xRange = (coordinate.x - (distance - yDistance))...(coordinate.x + (distance - yDistance))

        xRanges.append(xRange)
    }

    let sorted = xRanges.sorted(by: {
        $0.lowerBound < $1.lowerBound
    })

    var resultRanges: [ClosedRange<Int>] = []

    for range in sorted {
        let last = resultRanges.last
        if let union = last?.union(range) {
            resultRanges.removeLast()
            resultRanges.append(union)
        } else {
            resultRanges.append(range)
        }
    }

    print(resultRanges)
    let result = resultRanges.map { $0.upperBound - $0.lowerBound }.reduce(0, +)

    print("Result: \(result)")
}

private func two(input: String, testRange: ClosedRange<Int>) {
    let sensors = parseSensors(input: input)

    for y in testRange {
        if y % 100_000 == 0 {
            print("Calculate \(y)")
        }
        var xRanges: [ClosedRange<Int>] = []

        for (coordinate, distance) in sensors {
            let yDistance = abs(y - coordinate.y)
            if yDistance > distance {
                continue
            }
            let xRange = (coordinate.x - (distance - yDistance))...(coordinate.x + (distance - yDistance))

            xRanges.append(xRange)
        }

        let sorted = xRanges.sorted(by: {
            $0.lowerBound < $1.lowerBound
        })

        var resultRanges: [ClosedRange<Int>] = []

        for range in sorted {
            let last = resultRanges.last
            if let union = last?.union(range) {
                resultRanges.removeLast()
                resultRanges.append(union)
            } else {
                resultRanges.append(range)
            }
        }

        if resultRanges.count > 1 {
            print(resultRanges, y)
            let result = (resultRanges.first!.upperBound + 1) * 4_000_000 + y
            print("Result: \(result)")
            break
        }
    }
}

private struct Coordinate: Hashable, CustomStringConvertible {
    let x, y: Int

    func distance(to: Self) -> Int {
        abs(x - to.x) + abs(y - to.y)
    }

    var description: String {
        "(\(x), \(y))"
    }
}
