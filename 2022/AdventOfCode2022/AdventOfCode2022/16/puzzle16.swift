//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle16() {
    print("Test")
    print("One")
    one(input: testInput16)
    print("Two")
    two(input: testInput16)

    print("")
    print("Real")
    print("One")
    one(input: input16)
    print("Two")
    two(input: input16)
}

private func parseTunnels(input: String) -> Tunnels {
    Dictionary(uniqueKeysWithValues: input.components(separatedBy: "\n").map { valveString in
        let components = valveString.components(separatedBy: "; ")
        let valveComponents = components.first!.components(separatedBy: " has flow rate=")
        let label = valveComponents[0].components(separatedBy: " ").last!
        let flowRate = Int(valveComponents[1])!
        let tunnels = components.last!
            .components(separatedBy: "tunnels lead to valves ")
            .last!
            .components(separatedBy: "tunnel leads to valve ")
            .last!
            .components(separatedBy: ", ")
        return (label, Valve(label: label, flowRate: flowRate, tunnels: tunnels))
    })
}

private func one(input: String) {
    let tunnels = parseTunnels(input: input)
    for (label, valve) in tunnels {
        print("\(label): \(valve)")
    }

    let valvesWithFlow = tunnels.values
        .filter { $0.flowRate > 0 }
        .sorted(by: { $0.flowRate > $1.flowRate })

    print("Valves with flow: ")
    printValves(valvesWithFlow)

    print("====================")
    print("Start")
    print("")

    let size = tunnels.count

    var matrix = Array(repeating: Array(repeating: Int.max, count: size), count: size)

    let valveLabelsSorted = tunnels.keys.sorted()
    let enumeratedDict = Dictionary(uniqueKeysWithValues: valveLabelsSorted.enumerated().map { ($1, $0) })

    for (index, valve) in valveLabelsSorted.enumerated() {
        let connectedValves = tunnels[valve]!.tunnels
        matrix[index][index] = 0
        for connectedValve in connectedValves {
            matrix[index][enumeratedDict[connectedValve]!] = 1
        }
    }

    func floydWarshal(matrix: [[Int]]) -> [[Int]] {
        var cost = matrix

        for k in 0..<size {
            for i in 0..<size {
                for j in 0..<size {
                    if cost[i][k] < Int.max,
                       cost[k][j] < Int.max,
                       cost[i][j] > cost[i][k] + cost[k][j] {
                        cost[i][j] = cost[i][k] + cost[k][j]
                    }
                }
            }
        }

        return cost
    }

    let valveDistances = floydWarshal(matrix: matrix)

    func countMax(
        valve: String,
        closedValves: Set<Valve>,
        openedValves: Set<String>,
        result: Int,
        minutesLeft: Int
    ) -> Int {
        if minutesLeft <= 2 {
            return result
        }

        if closedValves.isEmpty {
            return result
        }

        let indexFrom = enumeratedDict[valve]!

        var maxValue = result

        for closedValve in closedValves {
            let indexTo = enumeratedDict[closedValve.label]!
            let distance = valveDistances[indexFrom][indexTo]
            let openTime = 1
            let minutes = minutesLeft - distance - openTime
            if minutes <= 0 {
                continue
            }
            var openedValves = openedValves
            openedValves.insert(closedValve.label)
            let result = result + closedValve.flowRate * minutes
            var newClosed = closedValves
            newClosed.remove(closedValve)
            maxValue = max(maxValue, countMax(
                valve: closedValve.label,
                closedValves: newClosed,
                openedValves: openedValves,
                result: result,
                minutesLeft: minutes
            ))
        }

        return maxValue
    }

    let result = countMax(
        valve: "AA",
        closedValves: Set(valvesWithFlow),
        openedValves: [],
        result: 0,
        minutesLeft: 30
    )
    print("Result: \(result)")
}

private func two(input: String) {
    let tunnels = parseTunnels(input: input)
    for (label, valve) in tunnels {
        print("\(label): \(valve)")
    }

    let valvesWithFlow = tunnels.values
        .filter { $0.flowRate > 0 }
        .sorted(by: { $0.flowRate > $1.flowRate })

    print("Valves with flow: ")
    printValves(valvesWithFlow)

    print("====================")
    print("Start")
    print("")

    let size = tunnels.count

    var matrix = Array(repeating: Array(repeating: Int.max, count: size), count: size)

    let valveLabelsSorted = tunnels.keys.sorted()
    let enumeratedDict = Dictionary(uniqueKeysWithValues: valveLabelsSorted.enumerated().map { ($1, $0) })

    for (index, valve) in valveLabelsSorted.enumerated() {
        let connectedValves = tunnels[valve]!.tunnels
        matrix[index][index] = 0
        for connectedValve in connectedValves {
            matrix[index][enumeratedDict[connectedValve]!] = 1
        }
    }

    func floydWarshal(matrix: [[Int]]) -> [[Int]] {
        var cost = matrix

        for k in 0..<size {
            for i in 0..<size {
                for j in 0..<size {
                    if cost[i][k] < Int.max,
                       cost[k][j] < Int.max,
                       cost[i][j] > cost[i][k] + cost[k][j] {
                        cost[i][j] = cost[i][k] + cost[k][j]
                    }
                }
            }
        }

        return cost
    }

    let valveDistances = floydWarshal(matrix: matrix)

    var myPaths: Set<[String]> = []

    func countMax(
        valve: String,
        elephantValve: String,
        closedValves: Set<Valve>,
        openedValves: Set<String>,
        result: Int,
        minutesLeft: Int,
        elephantMinutesLeft: Int,
        myPath: [String],
        elephantPath: [String]
    ) -> Int {
        if minutesLeft <= 2,
           elephantMinutesLeft <= 2,
           elephantPath.count > (myPath.count + 1)
        {
            return result
        }

        if closedValves.isEmpty {
//            print(myPath, elephantPath)
            return result
        }

        let indexFrom = enumeratedDict[valve]!
        let elephantFrom = enumeratedDict[elephantValve]!

        var maxValue = result

        for closedValve in closedValves {
            let indexTo = enumeratedDict[closedValve.label]!
            let distance = valveDistances[indexFrom][indexTo]
            let openTime = 1
            let minutes = minutesLeft - distance - openTime

            var myMinutesLeft = minutesLeft
            var myTo = valve
            var myPath = myPath
            var openedValves = openedValves
            var opened = false
            var result = result

            var newClosedValves = closedValves

            if minutes > 0 {
                myTo = closedValve.label
                myMinutesLeft = minutes
                openedValves.insert(closedValve.label)
                result += closedValve.flowRate * minutes
                myPath.append(closedValve.label)
                opened = true
                myPaths.insert(myPath)
                newClosedValves.remove(closedValve)
            }

            for elephantClosedValve in newClosedValves {
                if opened, elephantClosedValve.label == closedValve.label {
                    continue
                }
                let elephantIndexTo = enumeratedDict[elephantClosedValve.label]!
                let distance = valveDistances[elephantFrom][elephantIndexTo]
                let openTime = 1
                let elephantMinutes = elephantMinutesLeft - distance - openTime
                if elephantMinutes <= 0 {
                    continue
                }
                var openedValves = openedValves
                openedValves.insert(elephantClosedValve.label)
                let result = result + elephantClosedValve.flowRate * elephantMinutes
                let newElephantPath = elephantPath + [elephantClosedValve.label]
                if newElephantPath.count > myPath.count {
                    continue
                }
                var newClosedValves = newClosedValves
                newClosedValves.remove(elephantClosedValve)
                maxValue = max(maxValue, countMax(
                    valve: myTo,
                    elephantValve: elephantClosedValve.label,
                    closedValves: newClosedValves,
                    openedValves: openedValves,
                    result: result,
                    minutesLeft: myMinutesLeft,
                    elephantMinutesLeft: elephantMinutes,
                    myPath: myPath,
                    elephantPath: newElephantPath
                ))
            }
        }
//        print(myPath, elephantPath, maxValue)
        return maxValue
    }

    let result = countMax(
        valve: "AA",
        elephantValve: "AA",
        closedValves: Set(valvesWithFlow),
        openedValves: [],
        result: 0,
        minutesLeft: 26,
        elephantMinutesLeft: 26,
        myPath: [],
        elephantPath: []
    )
    print("Result: \(result)")
}

private struct PathStep: CustomStringConvertible {
    let label: String
    let open: Bool

    var description: String {
        "\(label) \(open.intValue)"
    }
}

private struct Valve: CustomStringConvertible, Hashable {
    let label: String
    let flowRate: Int
    let tunnels: [String]

    var description: String {
        "Valve \(label) has flow rate=\(flowRate); tunnels lead to valves \(tunnels.joined(separator: ", "))"
    }
}

private func printValves(_ valves: [Valve]) {
    valves.forEach {
        print($0)
    }
}

private func printPaths(_ paths: [[PathStep]]) {
    paths.forEach {
        print($0)
    }
}

private extension Bool {
    var intValue: Int {
        self ? 1 : 0
    }
}

private typealias Tunnels = [String: Valve]
