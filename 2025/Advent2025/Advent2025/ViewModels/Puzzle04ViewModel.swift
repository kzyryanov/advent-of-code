//
//  Puzzle04ViewModel.swift
//  Advent2025
//
//  Created by Konstantin on 2025-12-04.
//

import SwiftUI

@Observable
final class Puzzle04ViewModel: PuzzleViewModel {
    let puzzle: Puzzle
    
    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }
    
    private func buildAdjacentMap(from paperRolls: [Point: Bool]) -> [Point: Int] {
        var adjacentMap: [Point: Int] = [:]
        
        for (point, _) in paperRolls {
            for direction in Direction.allCases {
                let newPoint = direction.move(from: point)
                adjacentMap[newPoint] = adjacentMap[newPoint, default: 0] + 1
            }
        }
        
        return adjacentMap
    }
    
    func filter(
        paperRolls: [Point: Bool],
        byAdjacentMap adjacentMap: [Point: Int],
        removed: Bool
    ) -> [Point: Bool] {
        paperRolls.filter { (point, _) in
            if adjacentMap[point, default: 0] < 4 {
                return removed
            }
            return !removed
        }
    }
    
    func solveOne(input: String, isTest: Bool) async -> String {
        let (paperRolls, _) = data(from: input)
        
        let adjacentMap: [Point: Int] = buildAdjacentMap(from: paperRolls)
        
        let result = filter(
            paperRolls: paperRolls,
            byAdjacentMap: adjacentMap,
            removed: true
        ).count
        
        return "\(result)"
    }
    
    func solveTwo(input: String, isTest: Bool) async -> String {
        let (originalPaperRolls, _) = data(from: input)
        
        var paperRolls = originalPaperRolls
        var removed = false
        
        repeat {
            guard !Task.isCancelled else { return "Cancelled" }
            let adjacentMap: [Point: Int] = buildAdjacentMap(from: paperRolls)
            let newPaperRolls = filter(
                paperRolls: paperRolls,
                byAdjacentMap: adjacentMap,
                removed: false
            )
            
            removed = newPaperRolls.count != paperRolls.count
            
            paperRolls = newPaperRolls
        } while removed
        
        let result = originalPaperRolls.count - paperRolls.count
        
        return "\(result)"
    }
    
    func data(from input: String) -> (map: [Point: Bool], size: Size) {
        var maxX: Int = 0
        var maxY: Int = 0
        let paperRolls = Dictionary(
            uniqueKeysWithValues: input.lines
                .filter(\.isNotEmpty)
                .enumerated()
                .flatMap { row, line in
                    maxY = max(maxY, row)
                    return line.enumerated().compactMap { column, symbol in
                        maxX = max(maxX, column)
                        if symbol == "@" {
                            return (Point(x: column, y: row), true)
                        }
                        return nil
                    }
                }
        )
        
        return (paperRolls, Size(width: maxX + 1, height: maxY + 1))
    }
}
