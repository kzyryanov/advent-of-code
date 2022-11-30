//
//  Puzzle-2016-03.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-11-25.
//

import Foundation

func puzzle2016_03() {
    let input = puzzle2016_03_input()

    func filter(_ input: [[Int]]) -> [[Int]] {
        input.filter { triangle in
            let sorted = triangle.sorted(by: <)
            if sorted[0] + sorted[1] > sorted[2] {
                return true
            }
            return false
        }
    }

    let result = filter(input)
    print(result.count)

    let count = input.count

    var triangles: [[Int]] = []

    var triangle = [Int]()

    for i in 0..<(count * 3) {
        let col = i / count
        let row = i % count

        triangle.append(input[row][col])
        if triangle.count >= 3 {
            triangles.append(triangle)
            triangle = []
        }
    }

    let result2 = filter(triangles)
    print(result2.count)
}
