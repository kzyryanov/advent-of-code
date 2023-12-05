//
//  Puzzle05.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-05.
//

import SwiftUI

struct Puzzle05: View {
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
                        await solveFirst()
                        await solveSecond()
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

        var seeds: [Int] = []
        var map: [MapKey: [Mapping]] = [:]

        var currentMapping: MapKey?

        let lines = input.components(separatedBy: "\n")
        for line in lines {
            switch line {
            case line where line.hasPrefix("seeds: "):
                seeds = line.components(separatedBy: ": ").last!.components(separatedBy: " ").map({ Int($0)! })
            case "seed-to-soil map:":
                currentMapping = .seedSoil
            case "soil-to-fertilizer map:":
                currentMapping = .soilFertilizer
            case "fertilizer-to-water map:":
                currentMapping = .fertilizerWater
            case "water-to-light map:":
                currentMapping = .waterLight
            case "light-to-temperature map:":
                currentMapping = .lightTemperature
            case "temperature-to-humidity map:":
                currentMapping = .temperatureHumidity
            case "humidity-to-location map:":
                currentMapping = .humidityLocation
            case line where line.isEmpty:
                break
            default:
                let components = line.components(separatedBy: " ").map({ Int($0)! })
                let newMapping = Mapping(
                    sourceRange: components[1]...(components[1] + components[2] - 1),
                    destinationRange: components[0]...(components[0] + components[2] - 1)
                )
                let mapping = map[currentMapping!, default: []]
                map[currentMapping!] = mapping + [newMapping]
            }
        }

        var convertedSeeds: [Int] = seeds

        MapKey.allCases.forEach { key in
            let mappings = map[key, default: []]
            convertedSeeds = convertedSeeds.map({ value in
                for mapping in mappings {
                    let conversion = mapping.convert(value)
                    if conversion.converted {
                        return conversion.newValue
                    }
                }
                return value
            })
        }

        let result = convertedSeeds.min()!

        await MainActor.run {
            answerFirst = result
        }
    }

    private func solveSecond() async {
        answerSecond = nil
        isSolving = true
        defer {
            isSolving = false
        }

        var seeds: [ClosedRange<Int>] = []
        var map: [MapKey: [Mapping]] = [:]

        var currentMapping: MapKey?

        let lines = input.components(separatedBy: "\n")
        for line in lines {
            switch line {
            case line where line.hasPrefix("seeds: "):
                let seedsNumbers = line.components(separatedBy: ": ").last!.components(separatedBy: " ").map({ Int($0)! })
                seeds = stride(from: 0, to: seedsNumbers.count - 1, by: 2)
                    .lazy
                    .map { seedsNumbers[$0]...(seedsNumbers[$0] + seedsNumbers[$0 + 1] - 1) }
                    .sorted(by: { $0.lowerBound < $1.lowerBound })
            case "seed-to-soil map:":
                currentMapping = .seedSoil
            case "soil-to-fertilizer map:":
                currentMapping = .soilFertilizer
            case "fertilizer-to-water map:":
                currentMapping = .fertilizerWater
            case "water-to-light map:":
                currentMapping = .waterLight
            case "light-to-temperature map:":
                currentMapping = .lightTemperature
            case "temperature-to-humidity map:":
                currentMapping = .temperatureHumidity
            case "humidity-to-location map:":
                currentMapping = .humidityLocation
            case line where line.isEmpty:
                break
            default:
                let components = line.components(separatedBy: " ").map({ Int($0)! })
                let newMapping = Mapping(
                    sourceRange: components[1]...(components[1] + components[2] - 1),
                    destinationRange: components[0]...(components[0] + components[2] - 1)
                )
                let mapping = map[currentMapping!, default: []]
                map[currentMapping!] = (mapping + [newMapping])
                    .sorted(by: { $0.sourceRange.lowerBound < $1.sourceRange.lowerBound })
            }
        }

        print(seeds)
//        print(map)

        var convertedSeeds: [ClosedRange<Int>] = seeds

        MapKey.allCases.forEach { key in
            let mappings = map[key, default: []]
            print(key, mappings)
            print(convertedSeeds)
            convertedSeeds = convertedSeeds.flatMap { seedsRange in
                var splits: [ClosedRange<Int>] = []

                for mapping in mappings {
                    guard let intersection = mapping.sourceRange.intersection(seedsRange) else {
                        continue
                    }

                    splits.append(intersection)
                }

                var lowerBound = seedsRange.lowerBound
                var rests: [ClosedRange<Int>] = []
                for split in splits {
                    if lowerBound < split.lowerBound {
                        rests.append(lowerBound...(split.lowerBound-1))
                    }
                    lowerBound = split.upperBound + 1
                }
                if lowerBound <= seedsRange.upperBound {
                    rests.append(lowerBound...seedsRange.upperBound)
                }

                let totalSplits = (splits + rests).sorted(by: { $0.lowerBound < $1.lowerBound })

                let convertedSplits: [ClosedRange<Int>] = totalSplits.map { split in
                    for mapping in mappings {
                        if mapping.sourceRange.contains(split.lowerBound) {
                            return mapping.convert(split.lowerBound).newValue...mapping.convert(split.upperBound).newValue
                        }
                    }
                    return split
                }

                print("======")
                print("Range     ", seedsRange)
                print("Splits    ", totalSplits)
                print("Converted ", convertedSplits)
                print("======")

                return convertedSplits

//                var splits: [ClosedRange<Int>] = []
//                var restSeedsRange = seedsRange
//                for mapping in mappings {
//                    guard let intersection = mapping.sourceRange.intersection(restSeedsRange) else {
//                        continue
//                    }
//                    if intersection == restSeedsRange {
//                        splits.append(restSeedsRange)
//                    }
//                    if intersection == mapping.sourceRange {
//                        if intersection.lowerBound == restSeedsRange.lowerBound {
//
//                        }
//                    }
//                }
//                return splits
            }
            .sorted(by: { $0.lowerBound < $1.lowerBound })
        }

        print(convertedSeeds)

//        var convertedSeeds: [Int] = seeds
//
//        MapKey.allCases.forEach { key in
//            let mappings = map[key, default: []]
//            convertedSeeds = convertedSeeds.map({ value in
//                for mapping in mappings {
//                    let conversion = mapping.convert(value)
//                    if conversion.converted {
//                        return conversion.newValue
//                    }
//                }
//                return value
//            })
//        }

        let result = convertedSeeds.first!.lowerBound

        await MainActor.run {
            answerSecond = result
        }
    }
}

private struct Mapping: CustomStringConvertible {
    let sourceRange: ClosedRange<Int>
    let destinationRange: ClosedRange<Int>

    func convert(_ number: Int) -> (newValue: Int, converted: Bool) {
        if sourceRange.contains(number) {
            return (destinationRange.lowerBound + number - sourceRange.lowerBound, true)
        }
        return (number, false)
    }

    var description: String {
        "(\(sourceRange) -> \(destinationRange))"
    }
}

private extension ClosedRange {
    func intersection(_ range: ClosedRange<Bound>) -> ClosedRange<Bound>? {
        var lowerBound: Bound?
        var upperBound: Bound?
        if self.contains(range.lowerBound) {
            lowerBound = range.lowerBound
        }
        if range.contains(self.lowerBound) {
            lowerBound = self.lowerBound
        }
        if self.contains(range.upperBound) {
            upperBound = range.upperBound
        }
        if range.contains(self.upperBound) {
            upperBound = self.upperBound
        }
        if let lowerBound, let upperBound {
            return lowerBound...upperBound
        }
        return nil
    }
}

private enum MapKey: CaseIterable, CustomStringConvertible {
    case seedSoil
    case soilFertilizer
    case fertilizerWater
    case waterLight
    case lightTemperature
    case temperatureHumidity
    case humidityLocation

    var description: String {
        switch self {
        case .seedSoil:
            return "seed-to-soil"
        case .soilFertilizer:
            return "soil-to-fertilizer"
        case .fertilizerWater:
            return "fertilizer-to-water"
        case .waterLight:
            return "water-to-light"
        case .lightTemperature:
            return "light-to-temperature"
        case .temperatureHumidity:
            return "temperature-to-humidity"
        case .humidityLocation:
            return "humidity-to-location"
        }
    }
}

#Preview {
    Puzzle05(input: Input.puzzle05.testInput)
}
