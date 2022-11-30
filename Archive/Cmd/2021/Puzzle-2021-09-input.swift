//
//  Puzzle-2021-09-input.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-12-09.
//

import Foundation

func puzzle2021_09_test_input() -> [[Int]] {
    [
    [2,1,9,9,9,4,3,2,1,0,],
    [3,9,8,7,8,9,4,9,2,1,],
    [9,8,5,6,7,8,9,8,9,2,],
    [8,7,6,7,8,9,6,7,8,9,],
    [9,8,9,9,9,6,5,6,7,8,],
    ]
}

func puzzle2021_09_input() -> [[Int]] {
    [
    [9,8,7,6,5,4,3,2,3,4,6,7,9,3,1,0,9,4,3,4,5,6,7,9,8,4,3,3,4,5,6,7,9,8,9,9,8,7,6,4,3,2,1,3,5,7,9,2,1,0,2,5,6,8,9,9,2,1,9,8,7,8,9,9,8,9,6,4,9,8,7,9,9,9,2,3,4,9,1,2,9,7,6,5,4,5,4,5,6,7,9,8,7,6,2,1,2,3,4,7,],
    [6,9,8,7,6,7,5,0,3,6,6,7,8,9,3,9,8,7,4,5,6,7,9,8,7,0,1,2,5,6,7,8,9,7,8,9,9,9,7,5,5,3,2,4,6,7,8,9,2,3,3,4,5,6,7,8,9,0,9,9,6,7,8,9,7,8,9,9,8,9,6,7,9,8,9,5,9,8,9,3,9,8,7,4,3,2,3,6,7,8,9,8,6,5,1,0,1,4,5,6,],
    [5,5,9,8,9,8,3,1,2,4,5,8,9,5,9,8,7,6,5,6,8,9,7,6,5,4,2,3,6,7,8,9,5,6,7,8,9,8,7,6,5,4,3,5,6,8,9,4,3,5,6,5,6,7,8,9,9,9,7,6,5,3,9,5,6,7,9,8,7,6,5,9,8,7,8,9,6,7,8,9,8,7,6,5,4,3,4,5,9,9,8,7,6,4,3,1,3,6,8,9,],
    [4,3,4,9,9,9,4,2,3,5,6,9,5,3,2,9,9,7,6,7,8,9,9,9,8,6,3,4,6,7,8,9,4,6,7,8,9,9,8,7,9,8,7,6,7,9,7,5,7,6,7,8,9,8,9,3,9,8,6,5,3,2,3,4,5,9,8,7,6,7,4,5,9,6,5,4,5,6,7,9,9,8,7,6,7,4,9,9,8,9,9,8,7,5,4,2,4,5,6,8,],
    [3,2,9,8,9,8,7,6,5,6,7,9,5,4,1,9,8,9,9,8,9,6,4,5,9,7,4,5,9,8,9,1,3,4,5,6,8,9,9,8,9,9,8,7,8,9,9,6,8,7,8,9,6,9,9,2,1,9,7,7,2,1,2,3,9,8,7,6,5,4,3,9,8,7,5,3,4,5,6,8,9,9,9,8,9,9,8,9,6,8,9,9,8,6,5,7,6,7,8,9,],
    [2,1,2,6,5,9,8,7,8,7,8,9,6,9,9,8,7,8,8,9,0,2,3,4,9,8,9,7,9,9,1,0,1,3,4,5,7,8,9,9,9,9,9,9,9,7,9,8,9,9,9,4,5,6,7,9,0,9,7,6,5,2,4,4,5,9,8,8,7,5,6,9,7,5,4,2,3,4,6,7,8,9,7,9,8,7,6,4,5,9,3,9,8,7,8,9,7,8,9,7,],
    [1,0,1,2,3,4,9,8,9,8,9,9,9,8,8,7,5,6,7,8,9,3,9,5,6,9,9,9,5,4,3,2,3,4,9,6,7,9,6,7,9,8,8,6,5,6,7,9,9,3,2,3,4,5,9,8,9,8,9,5,4,3,5,5,6,9,9,8,7,6,9,8,9,3,3,1,2,3,8,9,9,6,6,5,9,8,7,5,6,9,1,2,9,8,9,9,8,9,5,6,],
    [4,1,2,3,4,6,7,9,9,9,5,9,8,7,6,5,4,5,6,7,8,9,8,9,7,9,8,7,6,5,4,3,4,7,8,9,9,6,5,9,8,7,6,5,4,5,6,7,8,9,1,2,3,9,8,7,6,7,8,9,6,4,6,6,7,8,9,9,8,7,9,7,9,2,1,0,3,4,9,9,6,5,5,4,5,9,9,6,7,8,9,3,9,9,6,5,9,2,3,5,],
    [3,2,3,4,5,9,8,9,8,5,4,3,9,8,7,8,5,6,7,8,9,6,7,8,9,1,9,8,7,9,5,4,5,6,7,8,9,8,9,8,7,6,5,4,3,4,1,8,9,3,2,9,9,8,7,5,4,6,7,8,9,9,9,8,9,9,4,6,9,9,8,6,7,9,9,1,4,6,7,8,9,4,5,3,4,9,8,7,8,9,9,9,8,5,4,3,2,1,2,3,],
    [4,3,4,7,8,9,9,8,7,6,5,6,7,9,8,9,6,7,8,9,6,5,9,9,4,3,4,9,9,8,7,8,9,7,8,9,9,9,0,9,9,9,6,5,2,1,0,3,4,9,9,8,6,7,5,3,2,3,5,9,7,8,9,9,1,2,3,9,8,9,6,5,9,8,8,9,5,7,8,9,4,3,0,2,3,4,9,8,9,9,9,8,7,5,3,2,1,0,1,4,],
    [5,4,5,6,9,8,7,9,9,7,6,8,9,2,9,9,9,8,9,2,5,4,7,8,9,4,9,8,7,9,8,9,9,8,9,9,9,9,1,9,9,8,9,9,9,2,1,2,9,8,7,6,5,4,3,2,1,3,4,5,6,7,8,9,2,3,9,8,7,7,5,4,5,6,7,8,9,8,9,4,3,2,1,4,5,9,9,9,9,9,8,9,8,9,4,3,2,3,4,5,],
    [6,5,6,7,8,9,6,7,9,8,7,9,2,1,0,9,8,9,2,1,2,3,5,6,9,9,8,7,6,7,9,9,9,9,9,9,8,8,9,8,7,6,7,8,8,9,2,3,4,9,9,7,8,5,4,3,2,4,5,9,7,9,9,4,3,9,9,7,6,5,4,3,4,6,8,9,9,9,6,5,6,5,2,3,6,7,8,9,9,8,7,6,9,8,5,4,4,4,5,6,],
    [7,8,9,8,9,4,5,6,8,9,8,9,9,9,9,8,7,6,3,0,1,2,4,5,8,9,7,6,5,9,7,9,8,9,9,8,7,7,8,4,3,4,5,6,7,8,9,4,9,9,9,8,9,8,5,4,3,4,9,8,9,2,1,9,9,8,7,6,5,4,3,2,3,4,5,6,8,9,9,8,5,4,3,4,5,6,9,9,9,9,6,5,9,7,6,5,5,6,7,8,],
    [8,9,4,9,2,3,9,7,9,6,9,5,8,8,9,9,9,5,4,1,2,4,5,6,7,8,9,5,4,3,5,6,7,8,9,9,6,5,4,3,2,3,4,5,6,7,8,9,7,8,8,9,8,7,6,5,9,9,8,7,8,9,9,8,6,9,8,7,6,5,4,3,5,6,7,8,9,9,8,7,6,5,4,9,6,9,7,8,9,8,9,4,9,8,9,6,6,8,9,9,],
    [9,9,3,2,1,9,8,9,6,5,3,4,6,7,8,9,8,6,7,2,5,8,7,8,9,9,3,2,1,2,4,5,6,7,9,8,7,6,5,5,1,2,3,4,5,8,9,7,6,7,7,8,9,8,7,9,8,8,7,6,9,8,7,6,5,6,9,8,7,6,6,4,6,8,8,9,0,1,9,8,8,7,9,8,9,8,6,9,9,7,9,3,2,9,9,8,7,9,5,7,],
    [9,8,9,3,9,8,7,8,9,6,2,3,4,5,6,8,9,5,4,3,4,5,8,9,8,7,4,3,2,4,5,7,9,8,9,9,8,7,6,6,2,3,4,5,6,7,8,9,4,5,6,7,8,9,9,8,7,5,4,5,7,9,8,7,4,2,1,9,8,7,7,5,6,7,9,9,9,3,4,9,9,9,8,7,6,6,4,9,8,6,8,9,1,2,3,9,8,9,4,6,],
    [8,7,8,9,8,7,6,7,8,9,1,9,5,6,8,9,8,7,5,4,5,7,9,9,9,6,5,5,4,6,6,7,9,9,6,7,9,8,7,9,8,4,5,6,7,8,9,1,3,3,4,8,9,8,7,6,5,4,3,4,6,9,8,7,6,3,0,2,9,8,8,6,7,8,9,7,8,9,5,9,8,8,9,6,5,4,3,2,9,4,6,7,9,4,4,5,9,4,3,5,],
    [7,6,5,3,2,4,5,6,7,8,9,8,9,7,9,9,8,7,6,7,6,7,8,9,9,8,6,7,5,7,8,9,5,4,5,6,8,9,8,9,6,5,8,7,9,9,1,0,1,2,3,4,9,9,9,8,6,9,2,3,4,5,9,8,5,4,1,3,4,9,9,9,8,9,7,6,7,8,9,8,7,6,8,9,4,3,2,1,9,8,7,8,9,5,5,6,8,9,1,0,],
    [9,6,5,4,1,3,4,7,8,9,6,7,8,9,8,6,9,8,8,9,7,9,9,8,9,8,7,8,9,8,9,2,4,3,4,5,6,7,9,9,7,6,7,8,9,5,3,1,2,3,4,9,8,9,8,9,9,8,9,4,5,9,8,7,6,7,6,5,5,6,7,8,9,3,4,5,6,9,8,7,6,5,7,8,9,2,1,0,3,9,8,9,9,6,6,7,8,9,9,9,],
    [8,7,6,5,2,4,5,6,9,6,5,6,7,8,9,5,3,9,9,8,9,8,9,7,9,9,9,9,5,9,9,0,1,2,3,6,7,8,9,9,8,9,8,9,8,6,4,2,3,4,9,8,7,7,6,5,6,6,8,9,9,9,9,9,8,8,7,6,8,7,9,9,0,2,9,6,9,8,7,9,8,4,6,9,4,3,3,1,2,3,9,9,8,9,9,8,9,8,8,8,],
    [9,9,5,4,3,4,6,8,9,7,3,7,9,9,6,4,2,1,9,7,8,7,7,6,7,8,9,3,4,7,8,9,4,3,4,7,9,9,0,1,9,9,9,5,9,7,4,3,4,5,6,9,6,5,3,4,6,5,6,7,8,9,9,9,9,9,8,7,9,8,9,2,1,9,8,9,8,9,6,5,9,3,7,8,9,4,5,2,3,9,8,9,7,8,9,9,8,7,6,7,],
    [0,9,7,6,5,5,7,8,9,8,2,9,8,9,6,5,3,9,8,6,5,6,4,5,6,7,9,4,5,6,9,8,9,4,9,9,8,9,1,9,5,8,9,4,3,9,7,6,5,6,9,8,5,4,2,3,2,4,5,9,9,6,8,9,9,2,9,8,9,9,4,3,9,9,7,6,7,8,9,4,3,2,5,9,9,5,4,3,9,8,7,7,6,7,9,9,9,6,5,6,],
    [2,9,9,8,6,7,8,9,9,9,9,9,7,8,9,7,9,8,7,6,4,2,3,4,7,8,9,5,6,9,8,7,6,9,8,6,7,8,9,8,4,7,8,9,2,9,8,7,6,9,8,7,3,2,1,0,1,5,6,8,9,5,9,9,8,4,5,9,9,6,5,9,8,7,6,5,6,7,8,9,5,3,4,9,8,9,5,9,8,7,6,6,5,6,8,9,7,5,4,5,],
    [9,8,5,9,7,8,9,8,9,9,8,8,6,7,8,9,9,9,8,7,5,6,4,6,8,9,9,8,7,8,9,6,5,5,4,5,6,7,9,7,5,6,9,9,9,9,9,8,9,9,9,6,4,3,2,3,2,6,7,9,6,4,9,8,6,5,6,7,8,9,9,8,7,6,5,4,5,6,7,8,9,4,9,9,7,8,9,9,9,6,5,5,4,5,9,9,8,9,6,8,],
    [7,6,4,3,9,9,6,7,9,8,6,5,4,5,6,7,9,4,9,8,9,8,9,7,9,6,5,9,8,9,7,6,4,3,2,4,5,6,9,8,9,7,9,9,8,9,9,9,4,9,8,7,5,4,3,6,8,9,8,9,5,3,2,9,8,6,8,9,9,9,9,9,8,7,6,5,6,7,8,9,4,9,8,7,6,7,7,8,9,6,4,2,3,4,8,9,9,8,7,9,],
    [5,4,3,2,3,4,5,6,9,7,5,4,3,4,5,8,9,5,7,9,9,9,9,8,9,5,4,5,9,9,8,7,3,2,1,2,4,5,6,9,9,9,8,9,6,7,9,4,3,1,9,8,9,6,4,5,9,9,9,4,3,2,1,0,9,7,9,0,9,8,9,6,9,8,7,6,8,9,9,1,2,9,8,7,5,4,6,7,9,9,6,4,4,6,7,8,9,9,8,9,],
    [8,5,8,4,5,5,7,9,8,7,6,5,4,5,6,9,7,6,7,8,9,9,9,9,3,1,2,3,9,8,9,8,4,1,0,3,4,9,7,9,9,8,7,6,5,4,5,9,9,9,7,9,9,8,9,6,7,9,9,8,5,3,4,1,9,8,9,1,9,7,8,5,4,9,8,7,9,8,9,0,3,9,6,5,4,3,4,6,7,8,9,6,7,7,8,9,9,8,9,9,],
    [7,6,7,5,6,7,8,9,9,8,7,6,5,6,9,9,8,9,8,9,8,8,9,3,2,0,3,4,9,7,6,4,3,2,1,4,9,8,9,8,9,9,8,8,6,3,2,7,8,9,5,4,3,9,3,9,8,9,8,7,6,8,3,2,6,9,8,9,8,6,5,4,3,2,9,8,9,6,8,9,9,8,7,6,5,9,5,6,7,9,9,8,9,8,9,9,8,7,8,9,],
    [8,7,7,6,7,8,9,4,3,9,8,9,7,7,8,9,9,0,9,9,7,7,7,9,4,2,5,5,9,8,7,5,4,3,2,9,8,7,8,7,8,9,9,9,8,5,3,6,9,8,9,3,2,1,2,3,9,9,9,8,9,7,6,4,5,6,7,9,9,7,4,3,2,1,2,9,4,5,6,7,8,9,9,7,9,8,9,9,9,8,9,9,4,9,9,8,7,6,9,9,],
    [9,8,9,9,8,9,9,5,2,4,9,8,9,8,9,6,4,2,9,8,6,5,6,8,9,3,5,6,8,9,8,6,5,5,3,9,8,6,5,6,7,9,9,8,7,6,4,5,6,7,8,9,1,0,5,6,7,9,8,9,9,8,9,5,6,7,8,9,8,7,5,2,1,0,1,2,3,5,9,8,9,1,3,9,8,7,9,7,7,7,8,9,3,2,3,9,7,5,6,9,],
    [9,9,8,7,9,7,8,9,3,9,8,7,8,9,8,7,8,9,8,7,5,4,5,7,8,9,6,7,8,9,8,7,8,6,4,9,9,5,4,5,8,9,2,9,9,8,9,6,8,9,9,4,3,2,3,4,5,6,7,8,9,9,8,9,9,8,9,4,9,8,4,3,2,1,5,4,4,6,7,9,1,0,9,8,7,6,7,6,5,6,7,8,9,1,9,8,6,4,7,8,],
    [9,8,7,6,5,6,8,9,9,8,7,6,7,8,9,8,9,9,9,7,4,3,6,7,9,8,7,9,9,6,9,8,9,7,9,8,7,6,5,6,9,0,1,2,3,9,8,7,9,8,9,5,5,4,4,6,7,8,9,9,9,8,7,9,8,9,7,5,9,9,5,4,3,2,6,5,9,9,8,9,3,4,9,7,7,5,6,7,4,5,6,7,8,9,7,6,5,3,9,9,],
    [7,7,6,5,4,5,9,8,7,6,5,4,6,9,9,9,8,9,8,6,5,4,7,9,8,9,8,9,4,5,6,9,9,8,9,9,8,7,6,7,8,9,3,4,4,6,9,8,9,7,9,6,6,6,5,6,7,8,9,9,8,7,6,8,7,8,9,9,8,7,6,5,4,3,9,9,8,9,9,9,4,9,7,6,5,4,3,2,3,4,5,9,9,6,9,9,6,9,8,9,],
    [6,9,8,4,3,4,5,9,9,5,4,3,7,8,9,8,7,5,9,9,9,5,9,8,7,8,9,2,3,9,9,9,9,9,4,3,9,9,7,8,9,9,8,6,6,9,9,9,5,6,8,9,7,7,6,8,8,9,9,9,7,6,5,6,6,6,7,9,9,8,9,6,9,9,8,9,7,8,9,8,9,9,9,8,6,6,4,5,5,6,7,8,9,5,7,8,9,8,7,8,],
    [5,4,9,3,2,3,4,9,8,9,4,2,5,7,8,9,6,4,7,8,8,9,8,7,6,8,9,1,9,8,7,8,9,9,3,2,1,9,8,9,9,9,8,7,7,8,9,3,4,5,7,8,9,8,7,9,9,9,8,7,6,5,4,3,4,5,9,5,4,9,9,9,8,8,7,5,5,6,9,7,8,9,9,9,8,7,8,6,6,8,8,9,3,4,8,9,9,7,6,7,],
    [4,3,2,1,0,4,9,8,7,5,4,1,4,6,7,8,9,3,6,9,7,9,9,6,5,7,8,9,9,7,6,6,7,8,9,1,0,1,9,8,9,8,9,9,8,9,3,2,3,4,6,9,9,9,8,9,6,7,9,8,7,6,5,2,3,6,8,9,3,2,9,8,7,6,5,4,4,1,4,5,7,9,9,8,9,8,8,7,9,9,9,0,2,3,9,8,7,6,5,6,],
    [5,4,9,3,9,5,9,9,5,4,3,2,3,4,6,9,3,2,4,7,6,7,8,9,4,6,7,9,8,6,4,5,6,7,8,9,1,9,8,7,8,7,8,9,9,3,2,1,2,3,7,8,9,9,9,5,4,5,6,9,8,7,1,0,4,5,6,8,9,1,0,9,9,8,4,3,2,0,3,4,5,8,9,7,6,9,9,8,9,4,2,1,2,5,9,9,8,5,4,3,],
    [7,9,8,9,8,9,8,9,6,5,4,3,4,5,6,8,9,1,3,4,5,6,8,9,3,5,8,9,6,5,3,4,5,6,7,8,9,8,7,6,5,6,7,9,9,2,1,0,5,5,6,7,8,9,4,4,3,4,7,8,9,3,2,2,5,6,7,9,9,2,1,2,9,8,7,4,2,1,2,3,6,7,8,9,5,4,5,9,9,9,3,3,4,9,8,7,9,4,3,2,],
    [8,9,7,9,7,6,7,9,9,6,5,7,6,6,7,9,1,0,2,3,7,8,9,2,1,0,9,8,7,3,2,3,4,5,8,9,8,6,7,6,4,5,6,7,8,9,2,1,3,4,5,8,9,4,3,2,2,6,7,9,8,7,6,3,4,5,6,7,8,9,2,9,8,7,6,5,6,7,3,4,5,6,7,8,9,3,4,5,9,8,9,6,5,9,7,6,5,3,1,0,],
    [9,8,6,5,6,5,6,8,8,9,6,7,7,8,8,9,2,9,3,4,6,7,8,9,2,1,2,9,6,4,1,2,3,7,8,9,9,5,4,5,3,4,5,6,9,8,9,2,4,5,6,7,8,9,9,0,1,2,9,9,9,6,5,4,5,6,7,8,9,9,3,4,9,8,7,6,6,5,4,5,9,7,8,9,1,2,9,9,9,7,8,9,7,8,9,8,7,8,2,1,],
    [8,6,5,4,3,4,5,6,7,9,8,9,8,9,9,9,9,8,9,6,7,9,9,5,3,4,9,8,4,3,2,3,5,6,7,8,9,3,2,1,2,3,4,5,6,7,8,9,7,6,9,8,9,7,8,9,2,9,8,9,8,7,6,5,6,7,8,9,9,8,9,5,6,9,8,7,8,7,5,6,9,8,9,1,0,9,8,7,5,6,7,8,9,9,3,9,8,9,3,2,],
    [7,5,4,3,2,3,4,5,7,8,9,2,9,8,9,8,8,7,8,9,8,9,7,6,9,9,7,6,5,4,4,5,7,8,9,9,6,5,3,2,3,5,6,8,7,8,9,9,8,7,8,9,5,6,7,9,9,8,7,6,9,8,8,8,7,8,9,9,8,7,8,9,7,8,9,8,9,8,6,7,8,9,3,2,1,2,9,7,4,7,8,9,2,1,2,3,9,5,4,3,],
    [5,4,3,2,1,4,3,4,5,6,9,1,9,6,5,7,6,6,7,8,9,9,8,9,8,9,8,9,7,5,7,6,8,9,9,8,7,6,5,3,4,7,9,9,8,9,0,1,9,8,9,3,4,7,8,9,8,7,8,4,7,9,9,9,8,9,8,7,9,6,7,8,9,9,4,9,9,9,7,9,9,6,5,4,8,3,9,6,5,6,7,8,9,0,1,9,8,6,5,6,],
    [8,9,6,1,0,1,2,3,6,7,8,9,8,9,4,3,4,5,6,7,8,9,9,8,7,6,9,8,7,6,8,7,8,9,9,9,8,9,5,4,5,6,8,9,9,8,9,2,9,9,8,9,5,6,9,8,7,6,4,3,5,4,4,5,9,8,9,6,5,4,6,7,8,9,2,9,8,9,8,9,8,7,6,5,7,9,8,7,6,7,8,9,5,4,2,3,9,9,6,7,],
    [7,6,4,2,1,2,3,4,5,6,9,7,6,4,3,2,3,6,7,8,9,3,2,9,7,5,6,9,8,9,9,8,9,8,7,6,9,7,6,5,6,7,9,4,5,6,9,9,8,6,7,8,9,7,8,9,8,7,3,2,1,3,3,4,6,7,8,9,6,5,7,9,9,8,9,8,7,6,9,5,9,8,7,6,7,9,9,8,9,9,9,8,7,6,3,4,9,8,7,9,],
    [8,8,4,3,2,3,4,5,6,8,9,6,5,3,2,1,2,4,5,8,9,2,1,9,5,4,7,9,9,0,1,9,8,9,8,5,9,8,8,7,8,9,4,3,6,7,8,9,9,5,6,8,9,8,9,7,6,5,4,1,0,1,2,3,4,5,7,8,9,6,8,9,3,7,9,9,6,5,4,3,2,9,8,7,8,9,9,9,8,9,9,9,8,7,4,5,6,9,8,9,],
    [9,7,5,4,5,4,5,6,7,8,9,7,6,4,3,2,4,9,6,7,8,9,9,8,9,5,6,7,8,9,9,8,7,6,5,4,3,9,9,8,9,9,9,5,7,8,9,6,5,4,6,7,9,9,9,8,7,6,9,2,3,2,4,5,5,6,9,9,8,7,9,3,2,6,7,9,9,5,4,2,1,2,9,8,9,8,9,8,7,8,9,9,9,8,5,6,7,8,9,4,],
    [9,8,9,8,7,5,8,7,8,9,8,7,6,5,4,5,7,8,9,8,9,7,6,7,8,9,9,8,9,6,7,9,8,9,8,6,2,3,6,9,9,9,8,6,7,9,7,5,4,3,4,5,6,9,9,9,8,9,8,7,4,3,5,6,9,9,8,8,9,8,9,2,1,5,6,9,8,9,6,1,0,2,3,9,8,7,6,7,6,7,8,9,9,9,9,7,8,9,4,3,],
    [9,9,9,8,7,6,7,8,9,4,9,8,8,6,5,6,8,9,6,9,3,5,5,6,9,5,4,9,4,5,9,8,9,8,9,7,3,4,5,6,8,9,9,7,8,9,6,4,3,2,3,4,9,8,7,9,9,8,7,6,5,4,5,9,8,7,6,7,8,9,9,3,2,4,9,9,7,8,9,2,1,3,9,8,8,6,5,4,5,8,9,9,8,9,8,9,9,4,3,2,],
    [8,7,8,9,9,7,8,9,4,3,2,9,9,7,6,7,9,6,5,4,2,3,4,7,8,9,2,1,2,9,8,7,6,7,8,9,5,5,6,9,9,6,4,9,9,6,5,3,2,1,4,6,9,8,6,7,9,9,8,7,8,5,9,8,7,6,5,9,9,9,8,9,3,9,8,7,6,8,9,9,2,9,8,7,6,5,4,2,6,7,9,8,7,8,7,9,8,9,2,1,],
    [9,6,8,9,9,8,9,6,5,2,1,2,9,8,7,8,9,8,7,3,1,4,5,6,7,8,9,0,9,8,9,8,5,6,7,8,9,6,7,8,9,5,3,9,8,7,8,4,4,2,9,9,8,7,5,9,8,9,9,8,9,6,7,9,7,5,4,6,6,6,7,8,9,9,8,6,5,6,7,8,9,8,9,8,6,3,2,1,2,9,9,7,6,7,6,8,7,8,9,9,],
    [6,5,6,7,8,9,7,5,4,1,0,1,2,9,8,9,7,9,6,2,0,5,6,7,9,9,9,9,9,7,6,5,4,5,6,7,9,9,9,9,6,5,4,5,9,8,7,6,5,9,8,7,6,5,4,6,7,8,9,9,8,7,9,8,6,7,3,2,4,5,6,7,8,9,6,5,4,3,8,9,5,7,8,9,5,4,1,0,9,8,7,9,5,4,5,7,6,7,7,8,],
    [4,4,8,9,9,9,5,4,3,2,1,2,3,4,9,7,6,5,4,3,1,7,8,9,5,7,9,8,7,6,5,4,3,2,4,5,9,8,9,8,7,6,7,6,7,9,8,7,6,7,9,8,7,6,3,5,6,7,8,9,9,8,9,9,5,4,2,1,3,4,5,8,9,8,7,5,3,1,2,3,4,6,6,8,9,9,2,9,9,9,6,5,4,3,1,3,4,5,6,7,],
    [3,2,3,5,7,8,9,5,4,3,2,3,5,6,9,8,7,8,5,4,5,6,9,5,4,3,4,9,8,7,6,7,2,1,2,4,8,7,8,9,8,7,8,7,8,9,9,8,9,8,9,9,8,7,4,6,9,8,9,9,9,9,9,8,7,5,3,2,3,4,6,9,6,5,4,3,2,0,1,2,3,4,5,6,7,8,9,8,9,8,7,6,5,4,2,3,5,6,7,8,],
    [2,1,2,4,6,7,8,9,6,5,3,4,6,7,8,9,8,9,6,7,8,7,8,9,3,2,1,2,9,8,7,2,1,0,1,8,7,6,7,8,9,8,9,8,9,2,1,9,8,9,4,2,9,7,6,7,8,9,9,9,8,7,6,9,8,7,6,5,4,5,9,8,7,6,5,4,4,1,5,3,4,5,6,9,8,9,7,6,7,9,8,9,6,6,5,4,7,8,9,9,],
    [1,0,1,4,5,8,9,8,7,8,4,5,6,8,9,3,9,8,7,8,9,9,9,5,4,3,0,1,2,9,7,3,2,1,2,3,4,5,8,9,8,9,9,9,9,9,9,7,7,8,9,3,9,8,8,8,9,4,9,8,7,4,5,6,9,9,8,6,6,8,9,9,8,7,6,5,6,2,3,4,6,6,9,8,9,7,6,5,4,2,9,9,8,7,8,5,8,9,4,3,],
    [2,1,2,3,5,7,8,9,8,9,5,6,9,9,0,2,3,9,8,9,7,8,9,7,5,2,1,2,9,7,6,5,4,2,4,7,5,7,8,9,7,8,9,9,9,8,7,5,6,7,8,9,1,9,9,9,5,3,9,8,6,5,6,8,9,8,9,8,8,9,6,7,9,8,7,6,7,3,4,5,6,9,8,7,9,9,5,4,3,1,2,3,9,8,9,6,9,6,5,2,],
    [3,2,3,4,5,6,7,8,9,7,6,9,8,9,4,3,4,6,9,8,6,9,8,6,5,3,2,3,9,8,7,6,4,3,5,6,7,8,9,8,6,9,9,9,9,9,5,4,7,8,9,4,3,4,9,9,9,2,1,9,7,6,8,9,6,7,9,9,9,5,5,6,6,9,8,7,6,5,5,6,9,8,7,6,7,8,9,3,2,0,2,4,5,9,8,7,8,9,4,3,],
    [4,3,4,5,9,7,8,9,9,8,9,9,7,8,9,9,5,9,8,7,5,6,9,9,8,7,6,4,5,9,8,7,6,4,6,7,8,9,8,7,5,6,9,8,9,8,7,6,9,9,7,6,9,9,8,9,8,9,9,9,9,7,9,6,5,9,8,7,5,4,3,2,4,4,9,9,8,7,8,9,9,9,8,5,9,9,9,4,3,1,2,3,7,8,9,8,9,9,6,5,],
    [5,6,5,6,8,9,9,5,6,9,8,6,6,9,6,8,9,6,5,4,3,1,2,7,9,8,7,9,6,8,9,9,8,5,7,8,9,9,9,8,4,9,8,7,6,9,8,7,8,9,8,9,8,7,6,8,6,5,7,7,8,9,6,5,4,6,9,8,4,3,2,1,2,3,4,7,9,8,9,8,9,8,9,4,8,9,7,5,4,5,9,4,5,9,9,9,9,8,7,6,],
    [6,7,8,7,9,3,2,4,9,9,7,5,4,3,5,7,8,9,6,5,4,2,4,5,6,9,9,8,7,8,9,6,9,9,8,9,9,8,8,6,3,2,9,8,5,6,9,8,9,9,9,9,7,6,5,9,5,4,5,6,7,8,9,4,3,4,5,9,5,4,3,5,3,4,5,6,7,9,8,7,9,7,8,3,7,9,8,8,6,7,8,9,6,9,8,7,8,9,9,7,],
    [7,8,9,8,9,5,3,9,8,7,6,4,3,2,3,9,9,1,9,7,5,7,5,6,7,8,9,9,8,9,7,5,4,3,9,9,8,7,6,5,4,9,8,7,4,5,8,9,9,8,8,6,6,4,4,2,1,2,6,7,8,9,0,1,2,3,4,9,6,9,7,5,4,6,6,8,9,9,7,6,5,5,1,2,6,8,9,8,7,8,9,9,9,8,8,6,8,9,9,8,],
    [8,9,9,9,6,5,4,9,9,6,5,4,4,1,2,8,9,2,9,8,9,8,9,7,8,9,3,4,9,9,8,6,3,1,3,4,9,8,7,7,8,9,9,6,3,5,7,8,9,7,6,5,4,3,2,1,0,3,7,8,9,2,1,2,3,4,9,8,9,8,9,7,5,6,7,8,9,8,6,5,4,3,2,3,5,6,7,9,8,9,2,9,8,7,6,5,7,8,9,9,],
    [9,9,9,8,9,6,9,8,7,5,4,3,1,0,1,7,9,9,9,9,3,9,9,8,9,3,2,5,6,9,8,7,5,2,3,5,6,9,8,9,9,9,8,5,2,3,4,8,9,8,7,6,6,4,3,2,1,4,8,9,7,4,2,3,5,9,8,7,8,7,8,9,6,9,9,9,6,9,7,6,5,5,3,5,6,7,9,9,9,2,1,0,9,8,5,4,5,9,8,9,],
    [9,9,9,7,9,7,8,9,9,6,6,5,2,1,2,6,7,8,9,1,2,9,8,9,3,2,1,6,7,9,9,7,6,3,4,6,7,8,9,9,8,9,6,4,1,2,6,7,8,9,9,9,7,6,5,6,2,5,9,9,6,5,4,5,9,8,7,6,7,6,5,6,9,8,9,6,5,9,8,7,6,6,5,8,7,8,9,8,9,4,3,9,8,5,4,3,2,8,7,7,],
    [9,8,8,6,8,9,9,4,2,9,8,6,3,2,4,5,6,7,9,3,9,9,7,8,9,1,0,9,9,9,9,8,7,8,9,7,8,9,9,8,7,6,5,3,2,4,5,6,9,7,6,9,8,8,9,4,3,6,7,8,9,6,7,9,8,7,6,5,4,3,4,5,6,7,8,9,4,3,9,8,9,8,6,9,8,9,8,7,8,9,9,8,7,4,3,2,1,4,6,6,],
    [8,7,6,5,6,7,8,9,1,0,9,6,4,3,7,6,8,9,9,9,8,7,6,9,8,9,9,8,7,8,4,9,8,9,9,8,9,5,4,9,9,9,5,4,4,5,6,7,8,9,4,5,9,9,6,5,4,7,8,9,9,7,9,8,9,6,5,4,3,2,3,8,7,6,9,6,4,2,9,9,9,9,7,8,9,5,5,6,7,8,9,7,6,6,4,4,0,3,5,5,],
    [7,6,5,4,5,6,9,8,9,9,8,7,5,4,8,7,9,9,9,8,9,6,5,8,7,8,9,9,5,4,3,4,9,4,3,9,9,9,2,9,9,8,7,6,7,8,7,9,9,4,3,4,9,8,7,6,6,7,9,3,4,9,7,7,9,9,4,3,2,1,2,3,4,5,9,7,9,9,8,9,9,8,9,9,5,4,4,5,6,7,8,9,5,4,3,2,1,2,3,4,],
    [6,5,4,3,4,5,6,7,8,9,9,8,9,5,6,8,9,9,8,7,8,5,4,7,6,9,9,8,9,3,2,3,5,9,2,3,9,8,9,8,9,9,8,9,8,9,8,9,3,2,2,3,6,9,9,7,8,8,9,9,9,8,6,6,7,8,9,4,1,0,1,6,5,7,8,9,8,9,6,9,8,7,6,5,4,3,2,4,4,7,9,7,6,5,5,3,5,4,4,5,],
    [5,4,3,2,5,6,7,8,9,9,9,8,7,6,7,8,9,9,7,6,6,5,3,6,5,7,6,7,8,9,9,4,9,8,9,9,8,7,6,7,9,9,9,6,9,9,9,3,2,1,0,4,5,6,7,9,9,9,9,8,7,6,5,4,7,8,9,4,2,1,2,5,6,8,9,9,7,6,5,6,9,8,9,8,5,2,1,2,3,5,6,9,8,6,7,8,7,5,6,8,],
    [4,3,2,1,2,5,6,7,8,9,9,9,9,7,8,9,8,8,6,5,4,3,2,1,4,4,5,6,7,9,8,9,9,7,9,8,7,6,5,6,7,8,9,5,6,9,5,4,3,2,1,3,4,6,9,7,6,5,4,9,8,7,6,5,6,7,8,9,3,3,3,4,5,9,9,8,7,5,4,1,0,9,8,7,6,3,2,3,5,6,7,8,9,7,8,9,8,6,7,9,],
    [5,4,3,4,3,4,5,6,7,8,9,9,8,9,9,8,7,6,5,4,3,2,1,0,2,3,4,9,9,8,7,8,5,6,7,9,8,5,4,5,9,9,3,4,9,8,9,9,4,9,9,9,5,7,8,9,5,4,3,2,9,8,7,8,9,8,9,6,5,4,6,5,8,9,8,7,6,5,3,2,1,2,9,8,7,4,3,4,8,7,8,9,9,8,9,2,9,9,8,9,],
    [6,5,6,5,6,5,6,7,9,9,5,6,7,8,9,9,8,7,6,5,4,5,2,1,4,4,9,8,9,8,6,5,3,4,9,8,7,6,5,6,7,8,9,5,9,7,7,8,9,8,7,8,9,8,9,8,6,5,9,1,2,9,8,9,4,9,8,7,6,8,7,6,7,8,9,9,8,6,4,3,2,4,5,9,8,5,4,6,7,8,9,9,8,9,9,3,9,9,9,9,],
    [7,6,7,6,7,6,8,9,2,3,4,5,6,9,9,9,9,8,7,7,5,6,7,2,5,9,8,7,9,9,5,4,2,3,8,9,8,9,6,7,8,9,6,9,8,6,6,7,8,7,6,7,9,9,3,9,9,9,8,9,4,9,9,4,2,3,9,9,8,9,8,7,8,9,9,8,9,7,5,4,3,5,9,8,7,6,5,9,8,9,6,7,6,5,7,9,8,9,8,9,],
    [8,7,8,7,8,7,9,7,3,4,5,6,7,8,9,8,9,9,8,9,9,8,9,9,9,8,7,6,7,8,9,5,4,5,7,8,9,9,8,9,9,5,4,9,6,5,4,8,3,4,5,8,9,1,2,9,8,7,7,8,9,8,9,2,1,2,9,7,9,6,9,8,9,7,8,7,8,9,6,7,4,5,8,9,8,7,8,9,9,7,5,4,5,4,4,4,7,6,7,8,],
    [9,8,9,8,9,8,9,6,5,6,7,8,9,9,8,7,8,8,9,9,9,9,9,8,7,4,9,4,8,9,9,6,5,6,7,8,9,1,9,5,8,9,9,7,5,4,3,1,2,3,7,9,9,0,9,8,7,6,5,5,6,7,8,9,0,9,7,6,4,5,6,9,2,5,4,6,9,9,9,8,5,6,7,8,9,8,9,7,6,5,4,3,2,2,3,3,4,5,8,9,],
    [8,9,6,9,3,9,8,7,9,7,9,9,6,5,4,5,9,7,8,8,9,9,9,7,6,3,2,3,6,7,8,9,6,7,9,9,1,0,2,4,7,8,9,8,7,6,1,0,6,5,6,7,8,9,9,9,8,5,4,3,4,5,6,7,9,9,8,7,3,2,1,0,1,2,3,5,6,7,8,9,6,9,8,9,7,9,9,8,8,5,4,3,1,0,1,2,3,4,5,9,],
    [7,6,5,4,2,4,9,8,9,9,9,7,5,3,2,3,4,5,6,7,8,9,9,8,5,2,1,4,5,6,7,8,9,8,9,4,2,1,9,5,6,7,8,9,9,8,2,1,7,8,7,9,9,9,9,8,7,6,5,2,4,5,6,7,9,8,6,5,4,4,2,1,2,3,4,6,9,8,9,9,8,9,9,7,6,7,9,9,9,6,5,9,2,4,2,6,5,6,7,8,],
    [8,6,5,2,1,3,5,9,8,7,9,7,6,8,9,6,5,6,8,9,9,9,9,5,3,1,0,7,9,9,8,9,2,9,7,6,9,9,8,9,8,9,9,9,9,9,3,5,6,9,8,9,9,9,8,7,6,5,2,1,3,4,5,6,9,8,7,6,5,6,4,3,4,5,8,7,8,9,6,4,9,2,4,5,5,6,7,8,9,9,9,8,9,5,6,9,6,7,9,9,],
    [9,5,4,3,2,9,9,8,7,6,9,8,9,9,8,7,6,8,9,6,5,9,8,6,4,3,1,5,7,8,9,3,1,9,8,9,8,8,7,8,9,8,9,8,7,6,4,6,7,9,9,9,9,8,9,8,7,4,3,0,1,3,4,5,6,9,9,7,8,6,5,4,7,9,9,8,9,5,4,3,2,1,2,3,4,5,8,9,9,8,7,6,8,9,9,8,9,8,9,2,],
    [7,6,5,4,9,8,7,6,6,4,6,9,8,9,9,8,7,9,6,5,4,9,8,7,4,3,2,3,4,9,8,9,0,1,9,9,7,6,5,9,8,7,8,9,8,7,5,7,8,9,9,7,7,7,9,7,6,5,4,3,2,4,5,6,7,8,9,9,8,7,8,5,6,8,9,9,9,6,7,4,3,2,3,5,5,6,7,8,9,9,6,5,7,8,6,7,8,9,2,1,],
    [9,9,6,5,7,9,9,5,4,3,5,6,7,8,9,9,9,8,7,8,5,6,9,7,5,4,3,4,5,6,7,8,9,2,9,8,7,5,4,3,6,5,6,8,9,8,9,8,9,9,8,6,5,6,9,8,7,6,7,5,3,6,9,7,8,9,7,5,9,8,7,6,7,9,7,7,8,9,8,6,4,5,6,9,8,7,8,9,9,7,5,4,5,7,5,6,8,9,1,0,],
    [9,8,9,9,8,9,8,6,3,2,3,5,6,7,9,2,1,9,8,9,7,7,8,9,6,5,6,5,6,7,8,9,6,9,8,7,6,5,3,2,3,4,5,6,8,9,9,9,5,9,8,7,4,3,2,9,8,7,8,8,4,7,8,9,9,6,6,4,4,9,8,7,8,9,5,6,7,8,9,8,7,6,8,9,9,8,9,9,7,6,4,3,2,5,4,5,7,8,9,1,],
    [6,6,7,8,9,9,7,6,5,3,4,5,8,9,9,9,2,9,9,9,8,9,9,7,9,8,7,6,7,9,9,3,4,9,8,6,5,4,3,1,3,3,4,6,7,8,9,5,3,2,9,4,3,2,1,0,9,8,7,6,5,7,8,9,6,5,4,3,2,3,9,8,9,3,4,5,9,9,9,9,8,8,9,6,7,9,9,8,9,5,5,2,1,2,3,4,5,7,8,9,],
    [4,5,9,9,2,9,8,9,6,4,5,7,8,9,9,8,9,8,8,9,9,8,9,6,8,9,8,7,8,9,1,2,3,4,9,8,6,2,1,0,1,2,3,6,8,9,9,6,4,4,9,8,7,5,3,1,2,9,8,7,7,8,9,7,6,5,4,3,1,2,9,9,3,2,3,4,7,8,9,9,9,9,6,5,4,9,8,7,7,4,2,1,0,1,2,3,4,6,9,9,],
    [3,9,8,9,1,2,9,7,6,5,6,7,9,9,9,7,6,6,7,9,8,7,8,9,9,9,9,8,9,1,0,1,2,9,8,7,6,4,3,3,2,3,4,5,8,9,8,7,6,5,6,9,8,7,6,5,3,4,9,8,8,9,9,8,9,7,3,2,0,9,8,9,4,3,6,5,6,7,8,9,1,9,8,6,9,8,7,6,5,4,3,2,3,2,3,4,8,7,8,9,],
    [2,8,7,8,9,3,9,8,7,6,7,9,9,8,9,6,5,4,3,5,6,6,9,9,9,8,7,9,3,2,1,2,3,6,9,9,7,6,4,5,3,4,5,6,7,9,9,8,7,8,9,3,9,9,7,6,9,9,9,9,9,5,2,9,9,9,4,6,9,8,7,6,5,4,8,9,7,9,9,2,0,1,9,7,8,9,9,7,6,5,4,3,4,3,4,6,9,8,9,2,],
    [3,4,6,7,8,9,9,9,8,7,9,8,6,7,8,9,4,3,2,3,5,5,6,9,8,7,6,5,4,3,2,3,4,5,6,9,8,9,8,7,4,5,6,7,8,9,2,9,8,9,3,2,3,9,8,9,8,8,9,6,5,4,1,0,9,8,9,9,8,9,8,7,6,5,6,9,8,9,5,4,1,2,3,9,9,9,8,9,7,6,5,4,9,9,5,9,8,9,2,1,],
    [5,6,7,9,9,7,9,9,9,9,8,9,5,6,7,8,9,2,1,2,3,4,5,6,9,9,8,9,5,4,3,4,5,6,7,8,9,9,9,8,9,8,7,8,9,1,0,1,9,6,4,3,5,9,9,8,7,7,8,9,6,3,2,9,8,7,9,8,7,9,9,9,9,6,7,8,9,7,6,5,2,3,9,8,9,8,7,8,9,7,9,9,8,8,9,8,7,9,3,2,],
    [6,7,8,9,5,6,8,9,8,7,7,8,4,5,6,9,9,9,0,1,4,6,6,7,8,9,9,8,6,5,6,5,6,7,8,9,9,9,6,9,8,9,8,9,8,9,9,9,8,7,5,4,9,8,8,7,5,6,8,9,9,4,9,9,7,6,4,7,6,8,9,9,8,7,8,9,8,9,7,9,4,9,8,7,6,7,6,7,9,8,9,8,7,7,6,5,6,8,9,3,],
    [9,8,9,3,4,9,9,9,7,6,5,4,3,4,7,8,9,8,9,2,3,6,7,8,9,2,3,9,7,6,7,8,9,8,9,9,8,7,5,6,7,8,9,8,7,8,8,9,9,8,6,9,8,7,6,6,4,5,7,9,8,9,8,7,6,5,3,4,5,6,7,9,9,8,9,8,7,8,9,4,9,8,7,6,5,4,5,6,7,9,9,7,6,5,3,4,6,7,8,9,],
    [6,9,1,2,9,8,7,6,6,5,4,2,1,2,9,9,8,7,9,3,4,5,6,7,8,9,4,9,8,7,9,9,8,9,9,7,6,5,4,5,6,9,8,7,6,5,7,8,9,9,7,9,8,6,5,4,3,4,6,8,7,8,9,8,4,3,2,5,6,7,8,9,5,9,6,5,6,8,9,3,9,8,7,5,4,3,4,5,6,7,8,9,7,4,2,3,5,6,9,9,],
    [5,4,3,9,8,7,6,5,4,3,2,1,0,9,8,7,7,6,9,9,6,7,8,9,9,9,9,9,9,8,9,5,6,7,8,9,5,4,3,1,9,8,7,5,4,3,6,9,5,4,9,1,9,8,4,3,2,3,4,5,6,9,8,9,9,4,3,4,5,8,9,5,4,3,9,7,8,9,9,9,9,9,6,6,5,2,6,5,6,6,7,8,9,5,1,2,7,6,7,8,],
    [6,5,4,5,9,9,7,6,5,4,5,2,1,9,7,6,4,5,8,8,9,9,9,1,0,9,8,9,9,9,6,4,6,8,9,8,6,5,3,2,3,9,8,6,5,4,5,9,9,3,9,2,3,9,5,6,6,4,6,7,7,9,7,9,8,9,4,5,6,8,9,6,5,9,8,9,9,5,9,8,7,6,5,4,3,1,2,3,4,5,6,7,8,9,0,2,4,5,6,8,],
    [7,6,6,6,7,9,8,7,6,6,4,3,9,8,9,4,3,4,6,7,7,8,9,2,9,8,7,8,9,8,7,3,4,7,8,9,7,7,4,7,4,9,8,7,6,5,6,7,8,9,8,9,9,8,7,7,7,5,8,9,9,8,6,6,7,8,9,7,8,9,9,9,9,8,7,8,9,4,3,9,9,7,6,5,1,0,1,6,5,6,7,8,9,2,1,2,3,4,5,6,],
    [8,7,8,9,8,9,9,8,7,6,5,9,8,7,8,9,2,3,4,5,6,7,8,9,8,9,6,9,8,7,6,4,5,6,7,9,8,8,5,6,5,6,9,8,7,6,7,8,9,7,7,8,9,9,8,9,8,6,7,9,8,7,5,4,9,8,9,8,9,9,9,8,9,7,6,6,9,5,9,8,9,8,7,6,4,3,2,3,4,5,6,7,8,9,2,3,6,7,6,8,],
    [9,8,9,8,9,9,9,9,8,7,6,9,7,6,5,5,1,3,9,8,7,9,9,8,7,6,5,5,9,8,7,8,9,8,9,4,9,9,8,7,8,9,9,9,8,7,8,9,4,5,6,6,9,8,9,9,8,7,9,8,6,5,4,3,4,7,8,9,9,9,8,7,6,7,4,5,8,9,8,7,5,9,8,7,7,4,6,7,8,9,7,8,9,7,3,4,5,6,7,9,],
    [8,9,6,7,9,9,8,7,9,9,7,9,8,7,4,3,0,1,6,7,9,1,0,9,8,9,4,3,4,9,8,9,2,9,9,5,6,7,9,8,9,9,9,8,9,8,9,1,3,4,5,5,6,7,8,9,9,9,8,7,6,5,4,2,3,5,9,9,9,8,7,6,5,6,3,6,7,8,9,5,4,2,9,7,6,5,7,8,9,4,9,9,8,5,4,9,8,7,8,9,],
    [7,6,4,9,8,7,6,5,4,9,8,9,9,7,5,2,1,4,5,8,9,2,9,8,7,6,3,2,3,4,9,5,4,7,8,9,7,8,9,9,4,9,8,7,6,9,1,0,1,2,3,4,5,8,9,2,1,2,9,8,7,6,5,6,7,6,7,8,9,9,4,4,3,3,2,3,4,9,8,9,3,1,9,8,7,9,8,9,5,3,9,8,7,6,5,6,9,8,9,3,],
    [8,4,3,2,9,8,7,6,3,2,9,9,9,8,6,3,2,3,6,7,8,9,8,7,6,5,4,5,6,7,8,9,5,6,7,8,9,9,0,2,3,4,9,8,5,4,2,1,3,4,5,5,6,7,8,9,0,3,4,9,8,9,8,7,8,9,8,9,5,4,3,2,1,0,1,4,5,6,7,8,9,0,1,9,8,9,9,4,3,2,1,9,8,7,6,8,9,9,1,2,],
    ]
}