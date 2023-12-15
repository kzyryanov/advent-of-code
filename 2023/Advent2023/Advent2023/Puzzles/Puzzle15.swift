//
//  Puzzle15.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-15.
//

import SwiftUI

struct Puzzle15: View {
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

        let hashes = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ",")
            .filter(\.isNotEmpty)
            .map(\.puzzleHash)

        let result = hashes
            .reduce(0, +)

        await MainActor.run {
            print("Result 1: \(result)")
            answerFirst = result
        }
    }

    private func solveSecond() async {
        answerSecond = nil

        let regex = /(?<label>[a-z]+?)[-=](?<value>[0-9]?)?/

        let operations = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ",")
            .filter(\.isNotEmpty)
            .map {
                let match = try! regex.wholeMatch(in: $0)
                let label = String(match!.label)
                let value: Int? = match!.value.flatMap { Int($0) }

                if let value {
                    return Operation.add(label: label, focalLength: value)
                }
                return Operation.remove(label: label)
            }

        var boxes: [Int: [Lens]] = [:]

        operations.forEach { operation in
            let boxId = operation.label.puzzleHash
            var box = boxes[boxId, default: []]

            switch operation {
            case .add(let label, let focalLength):
                let lens = Lens(label: label, focalLength: focalLength)
                if let firstIndex = box.firstIndex(where: { $0.label == label }) {
                    box[firstIndex] = lens
                } else {
                    box.append(lens)
                }
            case .remove(let label):
                box = box.filter { $0.label != label }
            }

            boxes[boxId] = box
        }

        let result = boxes.reduce(0) { partialResult, element in
            let (boxId, box) = element
            let value = (boxId + 1) * box.enumerated().reduce(0, { partialResult, lens in
                partialResult + (lens.offset + 1) * lens.element.focalLength
            })
            return partialResult + value
        }

        await MainActor.run {
            print("Result 2: \(result)")
            answerSecond = result
        }
    }
}

private struct Lens: CustomStringConvertible {
    let label: String
    let focalLength: Int

    var description: String {
        "\(label)=\(focalLength)"
    }
}

private enum Operation: CustomStringConvertible {
    case add(label: String, focalLength: Int)
    case remove(label: String)

    var description: String {
        switch self {
        case .add(let label, let focalLength):
            return "\(label)=\(focalLength)"
        case .remove(let label):
            return "\(label)-"
        }
    }

    var label: String {
        switch self {
        case .add(let label, _), .remove(let label):
            return label
        }
    }
}

private extension String {
    var puzzleHash: Int {
        reduce(0) { partialResult, character in
            let ascii = Int(character.asciiValue!)
            var currentValue = partialResult
            currentValue += ascii
            currentValue *= 17
            currentValue %= 256
            return currentValue
        }
    }
}

#Preview {
    Puzzle15(input: Input.puzzle15.testInput)
}
