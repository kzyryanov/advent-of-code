//
//  puzzle05.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-05.
//

import Foundation

func puzzle05() {
    print("Test")
    print("One")
    one(input: testInput05)
    print("Two")
    two(input: testInput05)

    print("")
    print("Real")
    print("One")
    one(input: input05)
    print("Two")
    two(input: input05)
}

private func one(input: String) {
    let components = input.components(separatedBy: "\n\n")
    
    let stackDescription = components[0].components(separatedBy: "\n")
    
    let symbols: Set<Character> = [ "[", "]", " " ]
    
    let stackTransposed = stackDescription.map { line in
        let line = line + " "
        let chunks = Array(line).chunked(into: 4).map {
            $0.filter { element in
                !symbols.contains(element)
            }
        }
        
        return chunks
    }
    
    var stackInverted: [[Character]] = Array(repeating: [], count: stackTransposed.first!.count)
    
    for rowTransposedIndex in 0..<stackTransposed.count {
        for columnTransposedIndex in 0..<stackTransposed[rowTransposedIndex].count {
            let element = stackTransposed[rowTransposedIndex][columnTransposedIndex]
            var stackRow = stackInverted[columnTransposedIndex]
            if !element.isEmpty {
                stackRow.append(element.first!)
            }
            stackInverted[columnTransposedIndex] = stackRow
        }
    }
    
    var stack = stackInverted.map {
        Array($0.reversed())
    }
    
    let moves = components[1].components(separatedBy: "\n").map { moveString in
        let components = moveString.components(separatedBy: " ")
        let count = Int(components[1])!
        let from = Int(components[3])! - 1 // make it index of array 
        let to = Int(components[5])! - 1 // make it index of array
        return Move(from: from, to: to, count: count)
    }
    
    for move in moves {
        let movedElements = stack[move.from].suffix(move.count)
        stack[move.from].removeLast(move.count)
        stack[move.to].append(contentsOf: movedElements.reversed())
    }
    
    let result = String(stack.compactMap { $0.last })
    print("Result: \(result)")
}

private func two(input: String) {
    let components = input.components(separatedBy: "\n\n")
    
    let stackDescription = components[0].components(separatedBy: "\n")
    
    let symbols: Set<Character> = [ "[", "]", " " ]
    
    let stackTransposed = stackDescription.map { line in
        let line = line + " "
        let chunks = Array(line).chunked(into: 4).map {
            $0.filter { element in
                !symbols.contains(element)
            }
        }
        
        return chunks
    }
    
    var stackInverted: [[Character]] = Array(repeating: [], count: stackTransposed.first!.count)
    
    for rowTransposedIndex in 0..<stackTransposed.count {
        for columnTransposedIndex in 0..<stackTransposed[rowTransposedIndex].count {
            let element = stackTransposed[rowTransposedIndex][columnTransposedIndex]
            var stackRow = stackInverted[columnTransposedIndex]
            if !element.isEmpty {
                stackRow.append(element.first!)
            }
            stackInverted[columnTransposedIndex] = stackRow
        }
    }
    
    var stack = stackInverted.map {
        Array($0.reversed())
    }
    
    let moves = components[1].components(separatedBy: "\n").map { moveString in
        let components = moveString.components(separatedBy: " ")
        let count = Int(components[1])!
        let from = Int(components[3])! - 1 // make it index of array 
        let to = Int(components[5])! - 1 // make it index of array
        return Move(from: from, to: to, count: count)
    }
    
    for move in moves {
        let movedElements = stack[move.from].suffix(move.count)
        stack[move.from].removeLast(move.count)
        stack[move.to].append(contentsOf: movedElements)
    }
    
    let result = String(stack.compactMap { $0.last })
    print("Result: \(result)")
}

private struct Move {
    let from: Int
    let to: Int
    let count: Int
}
