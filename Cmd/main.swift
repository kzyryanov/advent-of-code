//
//  main.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-11-19.
//

import Foundation

//puzzle2019_02()
//puzzle2021_01()
//puzzle2021_02()
//puzzle2021_03()
//puzzle2021_04()
//puzzle2021_05()
//puzzle2021_06()
//puzzle2021_07()
//puzzle2021_08()
//puzzle2021_09()
//puzzle2021_10()
//puzzle2021_11()
//puzzle2021_12()
//puzzle2021_13()
puzzle2021_14()

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

//var scheme: [String: Command] = Dictionary(uniqueKeysWithValues: data.map({ ($0.target, $0.command) }))
//
//func compute(target: String) -> UInt16 {
//    let command = scheme[target, default: .signal(0)]
//
//    switch command {
//    case .signal(let s):
//        return s
//    case .and(let w1, let w2):
//        let s1 = compute(target: w1)
//        let s2 = compute(target: w2)
//        scheme[w1] = .signal(s1)
//        scheme[w2] = .signal(s2)
//        let rs = s1 & s2
//        scheme[target] = .signal(rs)
//        return s1 & s2
//    case .andSignal(let s, let w):
//        let rs = compute(target: w) & s
//        scheme[target] = .signal(rs)
//        return rs
//    case .just(let w):
//        let rs = compute(target: w)
//        scheme[target] = .signal(rs)
//        return rs
//    case .lshift(let w, let s):
//        let rs = compute(target: w) << s
//        scheme[target] = .signal(rs)
//        return rs
//    case .rshift(let w, let s):
//        let rs = compute(target: w) >> s
//        scheme[target] = .signal(rs)
//        return rs
//    case .or(let w1, let w2):
//        let s1 = compute(target: w1)
//        let s2 = compute(target: w2)
//        scheme[w1] = .signal(s1)
//        scheme[w2] = .signal(s2)
//        let rs = s1 | s2
//        scheme[target] = .signal(rs)
//        return rs
//    case .not(let w):
//        let rs = ~compute(target: w)
//        scheme[w] = .signal(rs)
//        return rs
//    }
//}
//
//
//print(compute(target: "a"))

//data1.forEach { item in
//    scheme[item.target] = item.command
//}

//let wires = [ "d", "e", "f", "g", "h", "i", "x", "y" ]

//wires.forEach {
//    print(compute(target: $0))
//}


//puzzle2016_01()
//puzzle2016_02()
//puzzle2016_03()
//puzzle2019_01()
