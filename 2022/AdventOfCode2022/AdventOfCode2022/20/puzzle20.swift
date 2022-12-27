//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle20() {
    print("Test")
    print("One")
    one(input: testInput20)
    print("Two")
    two(input: testInput20)

    print("")
    print("Real")
    print("One")
    one(input: input20)
    print("Two")
    two(input: input20)
}

private struct Item: CustomStringConvertible {
    let value: Int
    let initialIndex: Int

    var description: String {
        "\(value)"
    }
}

private func one(
    input: String,
    decriptionKey: Int = 1,
    mixCount: Int = 1
) {
    let items = input
        .components(separatedBy: "\n")
        .enumerated()
        .map { index, value in
            Item(value: Int(value)! * decriptionKey, initialIndex: index)
        }

    var mixed = items

    let count = items.count

    for _ in 0..<mixCount {
        for index in 0..<count {
            guard let mixedIndex = mixed.firstIndex(where: { $0.initialIndex == index }) else {
                fatalError("Index not found")
            }
            let item = mixed[mixedIndex]
            var newIndex = (mixedIndex + item.value)
            if newIndex < 0 {
                let increaseCount = abs(newIndex / (count - 1)) + 1
                newIndex = newIndex + increaseCount * (count - 1)
            } else if newIndex >= count {
                let decreaseCount = abs(newIndex / (count - 1))
                newIndex = newIndex - decreaseCount * (count - 1)
            }
            if newIndex < mixedIndex {
                let first = mixed[0..<newIndex]
                let second = mixed[newIndex..<mixedIndex]
                let third = mixed[mixedIndex..<count].dropFirst()
                mixed = first + [item] + second + third
            }
            if newIndex > mixedIndex {
                let first = mixed[0..<mixedIndex]
                let item = mixed[mixedIndex]
                let second = mixed[mixedIndex..<newIndex].dropFirst()
                let third = mixed[newIndex]
                let fourth = mixed[newIndex..<count].dropFirst()
                mixed = first + second + [third] + [item] + fourth
            }
        }
    }

    guard let zeroIndex = mixed.firstIndex(where: { $0.value == 0 }) else {
        fatalError("Zero not found")
    }

    let firstIndex = (zeroIndex + 1000) % count
    let secondIndex = (zeroIndex + 2000) % count
    let thirdIndex = (zeroIndex + 3000) % count

    let resultValues = [
        mixed[firstIndex].value,
        mixed[secondIndex].value,
        mixed[thirdIndex].value
    ]

    print(resultValues)
    let result = resultValues.reduce(0, +)
    print("Result: \(result)")
}

private func two(input: String) {
    one(input: input, decriptionKey: 811589153, mixCount: 10)
}
