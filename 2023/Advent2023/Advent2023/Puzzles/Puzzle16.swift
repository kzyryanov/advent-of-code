//
//  Puzzle16.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-16.
//

import SwiftUI

struct Puzzle16: View {
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
                        isSolving = true
                        defer {
                            isSolving = false
                        }
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

        let (map, size) = Self.parse(input: input)

        let result = solve(
            map: map,
            size: size,
            startingRay: Ray(
                location: Point(x: -1, y: 0),
                direction: .east
            )
        )

        await MainActor.run {
            print("Result 1: \(result)")
            answerFirst = result
        }
    }

    private func solveSecond() async {
        answerSecond = nil

        let (map, size) = Self.parse(input: input)

        let result = await withTaskGroup(of: Int.self) { group in
            Direction.allCases.forEach { direction in
                switch direction {
                case .north:
                    (0..<size.width).forEach { x in
                        group.addTask {
                            solve(
                                map: map,
                                size: size,
                                startingRay: Ray(location: Point(x: x, y: size.height), direction: .north)
                            )
                        }
                    }
                case .south:
                    (0..<size.width).forEach { x in
                        group.addTask {
                            solve(
                                map: map,
                                size: size,
                                startingRay: Ray(location: Point(x: x, y: -1), direction: .south)
                            )
                        }
                    }
                case .east:
                    (0..<size.height).forEach { y in
                        group.addTask {
                            solve(
                                map: map,
                                size: size,
                                startingRay: Ray(location: Point(x: -1, y: y), direction: .east)
                            )
                        }
                    }
                case .west:
                    (0..<size.height).forEach { y in
                        group.addTask {
                            solve(
                                map: map,
                                size: size,
                                startingRay: Ray(location: Point(x: size.width, y: y), direction: .west)
                            )
                        }
                    }
                }
            }
            return await group.max() ?? -1
        }

        await MainActor.run {
            print("Result 2: \(result)")
            answerSecond = result
        }
    }

    private static func parse(input: String) -> (map: [Point: Object], size: Size) {
        var size: Size = .zero
        let map: [Point: Object] = Dictionary(uniqueKeysWithValues: input.components(separatedBy: .newlines).filter(\.isNotEmpty).enumerated().flatMap { row, line in
            size.height = row + 1
            return line.enumerated().compactMap { column, character -> (Point, Object)? in
                size.width = column + 1
                guard let object = Object(rawValue: character) else {
                    return nil
                }
                return (Point(x: column, y: row), object)
            }
        })

        return (map, size)
    }

    private static func printMap(_ map: [Point: Object], ofSize size: Size) {
        for row in 0..<size.height {
            for column in 0..<size.width {
                let object = map[Point(x: column, y: row)]
                if let object {
                    print(object, terminator: "")
                } else {
                    print(".", terminator: "")
                }
            }
            print("")
        }
    }

    private func solve(map: [Point: Object], size: Size, startingRay: Ray) -> Int {
        var energizedPoints: [Point: Set<Direction>] = [:]

        var rays: Set<Ray> = [startingRay]

        while rays.isNotEmpty {
            let ray = rays.removeFirst()
            let newLocation = ray.location.location(for: ray.direction)
            guard size.isPointInside(newLocation) else {
                continue // Outside of the map
            }
            var energized = energizedPoints[newLocation, default: []]
            guard !energized.contains(ray.direction) else {
                continue // was energized with the same direction, can skip ray
            }
            energized.insert(ray.direction)
            energizedPoints[newLocation] = energized
            let movedRay = Ray(
                location: newLocation,
                direction: ray.direction
            )
            if let object = map[newLocation] {
                let newRays = object.rays(for: movedRay)
                newRays.forEach { rays.insert($0) }
            } else {
                rays.insert(movedRay)
            }
        }

        return energizedPoints.count
    }
}

private enum Object: Character, CustomStringConvertible {
    case mirrorLeft = "\\"
    case mirrorRight = "/"
    case splitterHorizontal = "-"
    case splitterVertical = "|"

    var description: String {
        String(rawValue)
    }

    func rays(for ray: Ray) -> [Ray] {
        switch self {
        case .mirrorLeft:
            switch ray.direction {
            case .north:
                return [Ray(location: ray.location, direction: .west)]
            case .west:
                return [Ray(location: ray.location, direction: .north)]
            case .south:
                return [Ray(location: ray.location, direction: .east)]
            case .east:
                return [Ray(location: ray.location, direction: .south)]
            }
        case .mirrorRight:
            switch ray.direction {
            case .north:
                return [Ray(location: ray.location, direction: .east)]
            case .west:
                return [Ray(location: ray.location, direction: .south)]
            case .south:
                return [Ray(location: ray.location, direction: .west)]
            case .east:
                return [Ray(location: ray.location, direction: .north)]
            }
        case .splitterHorizontal:
            switch ray.direction {
            case .north, .south:
                return [
                    Ray(location: ray.location, direction: .west),
                    Ray(location: ray.location, direction: .east)
                ]
            case .west, .east:
                return [ray]
            }
        case .splitterVertical:
            switch ray.direction {
            case .east, .west:
                return [
                    Ray(location: ray.location, direction: .north),
                    Ray(location: ray.location, direction: .south)
                ]
            case .north, .south:
                return [ray]
            }
        }
    }
}

struct Ray: Hashable {
    let location: Point
    let direction: Direction
}

#Preview {
    Puzzle16(input: Input.puzzle16.testInput)
}
