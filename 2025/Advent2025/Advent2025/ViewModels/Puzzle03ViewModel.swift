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
    
    private func solve(banks: [[Int]], batteriesCount: Int) async -> Int {
        await withTaskGroup(of: Int.self) { group in
            for bank in banks {
                group.addTask {
                    var maxJoltage: Int = 0
                    
                    var rest = bank
                    
                    for i in 1...batteriesCount {
                        maxJoltage *= 10
                        
                        let prefix = rest.dropLast(batteriesCount-i)
                        let maxPrefix = prefix.enumerated().max(by: { $0.element < $1.element })!
                        rest = Array(rest.dropFirst(maxPrefix.offset + 1))
                        maxJoltage += maxPrefix.element
                    }
                    
                    return maxJoltage
                }
            }
            return await group.reduce(0, +)
        }
    }
    
    func solveOne(input: String, isTest: Bool) async -> String {
        let banks = data(from: input)
        
        let result = await solve(banks: banks, batteriesCount: 2)
        
        return "\(result)"
    }
    
    func solveTwo(input: String, isTest: Bool) async -> String {
        let banks = data(from: input)
        
        let result = await solve(banks: banks, batteriesCount: 12)
        
        return "\(result)"
    }
    
    func data(from input: String) -> [[Int]] {
        let batteries = input.lines
            .filter(\.isNotEmpty)
            .map { $0.map { Int(String($0))! } }
        
        return batteries
    }
}
