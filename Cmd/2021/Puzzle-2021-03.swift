//
//  Puzzle-2021-03.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-12-03.
//

import Foundation

func puzzle2021_03() {
    one()
    two()
}

fileprivate func one() {
    let input = puzzle2021_03_input()

    let count = input[0].count

    let transposed = input.reduce(Array(repeating: [Int](), count: count)) { partialResult, inputString in
        var p = partialResult
        for (index, value) in inputString.enumerated() {
            switch value {
            case "1": p[index].append(1)
            case "0": p[index].append(0)
            default: fatalError()
            }

        }
        return p
    }

    let reduced = transposed.reduce([Int]()) { partialResult, values in
        let count = values.count
        let ones = values.reduce(0, +)
        if ones > count / 2 {
            return partialResult + [1]
        }
        return partialResult + [0]
    }

    let gamma = reduced.reduce(0) { partialResult, bit in
        (partialResult << 1) | bit
    }

    let epsilon = reduced.reduce(0) { partialResult, bit in
        switch bit {
        case 1: return (partialResult << 1)
        case 0: return (partialResult << 1) | 1
        default: fatalError()
        }

    }

    print(gamma)
    print(epsilon)

    print(gamma * epsilon)
}

fileprivate func two() {
    let input = puzzle2021_03_input()

    let count = input[0].count

    var o_rating = input
    var co2_rating = input
    print(o_rating)
    print(co2_rating)

    for index in 0..<count {


        if o_rating.count > 1 {
            let onesO = o_rating.filter { string in
                string[index] == "1"
            }

            let zeroesO = o_rating.filter { string in
                string[index] == "0"
            }
            o_rating = onesO.count >= zeroesO.count ? onesO : zeroesO
        }

        if co2_rating.count > 1 {
            let onesCO2 = co2_rating.filter { string in
                string[index] == "1"
            }

            let zeroesCO2 = co2_rating.filter { string in
                string[index] == "0"
            }
            co2_rating = onesCO2.count < zeroesCO2.count ? onesCO2 : zeroesCO2
        }

        print(o_rating)
        print(co2_rating)
    }

    let oRating = o_rating.first!.reduce(0) { partialResult, c in
        (partialResult << 1) | (Int(String(c))!)
    }

    let co2Rating = co2_rating.first!.reduce(0) { partialResult, c in
        (partialResult << 1) | (Int(String(c))!)
    }

    print(oRating)
    print(co2Rating)
    print(oRating * co2Rating)
}
