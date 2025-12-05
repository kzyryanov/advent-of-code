//
//  Puzzle05ViewModel.swift
//  Advent2025
//
//  Created by Konstantin on 2025-12-05.
//

import SwiftUI

@Observable
final class Puzzle05ViewModel: PuzzleViewModel {
    let puzzle: Puzzle
    
    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }
    
    func solveOne(input: String, isTest: Bool) async -> String {
        let (ranges, ingredientIds) = data(from: input)
        
        let freshIngredients = ingredientIds.filter { ingredientId in
            ranges.contains(where: { $0.contains(ingredientId) })
        }
        
        let result = freshIngredients.count
        
        return "\(result)"
    }
    
    func solveTwo(input: String, isTest: Bool) async -> String {
        let (ranges, _) = data(from: input)
        
        let sorted = ranges.sorted(by: { $0.lowerBound < $1.lowerBound })
        
        var mergedRanges: [ClosedRange<Int>] = []
        
        for range in sorted {
            var newMergedRanges: [ClosedRange<Int>] = []
            var merged: Bool = false
            
            for mergedRange in mergedRanges {
                if mergedRange.contains(range.lowerBound) {
                    newMergedRanges.append(mergedRange.lowerBound...max(range.upperBound, mergedRange.upperBound))
                    merged = true
                } else if range.contains(mergedRange.lowerBound) {
                    newMergedRanges.append(range.lowerBound...max(range.upperBound, mergedRange.upperBound))
                    merged = true
                } else if mergedRange.contains(range.upperBound) {
                    newMergedRanges.append(min(range.lowerBound, mergedRange.lowerBound)...mergedRange.upperBound)
                    merged = true
                } else if range.contains(mergedRange.upperBound) {
                    newMergedRanges.append(min(range.lowerBound, mergedRange.lowerBound)...mergedRange.upperBound)
                    merged = true
                } else {
                    newMergedRanges.append(mergedRange)
                }
            }
            
            if !merged {
                newMergedRanges.append(range)
            }
            
            mergedRanges = newMergedRanges
        }

        let result = mergedRanges.map(\.count).reduce(0, +)
        
        return "\(result)"
    }
    
    func data(from input: String) -> (ranges: [ClosedRange<Int>], ingredientIds: [Int]) {
        let components = input
            .split(separator: "\n\n")
            .filter(\.isNotEmpty)
        
        let ranges: [ClosedRange<Int>] = components[0].lines.filter(\.isNotEmpty).map {
            let bounds = $0.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "-").compactMap {
                Int(String($0))
            }
            
            return bounds[0]...bounds[1]
        }
        
        let ingredientIds: [Int] = components[1].lines.filter(\.isNotEmpty).map { Int($0)! }
        
        return (ranges, ingredientIds)
    }
}
