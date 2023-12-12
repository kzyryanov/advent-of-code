//
//  Puzzle12.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-12.
//

import SwiftUI

struct Puzzle12: View {
    let input: String

    @State private var presentInput: Bool = false

    @State private var isSolving: Bool = false
    @State private var answerFirst: Int?
    @State private var answerSecond: Int?

    @State private var solvingIndices: Set<Int> = []
    @State private var total: Int = 0
    @State private var solved: Set<Int> = []

    var body: some View {
        VStack {
            ScrollView {
                if isSolving {
                    VStack {
                        Text("Solving \(solved.count)/\(total)")
                        LazyVGrid(columns: [.init(), .init(), .init()]) {
                            ForEach(solvingIndices.sorted(by: <), id: \.self) {
                                Text("\($0)")
                            }
                        }
                    }
                }

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
                    semaphore.wait()
                    globalCache = [:]
                    semaphore.signal()
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

        let springs: [(scheme: [Character], lengths: [Int])] = input.components(separatedBy: .newlines).filter(\.isNotEmpty).map { line in
            let components = line.components(separatedBy: .whitespaces)
            let scheme = components.first!
            let lenghts = components.last!.components(separatedBy: ",").map { Int($0)! }

            return (Array(scheme), lenghts)
        }

        let result = springs.map{
            let res = countSolutions(scheme: $0.scheme, lengths: $0.lengths)
            print(String($0.scheme), $0.lengths, res)
            return res
        }.reduce(0, +)

        await MainActor.run {
            print("Result 1: \(result)")
            answerFirst = result
        }
    }

    private func solveSecond() async {
        answerSecond = nil

        let springs: [(scheme: [Character], lengths: [Int])] = input.components(separatedBy: .newlines).filter(\.isNotEmpty).map { line in
            let components = line.components(separatedBy: .whitespaces)
            let scheme = components.first!
            let lenghts = components.last!.components(separatedBy: ",").map { Int($0)! }

            let unarchivedScheme = Array(repeating: scheme, count: 5).joined(separator: "?")
            let unarchivedLength = Array(repeating: lenghts, count: 5).flatMap { $0 }

            return (Array(unarchivedScheme), unarchivedLength)
        }

        total = springs.count

        let result = await withTaskGroup(of: Int.self) { group in
            for (index, spring) in springs.enumerated() {
                group.addTask {
                    count(index: index, spring: spring)
                }
            }

            return await group.reduce(0, +)
        }

        await MainActor.run {
            print("Result 2: \(result)")
            answerSecond = result
        }
    }

    private func count(index: Int, spring: (scheme: [Character], lengths: [Int])) -> Int {
        DispatchQueue.main.async {
            solvingIndices.insert(index)
        }
        print(String(spring.scheme), spring.lengths)
        let result = countSolutions(scheme: spring.scheme, lengths: spring.lengths)
        print("Solved", String(spring.scheme), spring.lengths, result)

        DispatchQueue.main.async {
            solvingIndices.remove(index)
            solved.insert(index)
        }
        return result
    }

    private static func chacheKey(scheme: [Character], lengths: [Int]) -> String {
        String(scheme)+lengths.map({ String($0) }).joined(separator: ",")
    }

    private func countSolutions(scheme: [Character], lengths: [Int]) -> Int {
        let cacheKey = Self.chacheKey(scheme: scheme, lengths: lengths)

        semaphore.wait()
        defer { semaphore.signal() }
        if let chached = globalCache[cacheKey] {
            return chached
        }
        semaphore.signal()
        if lengths.isEmpty {
            if scheme.allSatisfy({ $0 != "#" }) {
                semaphore.wait()
                globalCache[cacheKey] = 1
                return 1
            } else {
                semaphore.wait()
                globalCache[cacheKey] = 0
                return 0
            }
        }

        if lengths.isNotEmpty && scheme.allSatisfy({ $0 == "." }) {
            semaphore.wait()
            globalCache[cacheKey] = 0
            return 0
        }

        if lengths == [1] {
            let onlyDamaged = scheme.filter({ $0 == "#" })
            if onlyDamaged.count == 1 {
                semaphore.wait()
                globalCache[cacheKey] = 1
                return 1
            }
            if onlyDamaged.count > 1 {
                semaphore.wait()
                globalCache[cacheKey] = 0
                return 0
            }
            let res = scheme.filter({ $0 == "?" }).count
            semaphore.wait()
            globalCache[cacheKey] = res
            return res
        }

        let scheme = Array(scheme.drop(while: { $0 == "." }))

        let length = lengths.first!

        let totalLength = lengths.reduce(0, +)
        let totalLengthWithSpaces = totalLength + (lengths.count - 1)
        let totalSymbols = scheme.filter({ $0 != "." }).count

        if scheme.isEmpty || totalLength > totalSymbols || totalLengthWithSpaces > scheme.count {
            semaphore.wait()
            globalCache[cacheKey] = 0
            return 0
        }

        if scheme.first == "#" {
            var index = 0
            while index < length && index < scheme.count {
                if scheme[index] == "." {
                    semaphore.wait()
                    globalCache[cacheKey] = 0
                    return 0
                }
                index += 1
            }
            if index != length || (index < scheme.count && scheme[index] == "#") {
                semaphore.wait()
                globalCache[cacheKey] = 0
                return 0
            }
            let res = countSolutions(
                scheme: Array(scheme.dropFirst(index+1)),
                lengths: Array(lengths.dropFirst())
            )
            semaphore.wait()
            globalCache[cacheKey] = res
            return res
        }

        let questionToOperated = Array(scheme.dropFirst())
        var questionToDamaged = Array(scheme)
        questionToDamaged[0] = "#"

        let res = countSolutions(scheme: questionToOperated, lengths: lengths) + countSolutions(scheme: questionToDamaged, lengths: lengths)
        semaphore.wait()
        globalCache[cacheKey] = res

        return res
    }
}

let semaphore = DispatchSemaphore(value: 1)
var globalCache: [String: Int] = [:]

#Preview {
    Puzzle12(input: Input.puzzle12.testInput)
}
