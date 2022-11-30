//
//  Puzzle-2021-17.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-12-22.
//

import Foundation

func puzzle2021_17() {
    print(#function)
    one()
    two()
}

fileprivate struct TargetArea {
    let x, y: ClosedRange<Int>
}

fileprivate struct Speed: Hashable {
    let x, y: Int
}

fileprivate func one() {
    print("One")

    let input = test_input()

    let maxVX = input.x.upperBound
    let d = Double(1 + 4 * 2 * input.x.lowerBound)
    let minVX = Int(floor(1 + sqrt(d)) / 2)

    for vX in minVX...maxVX {
        print(vX)
    }
}

fileprivate func two() {
    print("Two")
}

fileprivate func test_input() -> TargetArea {
    TargetArea(x: 20...30, y: (-10)...(-5))
}

fileprivate func input() -> TargetArea {
    TargetArea(x: 138...184, y: (-125)...(-71))
}
