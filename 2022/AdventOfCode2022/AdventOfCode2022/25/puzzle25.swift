//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle25() {
    print("Test")
    print("Table")
    one(input: table25)
    print("")
    print("Input")
    one(input: testInput25)

    print("")
    print("Real")
    one(input: input25)
}

private extension Character {
    var number: Int {
        switch self {
        case "2": return 2
        case "1": return 1
        case "0": return 0
        case "-": return -1
        case "=": return -2
        default: fatalError("Not SNAFU character")
        }
    }

    init(int: Int) {
        switch int {
        case 2: self = "2"
        case 1: self = "1"
        case 0: self = "0"
        case -1: self = "-"
        case -2: self = "="
        default: fatalError("Not a SNAFU number")
        }
    }
}

private extension String {
    var snafuToDecimal: Int {
        self.reversed().enumerated().reduce(0) { partialResult, symbol in
            partialResult + (symbol.element.number * NSDecimalNumber(decimal: pow(5, symbol.offset)).intValue)
        }
    }
}

private extension Int {
    var decimalToSnafu: String {
        var fiveBase: [Character] = []
        var number = self
        while number > 0 {
            var rest = number % 5
            if (3...4).contains(rest) {
                rest -= 5
                number -= rest
            }
            number /= 5
            fiveBase.append(Character(int: rest))
        }
        return String(fiveBase.reversed())
    }
}

private func one(input: String) {
    let numbers = input.components(separatedBy: "\n")

    let decimals = numbers.map(\.snafuToDecimal)
    let snafu = decimals.map(\.decimalToSnafu)

    print("Test", snafu.joined(separator: "\n") == input)
    assert(snafu.joined(separator: "\n") == input)

    let resultDecimal = decimals.reduce(0, +)
    print("Decimal result: \(resultDecimal)")

    let snafuResult = resultDecimal.decimalToSnafu
    print("Result: \(snafuResult)")
}
