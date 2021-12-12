//
//  Puzzle-2021-12-input.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-12-12.
//

import Foundation

struct Puzzle2021_12 {
    class Node: CustomStringConvertible {
        let name: String
        private(set) var nodes: [Node] = []

        init(name: String) {
            self.name = name
        }

        func connect(_ node: Node) {
            self.nodes.append(node)
        }

        var description: String {
            return "Node: \(name), nodes: \(nodes.map(\.name))"
        }
    }

    struct Edge {
        let nodeName1, nodeName2: String

        init(_ nodeName1: String, _ nodeName2: String) {
            self.nodeName1 = nodeName1
            self.nodeName2 = nodeName2
        }
    }
}

func puzzle2021_12_test_input1() -> [Puzzle2021_12.Edge] {
    [
        Puzzle2021_12.Edge("start", "A"),
        Puzzle2021_12.Edge("start", "b"),
        Puzzle2021_12.Edge("A", "c"),
        Puzzle2021_12.Edge("A", "b"),
        Puzzle2021_12.Edge("b", "d"),
        Puzzle2021_12.Edge("A", "end"),
        Puzzle2021_12.Edge("b", "end"),
    ]
}

func puzzle2021_12_test_input2() -> [Puzzle2021_12.Edge] {
    [
        Puzzle2021_12.Edge("dc", "end"),
        Puzzle2021_12.Edge("HN", "start"),
        Puzzle2021_12.Edge("start", "kj"),
        Puzzle2021_12.Edge("dc", "start"),
        Puzzle2021_12.Edge("dc", "HN"),
        Puzzle2021_12.Edge("LN", "dc"),
        Puzzle2021_12.Edge("HN", "end"),
        Puzzle2021_12.Edge("kj", "sa"),
        Puzzle2021_12.Edge("kj", "HN"),
        Puzzle2021_12.Edge("kj", "dc"),
    ]
}

func puzzle2021_12_test_input3() -> [Puzzle2021_12.Edge] {
    [
        Puzzle2021_12.Edge("fs", "end"),
        Puzzle2021_12.Edge("he", "DX"),
        Puzzle2021_12.Edge("fs", "he"),
        Puzzle2021_12.Edge("start", "DX"),
        Puzzle2021_12.Edge("pj", "DX"),
        Puzzle2021_12.Edge("end", "zg"),
        Puzzle2021_12.Edge("zg", "sl"),
        Puzzle2021_12.Edge("zg", "pj"),
        Puzzle2021_12.Edge("pj", "he"),
        Puzzle2021_12.Edge("RW", "he"),
        Puzzle2021_12.Edge("fs", "DX"),
        Puzzle2021_12.Edge("pj", "RW"),
        Puzzle2021_12.Edge("zg", "RW"),
        Puzzle2021_12.Edge("start", "pj"),
        Puzzle2021_12.Edge("he", "WI"),
        Puzzle2021_12.Edge("zg", "he"),
        Puzzle2021_12.Edge("pj", "fs"),
        Puzzle2021_12.Edge("start", "RW"),
    ]
}

func puzzle2021_12_input() -> [Puzzle2021_12.Edge] {
    [
        Puzzle2021_12.Edge("EG", "bj"),
        Puzzle2021_12.Edge("LN", "end"),
        Puzzle2021_12.Edge("bj", "LN"),
        Puzzle2021_12.Edge("yv", "start"),
        Puzzle2021_12.Edge("iw", "ch"),
        Puzzle2021_12.Edge("ch", "LN"),
        Puzzle2021_12.Edge("EG", "bn"),
        Puzzle2021_12.Edge("OF", "iw"),
        Puzzle2021_12.Edge("LN", "yv"),
        Puzzle2021_12.Edge("iw", "TQ"),
        Puzzle2021_12.Edge("iw", "start"),
        Puzzle2021_12.Edge("TQ", "ch"),
        Puzzle2021_12.Edge("EG", "end"),
        Puzzle2021_12.Edge("bj", "OF"),
        Puzzle2021_12.Edge("OF", "end"),
        Puzzle2021_12.Edge("TQ", "start"),
        Puzzle2021_12.Edge("TQ", "bj"),
        Puzzle2021_12.Edge("iw", "LN"),
        Puzzle2021_12.Edge("EG", "ch"),
        Puzzle2021_12.Edge("yv", "iw"),
        Puzzle2021_12.Edge("KW", "bj"),
        Puzzle2021_12.Edge("OF", "ch"),
        Puzzle2021_12.Edge("bj", "ch"),
        Puzzle2021_12.Edge("yv", "TQ"),
    ]
}
