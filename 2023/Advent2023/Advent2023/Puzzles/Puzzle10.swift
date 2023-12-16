//
//  Puzzle10.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-10.
//

import SwiftUI

struct Puzzle10: View {
    let input: String

    @State private var presentInput: Bool = false

    @State private var isSolving: Bool = false
    @State private var answerFirst: Int?
    @State private var answerSecond: Int?

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    if let answerFirst {
                        Text("Result 1: ").font(.headline) +
                        Text("\(answerFirst)")
                    }
                    if let answerSecond {
                        Text("Result 2: ").font(.headline) +
                        Text("\(answerSecond)")
                    }
                }
                .padding()
            }
            Button(
                action: {
                    Task {
                        let clock = ContinuousClock()
                        let result1 = await clock.measure {
                            await solveFirst()
                        }
                        print("Result 1: \(result1)")
                        let result2 = await clock.measure {
                            await solveSecond()
                        }
                        print("Result 2: \(result2)")
                    }
                },
                label: {
                    Image(systemName: "figure.run.circle")
                    Text("Solve")
                }
            )
            .font(.largeTitle)
            .disabled(isSolving)
            .padding()
        }
        .overlay {
            if isSolving {
                ProgressView()
            }
        }
        .toolbar {
            Button(
                action: { presentInput.toggle() },
                label: { Image(systemName: "doc") }
            )
        }
        .sheet(isPresented: $presentInput) {
            NavigationView {
                ScrollView {
                    Text(input)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .navigationTitle("Input")
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Button(
                            action: { presentInput.toggle() },
                            label: { Image(systemName: "xmark.circle") }
                        )
                    }
                }
            }
        }
    }

    private func solveFirst() async {
        answerFirst = nil
        isSolving = true
        defer {
            isSolving = false
        }

        var startingPoint: Point?

        let map: [Point: Pipe] = Dictionary(uniqueKeysWithValues: input.components(separatedBy: .newlines).filter(\.isNotEmpty).enumerated().flatMap { (row, line) in
            line.enumerated().compactMap { column, character -> (Point, Pipe)? in
                let point = Point(x: column, y: row)
                switch character {
                case "S":
                    startingPoint = point
                    return nil
                case ".":
                    return nil
                default:
                    let pipe = Pipe(rawValue: character)
                    return pipe.map { (point, $0) }
                }
            }
        })

        guard let startingPoint else {
            assertionFailure("No starting point")
            return
        }

        var path = [startingPoint]
        let possibleDirections = Direction.allCases.filter { direction in
            guard let pipe = map[startingPoint.location(for: direction)],
                  pipe.directions.contains(direction.opposite) else {
                return false
            }
            return true
        }

        guard var nextDirection = possibleDirections.first, possibleDirections.count == 2 else {
            assertionFailure("Cannot find next movement from starting point")
            return
        }

        repeat {
            guard let point = path.last else {
                assertionFailure("Something went wrong")
                return
            }
            let newLocation = point.location(for: nextDirection)
            path.append(newLocation)
            if newLocation == startingPoint {
                break
            }
            guard let pipe = map[newLocation], let exit = pipe.exit(from: nextDirection)  else {
                assertionFailure("Something went wrong")
                return
            }
            nextDirection = exit
        } while path.last != path.first

        let result = Int(ceil(Double(path.count / 2)))

        await MainActor.run {
            print("Result 1: \(result)")
            answerFirst = result
        }
    }

    fileprivate func extractedFunc(_ groundTiles: inout Set<Point>, _ left: Point, _ loopMap: [Point : Pipe], _ size: Point, _ skipLefts: inout Bool, _ lefts: inout Set<Point>) {
        if let tile = groundTiles.remove(left) {
            var adjacent = Set(Direction.allCases.map {
                tile.location(for: $0)
            }).filter({ loopMap[$0] == nil })
            lefts.insert(left)
            while adjacent.isNotEmpty {
                let adj = adjacent.removeFirst()
                guard adj.x > 0, adj.x < size.x, adj.y > 0, adj.y < size.y else {
                    skipLefts = true
                    break
                }
                lefts.insert(adj)
                groundTiles.remove(adj)
                Direction.allCases.forEach { direction in
                    let point = adj.location(for: direction)
                    if nil == loopMap[point], groundTiles.contains(point) {
                        adjacent.insert(point)
                    }
                }
            }
        }
    }
    
    private func solveSecond() async {
        answerSecond = nil
        isSolving = true
        defer {
            isSolving = false
        }

        var startingPoint: Point?

        var size: Point?

        let map: [Point: Pipe] = Dictionary(uniqueKeysWithValues: input.components(separatedBy: .newlines).filter(\.isNotEmpty).enumerated().flatMap { (row, line) in
            line.enumerated().compactMap { column, character -> (Point, Pipe)? in
                let point = Point(x: column, y: row)
                size = Point(x: column + 1, y: row + 1)
                switch character {
                case "S":
                    startingPoint = point
                    return nil
                case ".":
                    return nil
                default:
                    let pipe = Pipe(rawValue: character)
                    return pipe.map { (point, $0) }
                }
            }
        })

        guard let startingPoint else {
            assertionFailure("No starting point")
            return
        }

        let possibleDirections = Direction.allCases.filter { direction in
            guard let pipe = map[startingPoint.location(for: direction)],
                  pipe.directions.contains(direction.opposite) else {
                return false
            }
            return true
        }

        guard let nextDirection = possibleDirections.first, possibleDirections.count == 2 else {
            assertionFailure("Cannot find next movement from starting point")
            return
        }
        var path: [(point: Point, direction: Direction)] = [(startingPoint, nextDirection)]

        repeat {
            guard let point = path.last else {
                assertionFailure("Something went wrong")
                return
            }
            let newLocation = point.point.location(for: point.direction)
            if newLocation == startingPoint {
                break
            }
            guard let pipe = map[newLocation], let exit = pipe.exit(from: point.direction) else {
                assertionFailure("Something went wrong")
                return
            }
            path.append((newLocation, exit))
        } while path.last?.point != path.first?.point

        var loopMap = Dictionary(uniqueKeysWithValues: path.compactMap { point in
            map[point.point].map { (point.point, $0) }
        })

        loopMap[startingPoint] = Pipe.allCases.first { pipe in
            pipe.directions == Set(possibleDirections)
        }

        guard let size else {
            assertionFailure("Something when wrong")
            return
        }

        var pipeTiles = Set(loopMap.keys)

        var groundTiles = Set((0...size.y).flatMap { row in
            (0...size.x).compactMap { column -> Point? in
                let tile = Point(x: column, y: row)
                if nil != pipeTiles.remove(tile) {
                    return nil
                }
                return tile
            }
        })

        var lefts: Set<Point> = []
        var rights: Set<Point> = []

        var skipLefts: Bool = false
        var skipRights: Bool = false

        for point in path {
            guard let pipe = loopMap[point.point] else {
                assertionFailure("Something went wrong")
                return
            }
            switch pipe {
            case .horizontal:
                if point.direction == .east {
                    if !skipLefts {
                        let left = Point(x: point.point.x, y: point.point.y - 1)
                        if left.y < 0 {
                            skipLefts = true
                        } else {
                            extractedFunc(&groundTiles, left, loopMap, size, &skipLefts, &lefts)
                        }
                    }
                    if !skipRights {
                        let right = Point(x: point.point.x, y: point.point.y + 1)
                        if right.y >= size.y {
                            skipRights = true
                        } else {
                            extractedFunc(&groundTiles, right, loopMap, size, &skipRights, &rights)
                        }
                    }
                }
                if point.direction == .west {
                    if !skipLefts {
                        let left = Point(x: point.point.x, y: point.point.y + 1)
                        if left.y < 0 {
                            skipLefts = true
                        } else {
                            extractedFunc(&groundTiles, left, loopMap, size, &skipLefts, &lefts)
                        }
                    }
                    if !skipRights {
                        let right = Point(x: point.point.x, y: point.point.y - 1)
                        if right.y >= size.y {
                            skipRights = true
                        } else {
                            extractedFunc(&groundTiles, right, loopMap, size, &skipRights, &rights)
                        }
                    }
                }
            case .vertical:
                if point.direction == .north {
                    if !skipLefts {
                        let left = Point(x: point.point.x - 1, y: point.point.y)
                        if left.y < 0 {
                            skipLefts = true
                        } else {
                            extractedFunc(&groundTiles, left, loopMap, size, &skipLefts, &lefts)
                        }
                    }
                    if !skipRights {
                        let right = Point(x: point.point.x + 1, y: point.point.y)
                        if right.y >= size.y {
                            skipRights = true
                        } else {
                            extractedFunc(&groundTiles, right, loopMap, size, &skipRights, &rights)
                        }
                    }
                }
                if point.direction == .south {
                    if !skipLefts {
                        let left = Point(x: point.point.x + 1, y: point.point.y)
                        if left.y < 0 {
                            skipLefts = true
                        } else {
                            extractedFunc(&groundTiles, left, loopMap, size, &skipLefts, &lefts)
                        }
                    }
                    if !skipRights {
                        let right = Point(x: point.point.x - 1, y: point.point.y)
                        if right.y >= size.y {
                            skipRights = true
                        } else {
                            extractedFunc(&groundTiles, right, loopMap, size, &skipRights, &rights)
                        }
                    }
                }
            case .f:
                if point.direction == .east {
                    if !skipLefts {
                        let leftPoints = [
                            Point(x: point.point.x - 1, y: point.point.y),
                            Point(x: point.point.x - 1, y: point.point.y - 1),
                            Point(x: point.point.x, y: point.point.y - 1),
                        ]
                        for left in leftPoints {
                            if left.y < 0 || left.x < 0 {
                                skipLefts = true
                            } else {
                                extractedFunc(&groundTiles, left, loopMap, size, &skipLefts, &lefts)
                            }
                        }
                    }
                }
                if point.direction == .south {
                    if !skipRights {
                        let rightPoints = [
                            Point(x: point.point.x - 1, y: point.point.y),
                            Point(x: point.point.x - 1, y: point.point.y - 1),
                            Point(x: point.point.x, y: point.point.y - 1),
                        ]
                        for right in rightPoints {
                            if right.y < 0 || right.x < 0 {
                                skipRights = true
                            } else {
                                extractedFunc(&groundTiles, right, loopMap, size, &skipRights, &rights)
                            }
                        }
                    }
                }
            case .j:
                if point.direction == .west {
                    if !skipLefts {
                        let leftPoints = [
                            Point(x: point.point.x, y: point.point.y + 1),
                            Point(x: point.point.x + 1, y: point.point.y + 1),
                            Point(x: point.point.x + 1, y: point.point.y),
                        ]
                        for left in leftPoints {
                            if left.y >= size.y || left.x >= size.x {
                                skipLefts = true
                            } else {
                                extractedFunc(&groundTiles, left, loopMap, size, &skipLefts, &lefts)
                            }
                        }
                    }
                }
                if point.direction == .north {
                    if !skipRights {
                        let rightPoints = [
                            Point(x: point.point.x, y: point.point.y + 1),
                            Point(x: point.point.x + 1, y: point.point.y + 1),
                            Point(x: point.point.x + 1, y: point.point.y),
                        ]
                        for right in rightPoints {
                            if right.y >= size.y || right.x >= size.x {
                                skipRights = true
                            } else {
                                extractedFunc(&groundTiles, right, loopMap, size, &skipRights, &rights)
                            }
                        }
                    }
                }
            case .l:
                if point.direction == .north {
                    if !skipLefts {
                        let leftPoints = [
                            Point(x: point.point.x - 1, y: point.point.y),
                            Point(x: point.point.x - 1, y: point.point.y - 1),
                            Point(x: point.point.x, y: point.point.y - 1),
                        ]
                        for left in leftPoints {
                            if left.y >= size.y || left.x < 0 {
                                skipLefts = true
                            } else {
                                extractedFunc(&groundTiles, left, loopMap, size, &skipLefts, &lefts)
                            }
                        }
                    }
                }
                if point.direction == .east {
                    if !skipRights {
                        let rightPoints = [
                            Point(x: point.point.x - 1, y: point.point.y),
                            Point(x: point.point.x - 1, y: point.point.y - 1),
                            Point(x: point.point.x, y: point.point.y - 1),
                        ]
                        for right in rightPoints {
                            if right.y >= size.y || right.x >= size.x {
                                skipRights = true
                            } else {
                                extractedFunc(&groundTiles, right, loopMap, size, &skipRights, &rights)
                            }
                        }
                    }
                }
            case .seven:
                if point.direction == .south {
                    if !skipLefts {
                        let leftPoints = [
                            Point(x: point.point.x, y: point.point.y - 1),
                            Point(x: point.point.x + 1, y: point.point.y - 1),
                            Point(x: point.point.x + 1, y: point.point.y),
                        ]
                        for left in leftPoints {
                            if left.y < 0 || left.x >= size.x {
                                skipLefts = true
                            } else {
                                extractedFunc(&groundTiles, left, loopMap, size, &skipLefts, &lefts)
                            }
                        }
                    }
                }
                if point.direction == .west {
                    if !skipRights {
                        let rightPoints = [
                            Point(x: point.point.x, y: point.point.y - 1),
                            Point(x: point.point.x + 1, y: point.point.y - 1),
                            Point(x: point.point.x + 1, y: point.point.y),
                        ]
                        for right in rightPoints {
                            if right.y >= size.y || right.x >= size.x {
                                skipRights = true
                            } else {
                                extractedFunc(&groundTiles, right, loopMap, size, &skipRights, &rights)
                            }
                        }
                    }
                }
            }
        }

        guard !skipLefts || !skipRights else {
            assertionFailure("Something went wrong")
            return
        }

        let result = skipLefts ? rights.count : lefts.count

        await MainActor.run {
            print("Result 2: \(result)")
            answerSecond = result
        }
    }
}

private enum Pipe: Character, CaseIterable {
    case vertical = "|"
    case horizontal = "-"
    case l = "L"
    case j = "J"
    case seven = "7"
    case f = "F"

    var intersectionsCount: Int {
        switch self {
        case .horizontal, .vertical: return 1
        default: return 2
        }
    }

    var directions: Set<Direction> {
        switch self {
        case .vertical: return [.north, .south]
        case .horizontal: return [.east, .west]
        case .l: return [.north, .east]
        case .j: return [.north, .west]
        case .seven: return [.south, .west]
        case .f: return [.south, .east]
        }
    }

    func exit(from direction: Direction) -> Direction? {
        let opposite = direction.opposite
        var directions = self.directions
        guard nil != directions.remove(opposite) else {
            return nil
        }

        return directions.first
    }
}

#Preview {
    Puzzle10(input: Input.puzzle10.testInput)
}
