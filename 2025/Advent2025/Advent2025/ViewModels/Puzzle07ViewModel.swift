//
//  Puzzle07ViewModel.swift
//  Advent2025
//
//  Created by Konstantin on 2025-12-07.
//

import SwiftUI

@Observable
final class Puzzle07ViewModel: PuzzleViewModel {
    let puzzle: Puzzle
    
    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }
    
    func solveOne(input: String, isTest: Bool) async -> String {
        let (start, splitters, size) = data(from: input)
        
        var beams: Set<Int> = [start]
        
        var splitCount = 0
        
        for y in 1..<size.height {
            if let splittersRow = splitters[y], splittersRow.isNotEmpty {
                var newBeams: Set<Int> = []
                for beam in beams {
                    if splittersRow[beam, default: false] {
                        newBeams.insert(beam-1)
                        newBeams.insert(beam+1)
                        splitCount += 1
                    } else {
                        newBeams.insert(beam)
                    }
                }
                beams = newBeams
            }
        }
        
        let result = splitCount
        
        return "\(result)"
    }
    
    func solveTwo(input: String, isTest: Bool) async -> String {
        let (start, splitters, size) = data(from: input)
        
        var beams: [Int: Int] = [start: 1]
        
        for y in 1..<size.height {
            if let splittersRow = splitters[y], splittersRow.isNotEmpty {
                var newBeams: [Int: Int] = [:]
                for (x, count) in beams {
                    if splittersRow[x, default: false] {
                        newBeams[x-1] = newBeams[x-1, default: 0] + count
                        newBeams[x+1] = newBeams[x+1, default: 0] + count
                    } else {
                        newBeams[x] = newBeams[x, default: 0] + count
                    }
                }
                beams = newBeams
            }
        }

        let result = beams.values.reduce(0, +)
        
        return "\(result)"
    }
    
    func data(from input: String) -> (start: Int, splitters: [Int: [Int: Bool]], size: Size) {
        let lines = input.lines.filter(\.isNotEmpty)
        
        var start: Int = .zero
        var splitters: [Int: [Int: Bool]] = [:]
        var size: Size = .zero
        
        for (row, line) in lines.enumerated() {
            size.width = max(size.width, line.count)
            
            for (column, symbol) in line.enumerated() {
                switch symbol {
                case "S":
                    start = column
                case "^":
                    var splittersRow = splitters[row, default: [:]]
                    splittersRow[column] = true
                    splitters[row] = splittersRow
                default: break
                }
            }
        }
        
        size.height = lines.count
        
        return (start, splitters, size)
    }
}
