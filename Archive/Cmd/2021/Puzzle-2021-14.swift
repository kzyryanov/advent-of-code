//
//  Puzzle-2021-14.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-12-14.
//

import Foundation

func puzzle2021_14() {
    one()
    two()
}

fileprivate func one() {
    print("One")

    solve(steps: 10)
}

fileprivate func two() {
    print("Two")

    solve(steps: 40)
}

fileprivate func solve(steps: Int) {
    let input = puzzle2021_14_input()

    let template = input.template
    let rules = input.rules

    var pairs: [String:Int] = [:]

    for index in 0..<template.count-1 {
        let pair = String([template[index], template[index+1]])
        pairs[pair] = pairs[pair, default: 0] + 1
    }

    for _ in 0..<steps {
        var newPairs: [String:Int] = [:]

        pairs.forEach { key, value in
            let insertion = rules[key]!
            let pair1 = String([key[0],insertion])
            let pair2 = String([insertion,key[1]])

            newPairs[pair1] = newPairs[pair1, default: 0] + value
            newPairs[pair2] = newPairs[pair2, default: 0] + value
        }

        pairs = newPairs
    }

    let resultPairs = pairs.filter({ $0.value > 0 })
    print(resultPairs)

    var counts: [Character: Int] = [:]
    for (key, value) in resultPairs {
        let c = key[0]
        counts[c] = counts[c, default: 0] + value
    }

    if let last = template.last {
        counts[last] = counts[last, default: 0] + 1
    }

    let sorted = counts.sorted(by: { $0.value > $1.value })

    guard let mostCommon = sorted.first?.value, let leastCommon = sorted.last?.value else {
        fatalError()
    }

    print(mostCommon - leastCommon)
}

fileprivate struct Polymer {
    let template: String
    let rules: [String: Character]
}

fileprivate func puzzle2021_14_test_input() -> Polymer {
    Polymer(
        template: "NNCB",
        rules: [
            "CH": "B",
            "HH": "N",
            "CB": "H",
            "NH": "C",
            "HB": "C",
            "HC": "B",
            "HN": "C",
            "NN": "C",
            "BH": "H",
            "NC": "B",
            "NB": "B",
            "BN": "B",
            "BB": "N",
            "BC": "B",
            "CC": "N",
            "CN": "C",
        ]
    )
}

fileprivate func puzzle2021_14_input() -> Polymer {
    Polymer(
        template: "OOFNFCBHCKBBVNHBNVCP",
        rules: [
            "PH": "V",
            "OK": "S",
            "KK": "O",
            "BV": "K",
            "CV": "S",
            "SV": "C",
            "CK": "O",
            "PC": "F",
            "SC": "O",
            "KC": "S",
            "KF": "N",
            "SN": "C",
            "SF": "P",
            "OS": "O",
            "OP": "N",
            "FS": "P",
            "FV": "N",
            "CP": "S",
            "VS": "P",
            "PB": "P",
            "HP": "P",
            "PK": "S",
            "FC": "F",
            "SB": "K",
            "NC": "V",
            "PP": "B",
            "PN": "N",
            "VN": "C",
            "NV": "O",
            "OV": "O",
            "BS": "K",
            "FP": "V",
            "NK": "K",
            "PO": "B",
            "HF": "H",
            "VK": "S",
            "ON": "C",
            "KH": "F",
            "HO": "P",
            "OO": "H",
            "BC": "V",
            "CS": "O",
            "OC": "B",
            "VB": "N",
            "OF": "P",
            "FK": "H",
            "OH": "H",
            "CF": "K",
            "CC": "V",
            "BK": "O",
            "BH": "F",
            "VV": "N",
            "KS": "V",
            "FO": "F",
            "SH": "F",
            "OB": "O",
            "VH": "F",
            "HH": "P",
            "PF": "C",
            "NF": "V",
            "VP": "S",
            "CN": "V",
            "SK": "O",
            "FB": "S",
            "FN": "S",
            "BF": "H",
            "FF": "V",
            "CB": "P",
            "NN": "O",
            "VC": "F",
            "HK": "F",
            "BO": "H",
            "KO": "C",
            "CH": "N",
            "KP": "C",
            "HS": "P",
            "NP": "O",
            "NS": "V",
            "NB": "H",
            "HN": "O",
            "BP": "C",
            "VF": "S",
            "KN": "P",
            "HC": "C",
            "PS": "K",
            "BB": "O",
            "NO": "N",
            "NH": "F",
            "BN": "F",
            "KV": "V",
            "SS": "K",
            "CO": "H",
            "KB": "P",
            "FH": "C",
            "SP": "C",
            "SO": "V",
            "PV": "S",
            "VO": "O",
            "HV": "N",
            "HB": "V",
        ]
    )
}
