//
//  Puzzle23ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2025-01-17.
//

import SwiftUI

@Observable
final class Puzzle23ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String, isTest: Bool) async -> String {
        let connections = data(from: input)
        var reversedConnections: [String: Set<String>] = [:]

        for (key, value) in connections {
            for v in value {
                var set = reversedConnections[v, default: []]
                set.insert(key)
                reversedConnections[v] = set
            }
        }

        func mapConnections(connections: [String: Set<String>], reversedConnections: [String: Set<String>]) -> [Set<String>] {
            connections.flatMap { one, value in
                value.flatMap { two in
                    if let threes = connections[two] {
                        return threes.compactMap { three -> Set<String>? in
                            if let reversed = reversedConnections[three], reversed.contains(one) {
                                if one.hasPrefix("t") || two.hasPrefix("t") || three.hasPrefix("t") {
                                    return [one, two, three]
                                }
                            }
                            if let connection = connections[three], connection.contains(one) {
                                if one.hasPrefix("t") || two.hasPrefix("t") || three.hasPrefix("t") {
                                    return [one, two, three]
                                }
                            }
                            return nil
                        }
                    }
                    return []
                }
            }
        }

        let threeSets: Set<Set<String>> = Set(mapConnections(connections: connections, reversedConnections: reversedConnections) + mapConnections(connections: reversedConnections, reversedConnections: connections))

        let result = threeSets.count

        return "\(result)"
    }

    func solveTwo(input: String, isTest: Bool) async -> String {
        let connections = data(from: input)
        var reversedConnections: [String: Set<String>] = [:]

        for (key, value) in connections {
            for v in value {
                var set = reversedConnections[v, default: []]
                set.insert(key)
                reversedConnections[v] = set
            }
        }

        var clusters: Set<Set<String>> = []

        for (key, value) in connections {
            var nextPoints: Set<String> = value
            var cluster: Set<String> = [key]
            while nextPoints.isNotEmpty {
                let point = nextPoints.removeFirst()
                var isOk = true
                for clusterPoint in cluster {
                    if !connections[point, default: []].contains(clusterPoint),
                       !reversedConnections[point, default: []].contains(clusterPoint) {
                        isOk = false
                        break
                    }
                }
                if isOk {
                    cluster.insert(point)
                    nextPoints = nextPoints.union(connections[point, default: []])
                    nextPoints = nextPoints.union(reversedConnections[point, default: []])
                }
            }

            clusters.insert(cluster)
        }

        guard let maxCluster = clusters.sorted(by: { $0.count > $1.count }).first else {
            return "Not found"
        }

        let sortedCluster = maxCluster.sorted()

        return sortedCluster.joined(separator: ",")
    }

    private func data(from input: String) -> [String: Set<String>] {
        let lines = input.lines.filter(\.isNotEmpty)

        let pairs = lines.map {
            let kv = $0.split(separator: "-").map(String.init)
            return (kv[0], kv[1])
        }

        return Dictionary(grouping: pairs, by: { $0.0 }).mapValues { Set($0.map(\.1)) }
    }
}
