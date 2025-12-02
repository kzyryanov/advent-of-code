//
//  Puzzle02ViewModel.swift
//  Advent2025
//
//  Created by Konstantin on 2025-12-02.
//

import SwiftUI

@Observable
final class Puzzle02ViewModel: PuzzleViewModel {
    let puzzle: Puzzle
    
    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }
    
    func solveOne(input: String, isTest: Bool) async -> String {
        let ranges = data(from: input)
        
        var ids: [Int] = []
        
        for range in ranges {
            let intRange = Int(range.lowerBound)!...Int(range.upperBound)!
            
            let lowerString = range.lowerBound
            let lowerHafString = lowerString.prefix(Int(floor(Double(lowerString.count) * 0.5)))
            let lowerHalf = Int(lowerHafString) ?? 0
            
            let upperString = range.upperBound
            let upperHafString = upperString.prefix(Int(ceil(Double(upperString.count) * 0.5)))
            let upperHalf = Int(upperHafString) ?? intRange.upperBound
            
            for i in lowerHalf...upperHalf {
                let value = Int("\(i)\(i)")!
                if intRange.contains(value) {
                    ids.append(value)
                }
            }
        }
        
        let result = ids.reduce(0, +)
        
        return "\(result)"
    }
    
    func solveTwo(input: String, isTest: Bool) async -> String {
        let ranges = data(from: input)
        
        var ids: Set<Int> = []
        
        func checkPattern(_ pattern: String, range: (lowerBound: String, upperBound: String)) {
            let patternCount = pattern.count
            let lowerCount = range.lowerBound.count
            let upperCount = range.upperBound.count
            
            if patternCount * 2 > upperCount {
                return
            }
            
            let intRange = Int(range.lowerBound)!...Int(range.upperBound)!
            
            let repeatLowerCount = lowerCount / patternCount
            let lowerValueString = Array(repeating: pattern, count: repeatLowerCount).joined(separator: "")
            let lowerValue = Int(lowerValueString)
            
            if let lowerValue, intRange.contains(lowerValue), repeatLowerCount > 1 {
                ids.insert(lowerValue)
            }
            
            let repeatUpperCount = Int(ceil(Double(upperCount) / Double(patternCount)))
            let upperValueString = Array(repeating: pattern, count: repeatUpperCount).joined(separator: "")
            let upperValue = Int(upperValueString)
            
            if let upperValue, intRange.contains(upperValue), repeatUpperCount > 1 {
                ids.insert(upperValue)
            }
            
            if (patternCount + 1) * 2 > upperCount {
                return
            }
            for i in 0...9 {
                guard !Task.isCancelled else {
                    return
                }
                checkPattern("\(pattern)\(i)", range: range)
            }
        }
        
        for range in ranges {
            guard !Task.isCancelled else {
                return "Cancelled"
            }
            
            for i in 1...9 {
                guard !Task.isCancelled else {
                    return "Cancelled"
                }
                checkPattern("\(i)", range: range)
            }
        }

        let result = ids.reduce(0, +)
        
        return "\(result)"
    }
    
    func data(from input: String) -> [(lowerBound: String, upperBound: String)] {
        let ranges = input.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ",")
            .map {
                let bounds = $0.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "-").compactMap {
                    String($0)
                }
                
                return (bounds[0], bounds[1])
            }
        
        return ranges
    }
}
