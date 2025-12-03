//
//  Puzzle03ViewModel.swift
//  Advent2025
//
//  Created by Konstantin on 2025-12-03.
//

import SwiftUI

@Observable
final class Puzzle03ViewModel: PuzzleViewModel {
    let puzzle: Puzzle
    
    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }
    
    func solveOne(input: String, isTest: Bool) async -> String {
        let banks = data(from: input)
        
        let maxJoltages = banks.map { bank in
            let prefix = bank.dropLast()
            let maxPrefix = prefix.enumerated().max(by: { $0.element < $1.element })!
            let suffix = bank.dropFirst(maxPrefix.offset + 1)
            let maxSuffix = suffix.max()!
            
            return maxPrefix.element * 10 + maxSuffix
        }
        
        let result = maxJoltages.reduce(0, +)
        
        return "\(result)"
    }
    
    func solveTwo(input: String, isTest: Bool) async -> String {
        let banks = data(from: input)
        
        let maxJoltages = banks.map { bank in
            var maxJoltage: Int = 0
            
            var rest = bank
            
            for i in 1...12 {
                maxJoltage *= 10
                
                let prefix = rest.dropLast(12-i)
                let maxPrefix = prefix.enumerated().max(by: { $0.element < $1.element })!
                rest = Array(rest.dropFirst(maxPrefix.offset + 1))
                maxJoltage += maxPrefix.element
            }
            
            return maxJoltage
        }
        
        let result = maxJoltages.reduce(0, +)
        
        return "\(result)"
    }
    
    func data(from input: String) -> [[Int]] {
        let batteries = input.lines
            .filter(\.isNotEmpty)
            .map { $0.map { Int(String($0))! } }
        
        return batteries
    }
}
