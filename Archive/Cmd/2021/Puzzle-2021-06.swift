//
//  Puzzle-2021-06.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-12-07.
//

import Foundation

func puzzle2021_06() {
    one()
    two()
}

fileprivate func one() {
    let input = puzzle2021_06_input()
    solve(input: input, days: 80)
}

fileprivate func two() {
    let input = puzzle2021_06_input()
    solve(input: input, days: 256)
}

fileprivate func solve(input: [Int], days: Int) {

    var fishes = Dictionary(uniqueKeysWithValues: Dictionary(grouping: input, by: +).map({ ($0.key, $0.value.count) }))

    for _ in 0..<days {
        let zero = fishes[0, default: 0]

        for i in (0...7) {
            let count = fishes[i+1, default: 0]
            fishes[i] = count
        }

        let six = fishes[6, default: 0]
        fishes[6] = six + zero
        fishes[8] = zero
    }
    print(fishes.values.reduce(0, +))

}
