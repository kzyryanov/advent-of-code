//
//  Puzzle08ViewModel.swift
//  Advent2025
//
//  Created by Konstantin on 2025-12-22.
//

import SwiftUI

@Observable
final class Puzzle08ViewModel: PuzzleViewModel {
    let puzzle: Puzzle
    
    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }
    
    func solveOne(input: String, isTest: Bool) async -> String {
        let boxes = data(from: input)
        
        let connections = isTest ? 10 : 1000
        
        var pairs: [Set<Point3>: Int] = [:]
        
        var tmpBoxes = boxes
        while tmpBoxes.isNotEmpty {
            let box = tmpBoxes.removeLast()
            for other in boxes where other != box {
                pairs[[box, other]] = box.distanceSquared(from: other)
            }
        }
        
        var sorted = pairs.sorted(by: { $0.value > $1.value })
        
        var clusters: Set<Set<Point3>> = []
        
        for _ in 1...connections {
            guard !Task.isCancelled else {
                return "Cancelled"
            }
            let (pair, _) = sorted.removeLast()
            var newClusters: Set<Set<Point3>> = []
            var addedToClusters: Set<Set<Point3>> = []
            for cluster in clusters {
                guard !Task.isCancelled else {
                    return "Cancelled"
                }
                if cluster.intersection(pair).isNotEmpty {
                    let newCluster = cluster.union(pair)
                    newClusters.insert(newCluster)
                    addedToClusters.insert(newCluster)
                } else {
                    newClusters.insert(cluster)
                }
            }
            if addedToClusters.isEmpty {
                newClusters.insert(pair)
            } else {
                let union: Set<Point3> = addedToClusters.reduce([], { $0.union($1) })
                for cluster in addedToClusters {
                    newClusters.remove(cluster)
                }
                newClusters.insert(union)
                
            }
            
            clusters = newClusters
        }
        
        let result = clusters
            .map(\.count)
            .sorted(by: >)
            .prefix(3)
            .reduce(1, *)
        
        return "\(result)"
    }
    
    func solveTwo(input: String, isTest: Bool) async -> String {
        let boxes = data(from: input)
        
        var pairs: [Set<Point3>: Int] = [:]
        
        var tmpBoxes = boxes
        while tmpBoxes.isNotEmpty {
            let box = tmpBoxes.removeLast()
            for other in boxes where other != box {
                pairs[[box, other]] = box.distanceSquared(from: other)
            }
        }
        
        var sorted = pairs.sorted(by: { $0.value > $1.value })
        
        var clusters: Set<Set<Point3>> = []
        
        var finalConnection: Set<Point3>? = nil
        
        repeat {
            guard !Task.isCancelled else {
                return "Cancelled"
            }
            let (pair, _) = sorted.removeLast()
            var newClusters: Set<Set<Point3>> = []
            var addedToClusters: Set<Set<Point3>> = []
            for cluster in clusters {
                guard !Task.isCancelled else {
                    return "Cancelled"
                }
                if cluster.intersection(pair).isNotEmpty {
                    let newCluster = cluster.union(pair)
                    newClusters.insert(newCluster)
                    addedToClusters.insert(newCluster)
                } else {
                    newClusters.insert(cluster)
                }
            }
            if addedToClusters.isEmpty {
                newClusters.insert(pair)
            } else {
                let union: Set<Point3> = addedToClusters.reduce([], { $0.union($1) })
                for cluster in addedToClusters {
                    newClusters.remove(cluster)
                }
                newClusters.insert(union)
                
            }
            
            clusters = newClusters
            
            if clusters.first?.count == boxes.count {
                finalConnection = pair
            }
        } while finalConnection == nil
        
        let result = finalConnection!
            .map(\.x)
            .reduce(1, *)
        
        return "\(result)"
    }
    
    func data(from input: String) -> [Point3] {
        let lines = input.lines.filter(\.isNotEmpty)
        
        let boxes = lines.map {
            let points = $0.components(separatedBy: ",")
            return Point3(x: Int(points[0])!, y: Int(points[1])!, z: Int(points[2])!)
        }
        
        return boxes
    }
}
