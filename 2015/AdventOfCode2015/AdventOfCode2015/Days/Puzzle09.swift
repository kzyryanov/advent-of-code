//
//  Puzzle09.swift
//  AdventOfCode2015
//
//  Created by Konstantin Zyrianov on 2023-12-14.
//

import SwiftUI

struct Puzzle09: View {
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

        let regex = /(?<from>.*?) to (?<to>.*?) = (?<distance>.*?)/

        let edges: [Set<String>: Int] = Dictionary(uniqueKeysWithValues: input.components(separatedBy: .newlines).filter(\.isNotEmpty).map { line -> (Set<String>, Int) in
            let match = try! regex.wholeMatch(in: line)
            let from = String(match!.from)
            let to = String(match!.to)
            let distance = Int(String(match!.distance))!

            return ([from, to], distance)
        })

        let vertices: Set<String> = Set(edges.keys.flatMap { $0 })

        func pathLength(path: [String]) -> Int {
            let value: (distance: Int, from: String?) = path.reduce((0, nil), {
                guard let from = $0.from else {
                    return (0, $1)
                }
                let distance = edges[[from, $1], default: 0]
                return ($0.distance + distance, $1)
            })
            return value.distance
        }

        func buildPaths(path: [String], notVisited: Set<String>) -> [[String]] {
            guard notVisited.isNotEmpty else {
                return [path]
            }

            var newPaths: [[String]] = []
            notVisited.forEach { city in
                var newNotVisited = notVisited
                newNotVisited.remove(city)
                let builtPaths = buildPaths(path: path + [city], notVisited: newNotVisited)
                newPaths.append(contentsOf: builtPaths)
            }

            return newPaths
        }

        let paths = buildPaths(path: [], notVisited: vertices)

        let distances = paths.map(pathLength)

        let result = distances.min()!

        await MainActor.run {
            print("Result 1: \(result)")
            answerFirst = result
        }
    }

    private func solveSecond() async {
        answerSecond = nil

        let regex = /(?<from>.*?) to (?<to>.*?) = (?<distance>.*?)/

        let edges: [Set<String>: Int] = Dictionary(uniqueKeysWithValues: input.components(separatedBy: .newlines).filter(\.isNotEmpty).map { line -> (Set<String>, Int) in
            let match = try! regex.wholeMatch(in: line)
            let from = String(match!.from)
            let to = String(match!.to)
            let distance = Int(String(match!.distance))!

            return ([from, to], distance)
        })

        let vertices: Set<String> = Set(edges.keys.flatMap { $0 })

        func pathLength(path: [String]) -> Int {
            let value: (distance: Int, from: String?) = path.reduce((0, nil), {
                guard let from = $0.from else {
                    return (0, $1)
                }
                let distance = edges[[from, $1], default: 0]
                return ($0.distance + distance, $1)
            })
            return value.distance
        }

        func buildPaths(path: [String], notVisited: Set<String>) -> [[String]] {
            guard notVisited.isNotEmpty else {
                return [path]
            }

            var newPaths: [[String]] = []
            notVisited.forEach { city in
                var newNotVisited = notVisited
                newNotVisited.remove(city)
                let builtPaths = buildPaths(path: path + [city], notVisited: newNotVisited)
                newPaths.append(contentsOf: builtPaths)
            }

            return newPaths
        }

        let paths = buildPaths(path: [], notVisited: vertices)

        let distances = paths.map(pathLength)

        let result = distances.max()!

        await MainActor.run {
            print("Result 2: \(result)")
            answerSecond = result
        }
    }
}

#Preview {
    Puzzle09(input: Input.puzzle09.testInput)
}
