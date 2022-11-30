//
//  Puzzle-2021-08.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-12-08.
//

import Foundation

func puzzle2021_08() {
    one()
    two()
}

fileprivate func one() {
    print("One")

    let possibleCounts: Set<Int> = [2, 3, 4, 7]

    let fullInput = puzzle2021_08_input()
    let output = fullInput.compactMap({ $0.components(separatedBy: " | ").last })
    let result = output.flatMap({
        $0.components(separatedBy: " ").filter({ possibleCounts.contains($0.count) })
    })
    print(result.count)
}

fileprivate func two() {
    print("Two")

    let fullInput = puzzle2021_08_input()
    let input: [(numbers: [String], signal: [String])] = fullInput.compactMap({
        (
            $0.components(separatedBy: " | ").first!.components(separatedBy: " "),
            $0.components(separatedBy: " | ").last!.components(separatedBy: " ")
        )
    })

    let result = input.map { (code: (numbers: [String], signal: [String])) -> Int in
        var numbers = Set(code.numbers)

        let one = numbers.first(where: { $0.count == 2 })!
        numbers.remove(one)
        let seven = numbers.first(where: { $0.count == 3 })!
        numbers.remove(seven)
        let four = numbers.first(where: { $0.count == 4 })!
        numbers.remove(four)
        let eight = numbers.first(where: { $0.count == 7 })!
        numbers.remove(eight)

        let six = numbers.filter({ $0.count == 6 }).first(where: { !Set(Array(one)).isSubset(of: Set(Array($0))) })!
        numbers.remove(six)

        let three = numbers.filter({ $0.count == 5 }).first(where: { Set(Array(one)).isSubset(of: Set(Array($0))) })!
        numbers.remove(three)

        let nine = numbers.filter({ $0.count == 6 }).first(where: { Set(Array(three)).intersection(Set(Array($0))) == Set(Array(three)) })!
        numbers.remove(nine)

        let zero = numbers.filter({ $0.count == 6 }).first!
        numbers.remove(zero)

        let five = numbers.first(where: { Set(Array(six)).intersection(Set(Array($0))).count == 5 })!
        numbers.remove(five)

        let two = numbers.removeFirst()

        let numbersMapping: [Set<Character>: Character] = [
            Set(Array(zero)): "0",
            Set(Array(one)): "1",
            Set(Array(two)): "2",
            Set(Array(three)): "3",
            Set(Array(four)): "4",
            Set(Array(five)): "5",
            Set(Array(six)): "6",
            Set(Array(seven)): "7",
            Set(Array(eight)): "8",
            Set(Array(nine)): "9",
        ]

        let signal = code.signal
        let result = Int(String(signal.map({ numbersMapping[Set(Array($0))]! })))!
        return result
    }

    print(result.reduce(0, +))
}
