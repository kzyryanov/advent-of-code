//
//  Puzzle2021-12.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-12-12.
//

import Foundation

fileprivate typealias Node = Puzzle2021_12.Node

func puzzle2021_12() {
    one()
    two()
}

fileprivate extension StringProtocol {
    var isLowercase: Bool {
        for c in self {
            if c.isUppercase {
                return false
            }
        }
        return true
    }
}

fileprivate func one() {
    print("One")

    let input = puzzle2021_12_input()

    var nodes: [String: Node] = [:]

    // Create graph
    for edge in input {
        let node1 = nodes[edge.nodeName1, default: Node(name: edge.nodeName1)]
        let node2 = nodes[edge.nodeName2, default: Node(name: edge.nodeName2)]
        node1.connect(node2)
        node2.connect(node1)
        nodes[node1.name] = node1
        nodes[node2.name] = node2
    }

    guard let startNode = nodes["start"], nodes["end"] != nil else {
        fatalError("No start and end node")
    }

    var printed: Set<String> = []

    func printNodes(_ node: Node) {
        if printed.contains(node.name) {
            return
        }
        printed.insert(node.name)
        print(node)
        node.nodes.forEach(printNodes)
    }

    printNodes(startNode)

    var paths: Set<[String]> = []

    func makePath(from node: Node, in path: [String]) {
        if path.last == "end" {
            paths.insert(path)
            return
        }
        if node.name.isLowercase && path.contains(node.name) {
            return
        }
        let newPath = path + [node.name]
        node.nodes.forEach { nextNode in
            if nextNode.name != "start" {
                makePath(from: nextNode, in: newPath)
            }
        }
    }

    makePath(from: startNode, in: [])

    paths.forEach({ print($0) })
    print("Total: \(paths.count)")
}

fileprivate func two() {
    print("Two")

    let input = puzzle2021_12_input()

    var nodes: [String: Node] = [:]

    // Create graph
    for edge in input {
        let node1 = nodes[edge.nodeName1, default: Node(name: edge.nodeName1)]
        let node2 = nodes[edge.nodeName2, default: Node(name: edge.nodeName2)]
        node1.connect(node2)
        node2.connect(node1)
        nodes[node1.name] = node1
        nodes[node2.name] = node2
    }

    guard let startNode = nodes["start"], nodes["end"] != nil else {
        fatalError("No start and end node")
    }

    var printed: Set<String> = []

    func printNodes(_ node: Node) {
        if printed.contains(node.name) {
            return
        }
        printed.insert(node.name)
        print(node)
        node.nodes.forEach(printNodes)
    }

    printNodes(startNode)

    var paths: Set<[String]> = []

    func makePath(from node: Node, in path: [String]) {
        if path.last == "end" {
            paths.insert(path)
            return
        }

        if node.name.isLowercase {
            let tmpPath = (path + [node.name]).filter({ $0 != "start" }).filter({ $0.isLowercase })

            let groupped = Dictionary(grouping: tmpPath) { el in
                el
            }
            let sorted = groupped.sorted(by: { $0.value.count > $1.value.count })
            if let first = sorted.first, first.value.count > 2 {
                return
            }
            if sorted.count >= 2, let first = sorted.first, first.value.count == 2, sorted[1].value.count > 1 {
                return
            }
        }

        let newPath = path + [node.name]
        node.nodes.forEach { nextNode in
            if nextNode.name != "start" {
                makePath(from: nextNode, in: newPath)
            }
        }
    }

    makePath(from: startNode, in: [])

    paths.forEach({ print($0) })
    print("Total: \(paths.count)")
}
