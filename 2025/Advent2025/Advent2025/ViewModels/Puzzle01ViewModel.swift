//
//  Puzzle01ViewModel.swift
//  Advent2025
//
//  Created by Konstantin on 2025-12-01.
//

import SwiftUI

@Observable
final class Puzzle01ViewModel: PuzzleViewModel {
    let puzzle: Puzzle
    
    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }
    
    func solveOne(input: String, isTest: Bool) async -> String {
        let rotations = data(from: input)
        
        var position = 50
        
        var zeroesCount = 0
        
        for rotation in rotations {
            switch rotation {
            case .left(let value):
                position = (position - value + 100) % 100
            case .right(let value):
                position = (position + value) % 100
            }
            
            if position == 0 {
                zeroesCount += 1
            }
        }
        
        let result = zeroesCount
        
        return "\(result)"
    }
    
    func solveTwo(input: String, isTest: Bool) async -> String {
        let rotations = data(from: input)
        
        var position = 50
        
        var zeroesCount = 0
        
        for rotation in rotations {
            var sign: Int
            var value: Int
            switch rotation {
            case .left(let v):
                value = v
                sign = -1
            case .right(let v):
                value = v
                sign = 1
            }
            
            for _ in 0..<value {
                position += sign
                if position == 0 {
                    zeroesCount += 1
                    print(rotation, zeroesCount)
                } else if position >= 100 {
                    position = 0
                    zeroesCount += 1
                    print(rotation, zeroesCount)
                } else if position < 0 {
                    position = 99
                }
            }
        }
        
        let result = zeroesCount
        
        return "\(result)"
    }
    
    func data(from input: String) -> [Rotation] {
        let lines = input.lines.filter(\.isNotEmpty).map(String.init)
        
        let rotations = try? lines.map(Rotation.init)
        
        return rotations ?? []
    }
}

extension Puzzle01ViewModel {
    enum Rotation: CustomStringConvertible {
        case left(Int)
        case right(Int)
        
        init (from string: String) throws {
            let prefix = string.prefix(1)
            let suffix = string.dropFirst()
            
            let intValue = Int(suffix) ?? 0
            
            switch prefix {
            case "L":
                self = .left(intValue)
            case "R":
                self = .right(intValue)
            default:
                throw CustomError.cannotParse(string)
            }
        }
        
        var description: String {
            switch self {
            case .left(let value):
                "L\(value)"
            case .right(let value):
                "R\(value)"
            }
        }
    }
}
