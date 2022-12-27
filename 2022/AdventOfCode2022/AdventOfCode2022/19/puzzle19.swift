//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle19() {
    print("Test")
    print("One")
    one(input: testInput19)
    print("Two")
    two(input: testInput19)

    print("")
    print("Real")
    print("One")
    one(input: input19)
    print("Two")
    two(input: input19)
}

private enum Material: String, CustomStringConvertible, CaseIterable {
    case ore
    case clay
    case obsidian
    case geode

    var description: String { rawValue }
}

private struct BluePrint: CustomStringConvertible {
    let id: Int
    let costs: [Material: [Material: Int]]
    let maxRequiredRobots: [Material: Int]

    var description: String {
        "id: \(id), costs: \(costs)"
    }
}

private struct Solution: Hashable, CustomStringConvertible {
    private(set) var robots: [Material: Int] = [.ore: 1]
    private(set) var stash: [Material: Int] = [:]

    var description: String {
        "(Robots: \(robots), Stash: \(stash))"
    }
}

private func one(input: String) {
    solve(input: input, minutes: 24, blueprintsPrefix: nil)
}

private func solve(input: String, minutes: Int, blueprintsPrefix: Int?) {
    let parsedBlueprints = input.components(separatedBy: "\n").map { string in
        let components = string.components(separatedBy: ": ")
        let id = Int(components[0].components(separatedBy: " ").last!)!

        let costs = components[1].components(separatedBy: ".")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter(\.isNotEmpty)
        let oreRobotCost = Int(costs[0].components(separatedBy: "Each ore robot costs ").last!.components(separatedBy: " ").first!)!

        let clayRobotCost = Int(costs[1].components(separatedBy: "Each clay robot costs ").last!.components(separatedBy: " ").first!)!

        let obsidianRobotCost = costs[2].components(separatedBy: "Each obsidian robot costs ").last!.components(separatedBy: " ")
        let obsidianOre = Int(obsidianRobotCost[0])!
        let obsidianClay = Int(obsidianRobotCost[3])!

        let geodeRobotCost = costs[3].components(separatedBy: "Each geode robot costs ").last!.components(separatedBy: " ")
        let geodeOre = Int(geodeRobotCost[0])!
        let geodeObsidian = Int(geodeRobotCost[3])!

        return BluePrint(
            id: id,
            costs: [
                .ore: [.ore: oreRobotCost],
                .clay: [.ore: clayRobotCost],
                .obsidian: [.ore: obsidianOre, .clay: obsidianClay],
                .geode: [.ore: geodeOre, .obsidian: geodeObsidian]
            ],
            maxRequiredRobots: [
                .ore: max(oreRobotCost, clayRobotCost, obsidianOre, geodeOre),
                .clay: obsidianClay,
                .obsidian: geodeObsidian
            ]
        )
    }

    let blueprints: [BluePrint]

    if let blueprintsPrefix {
        blueprints = Array(parsedBlueprints.prefix(blueprintsPrefix))
    } else {
        blueprints = parsedBlueprints
    }

    blueprints.forEach {
        print($0)
    }

    func checkCost(_ cost: [Material: Int], in stash: [Material: Int]) -> Bool {
        for (material, value) in cost {
            if stash[material, default: 0] < value {
                return false
            }
        }
        return true
    }

    func calculateSolution(_ solution: Solution) -> Solution {
        let collectingRobots = solution.robots

        var stash = solution.stash

        for (m, v) in collectingRobots {
            stash[m] = stash[m, default: 0] + v
        }

        return Solution(robots: solution.robots, stash: stash)
    }

    func calculateSolution(
        _ solution: Solution,
        buildingRobot: Material,
        withCost cost: [Material: Int]
    ) -> Solution {
        let collectingRobots = solution.robots

        var stash = solution.stash
        var robots = solution.robots

        for (m, v) in cost {
            stash[m] = stash[m, default: 0] - v
        }

        for (m, v) in collectingRobots {
            stash[m] = stash[m, default: 0] + v
        }

        robots[buildingRobot] = robots[buildingRobot, default: 0] + 1

        return Solution(robots: robots, stash: stash)
    }

    var maxGeodes: [Int: Int] = [:]

    for blueprint in blueprints {
        let solution = Solution()
        var solutions: Set<Solution> = [solution]

        var robotsOptions: Set<[Material: Int]> = [solution.robots]

        for minute in 1...minutes {
            var newSolutions: Set<Solution> = []

            let twoGeodesSolutions = solutions.filter { $0.stash[.geode, default: 0] > 1 }

            let solutionsToCheck: Set<Solution>

            if twoGeodesSolutions.isNotEmpty {
                solutionsToCheck = solutions.filter { $0.stash[.geode, default: 0] > 0 }
            } else {
                solutionsToCheck = solutions
            }

            print("Minute \(minute)")

            for solution in solutionsToCheck {
                robotsOptions.insert(solution.robots)

                var availableRobots: Set<Material> = [.ore, .clay]
                if solution.robots[.clay, default: 0] > 0 {
                    availableRobots.insert(.obsidian)
                }
                if solution.robots[.obsidian, default: 0] > 0 {
                    availableRobots.insert(.geode)
                }

                var builtRobots = 0
                for material in availableRobots {
                    let cost = blueprint.costs[material, default: [:]]
                    let maxRequiredRobots = blueprint.maxRequiredRobots[material, default: Int.max]
                    if solution.robots[material, default: 0] >= maxRequiredRobots {
                        builtRobots += 1
                        continue
                    }
                    if checkCost(cost, in: solution.stash) {
                        builtRobots += 1
                        let newSolution = calculateSolution(
                            solution,
                            buildingRobot: material,
                            withCost: cost
                        )
                        if !robotsOptions.contains(newSolution.robots) {
                            newSolutions.insert(newSolution)
                        }
                    }
                }

                if builtRobots < availableRobots.count {
                    newSolutions.insert(calculateSolution(solution))
                }
            }
            solutions = newSolutions

            print("Solutions: \(solutions.count)")
//            for solution in solutions {
//                print(solution)
//            }
            print("=========")
        }

        maxGeodes[blueprint.id] = solutions
            .map(\.stash)
            .map { $0[.geode, default: 0] }
            .max()

        print(maxGeodes)
    }

    print(maxGeodes)
    let result = maxGeodes.map { $0.value }.reduce(1, *)

    print("Result: \(result)")
}

private func two(input: String) {
    solve(input: input, minutes: 32, blueprintsPrefix: 3)
}
