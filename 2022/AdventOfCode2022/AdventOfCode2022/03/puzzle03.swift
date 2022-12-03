//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle03() {
    print("Test")
    let resultOne = one(input: testInput03)
    print(resultOne)
    let resultTwo = two(input: testInput03)
    print(resultTwo)

    print("")
    print("Real")
    let realResultOne = one(input: input03)
    print(realResultOne)
    let realResultTwo = two(input: input03)
    print(realResultTwo)
}

private func one(input: String) -> Int {
    let strings = input.components(separatedBy: "\n")
    let result = strings.map { rucksack in
        let compartmentLength = rucksack.count / 2
        let compartmentOne = Set(Array(rucksack.prefix(compartmentLength)))
        let compartmentTwo = Set(Array(rucksack.suffix(compartmentLength)))
        let union = compartmentOne.intersection(compartmentTwo)
        let type = union.first!
        return type.priority
    }.reduce(0, +)

    return result
}

private func two(input: String) -> Int {
    let strings = input.components(separatedBy: "\n")
    let groups = strings.chunked(into: 3)
    let result = groups.map { group in
        let sets = group.map { Set(Array($0)) }
        return sets.reduce(Set()) { (partialResult, element) -> Set<Character> in
            if partialResult.isEmpty {
                return element
            }
            return partialResult.intersection(element)
        }.first!.priority
    }.reduce(0, +)

    return result
}

private extension Character {
    var priority: Int {
        if self.isUppercase {
            return Int(self.asciiValue! - 38)
        }
        return Int(self.asciiValue! - 96)
    }
}

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
