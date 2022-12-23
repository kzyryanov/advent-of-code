//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle17() {
    print("Test")
    print("One")
    one(input: testInput17)
    print("Two")
    two(input: testInput17)

    print("")
    print("Real")
    print("One")
    one(input: input17)
    print("Two")
    two(input: input17)
}

private enum Shape: CaseIterable {
    case hStick
    case cross
    case l
    case vStick
    case cube

    var points: [Coordinate] {
        switch self {
        case .hStick:
            return [
                Coordinate(x: 0, y: 0),
                Coordinate(x: 1, y: 0),
                Coordinate(x: 2, y: 0),
                Coordinate(x: 3, y: 0)
            ]
        case .cross:
            return [
                Coordinate(x: 1, y: 0),
                Coordinate(x: 0, y: 1),
                Coordinate(x: 1, y: 1),
                Coordinate(x: 2, y: 1),
                Coordinate(x: 1, y: 2),
            ]
        case .l:
            return [
                Coordinate(x: 0, y: 0),
                Coordinate(x: 1, y: 0),
                Coordinate(x: 2, y: 0),
                Coordinate(x: 2, y: 1),
                Coordinate(x: 2, y: 2),
            ]
        case .vStick:
            return [
                Coordinate(x: 0, y: 0),
                Coordinate(x: 0, y: 1),
                Coordinate(x: 0, y: 2),
                Coordinate(x: 0, y: 3)
            ]
        case .cube:
            return [
                Coordinate(x: 0, y: 0),
                Coordinate(x: 0, y: 1),
                Coordinate(x: 1, y: 0),
                Coordinate(x: 1, y: 1)
            ]
        }
    }
}

private struct Coordinate: Hashable, CustomStringConvertible {
    let x, y: Int

    static var zero: Coordinate { Coordinate(x: 0, y: 0) }

    var description: String {
        "(\(x), \(y))"
    }

    func offset(_ coordinate: Coordinate) -> Coordinate {
        Coordinate(x: x + coordinate.x, y: y + coordinate.y)
    }
}
private func one(input: String) {
    solve(input: input, rocksCount: 2022)
}

private struct PatternKey: Hashable {
    let jet: Int
    let pattern: [Int]
}

private func solve(input: String, rocksCount: Int) {
    let jets = Array(input)
    let jetCount = input.count
    let width = 7
    let widthRange = 0..<width
    var maxHeights = Array(repeating: 0, count: width)
    var rockMap: [Coordinate: Bool] = [:]
    let shapesCount = Shape.allCases.count
    var jetIndex = 0

    let fallOffset = Coordinate(x: 0, y: -1)

    var patterns: Set<[Int]> = []
    var patternIndices: [PatternKey: (minPatternHeight: Int, index: Int, jetIndex: Int)] = [:]

    var foundRepeatingPattern = false

    var index = 0
    while index < rocksCount {
        let rockIndex = index % shapesCount
        let rock = Shape.allCases[rockIndex]
        let rockHeight = maxHeights.max()! + 3
        let offset = Coordinate(x: 2, y: rockHeight)

        var points = rock.points.map { $0.offset(offset) }

        var resting = false
        while !resting {
            let jet = jets[jetIndex]
            jetIndex = (jetIndex + 1) % jetCount

            let jetOffset = jetOffset(jet)
            var movedPoints: [Coordinate] = []
            var movedByJet = true
            for point in points {
                let movedPoint = point.offset(jetOffset)
                if !widthRange.contains(movedPoint.x) || rockMap[movedPoint, default: false] {
                    movedByJet = false
                    break
                }
                movedPoints.append(movedPoint)
            }
            if movedByJet {
                points = movedPoints
            }

            var feltPoints: [Coordinate] = []
            for point in points {
                let feltPoint = point.offset(fallOffset)
                if rockMap[feltPoint, default: false] || feltPoint.y < 0 {
                    resting = true
                    break
                }
                feltPoints.append(feltPoint)
            }
            if !resting {
                points = feltPoints
            }

            if resting {
                var maxHeightsChanged = false
                points.forEach { point in
                    rockMap[point] = true
                    let newMaxHeight = max(maxHeights[point.x], point.y + 1)
                    if newMaxHeight != maxHeights[point.x] {
                        maxHeights[point.x] = newMaxHeight
                        maxHeightsChanged = true
                    }
                }
                if maxHeightsChanged && !foundRepeatingPattern {
                    let minMaxHeight = maxHeights.min()!
                    let pattern = maxHeights.map { $0 - minMaxHeight }
                    if patterns.contains(pattern), let value = patternIndices[PatternKey(jet: jetIndex, pattern: pattern)] {
                        let (minPatternHeight, patternIndex, patternJetIndex) = value
                        if (index - patternIndex) % shapesCount == 0 {
                            print("Found repeating pattern")
                            foundRepeatingPattern = true
                            print(minPatternHeight, patternIndex, patternJetIndex)
                            print(Shape.allCases.count, index, jetCount, jetIndex, pattern)
                            let minIndex = patternIndex
                            let maxIndex = index
                            let indexDiff = maxIndex - minIndex
                            let minTowerDiff = minPatternHeight
                            let maxTowerDiff = minMaxHeight
                            let towerHeightDiff = maxTowerDiff - minTowerDiff
                            let patternsCount = (rocksCount - minIndex) / indexDiff
                            let towerHeight = minTowerDiff + towerHeightDiff * patternsCount
                            maxHeights = pattern.enumerated().map { (index, patternHeight) in
                                let height = towerHeight + patternHeight
                                rockMap[Coordinate(x: index, y: height - 1)] = true
                                return height
                            }
                            let testPattern = maxHeights.map { $0 - towerHeight }
                            print(testPattern)
                            index = minIndex + indexDiff * patternsCount
                            print(maxHeights, index)
                        }
                    }
                    patterns.insert(pattern)
                    patternIndices[PatternKey(jet: jetIndex, pattern: pattern)] = (minMaxHeight, index, jetIndex)
                }
            }
        }
        index += 1
    }

    let result = maxHeights.max()!

    print("Result: \(result)")
}

private func jetOffset(_ jet: Character) -> Coordinate {
    switch jet {
    case "<": return Coordinate(x: -1, y: 0)
    case ">": return Coordinate(x: 1, y: 0)
    default: return Coordinate.zero
    }
}

private func two(input: String) {
    solve(input: input, rocksCount: 1_000_000_000_000)
}
