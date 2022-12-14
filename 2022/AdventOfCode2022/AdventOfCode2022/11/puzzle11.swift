//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle11() {
    print("Test")
    print("One")
    one(input: testInput11)
    print("Two")
    two(input: testInput11)

    print("")
    print("Real")
    print("One")
    one(input: input11)
    print("Two")
    two(input: input11)
}

private func parseMonkeys(input: String) -> [Monkey] {
    let monkeys = input.components(separatedBy: "\n\n").map { monkeyString in
        let components = monkeyString
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        let startingItems = components[1]
            .trimmingPrefix("Starting items: ")
            .components(separatedBy: ", ")
            .map { Int($0)! }

        let operationComponents = components[2]
            .trimmingPrefix("Operation: ")
            .components(separatedBy: " ")

        let operation: (_ old: Int) -> Int

        switch (operationComponents[3], operationComponents[4]) {
        case ("*", "old"): operation = { old in old * old }
        case ("+", "old"): operation = { old in old + old }
        case ("*", _): operation = { old in old * Int(operationComponents[4])! }
        case ("+", _): operation = { old in old + Int(operationComponents[4])! }
        default: fatalError("Unknown operation")
        }

        let test = Int(components[3].trimmingPrefix("Test: divisible by "))!

        let trueMonkey = Int(components[4].trimmingPrefix("If true: throw to monkey "))!
        let falseMonkey = Int(components[5].trimmingPrefix("If false: throw to monkey "))!

        return Monkey(
            items: startingItems,
            operation: operation,
            test: test,
            trueMonkey: trueMonkey,
            falseMonkey: falseMonkey
        )
    }

    return monkeys
}

private func one(input: String) {
    let monkeys = parseMonkeys(input: input)

    let rounds = 20

    for _ in 0..<rounds {
        for monkey in monkeys {
            while monkey.items.isNotEmpty {
                let item = monkey.items.removeFirst()
                let newWorryLevel = monkey.operation(item)
                let boredLevel = newWorryLevel / 3
                monkey.inspectedItemsCount += 1
                if boredLevel % monkey.test == 0 {
                    monkeys[monkey.trueMonkey].items.append(boredLevel)
                } else {
                    monkeys[monkey.falseMonkey].items.append(boredLevel)
                }
            }
        }
    }

//    print(monkeys)

    let monkeyBusiness = monkeys
        .map(\.inspectedItemsCount)
        .sorted(by: >)
        .prefix(2)
        .reduce(1, *)

    print("Result: \(monkeyBusiness)")
}

private func two(input: String) {
    let monkeys = parseMonkeys(input: input)

    let monkeyWholeTest = monkeys.map(\.test).reduce(1, *)

    let rounds = 10000

    for _ in 0..<rounds {
        for monkey in monkeys {
            while monkey.items.isNotEmpty {
                let item = monkey.items.removeFirst()
                let newWorryLevel = monkey.operation(item)
                monkey.inspectedItemsCount += 1
                let worryLevelRest = newWorryLevel % monkey.test
                let newWorryLevelWholeRest = newWorryLevel % monkeyWholeTest
                if worryLevelRest == 0 {
                    monkeys[monkey.trueMonkey].items.append(newWorryLevelWholeRest)
                } else {
                    monkeys[monkey.falseMonkey].items.append(newWorryLevelWholeRest)
                }
            }
        }
    }

    print(monkeys)

    let monkeyBusiness = monkeys
        .map(\.inspectedItemsCount)
        .sorted(by: >)
        .prefix(2)
        .reduce(1, *)

    print("Result: \(monkeyBusiness)")
}

private class Monkey: CustomStringConvertible {
    var items: [Int]
    let operation: (_ old: Int) -> Int
    let test: Int
    let trueMonkey: Int
    let falseMonkey: Int
    var inspectedItemsCount: Int = 0

    init(
        items: [Int],
        operation: @escaping (_ old: Int) -> Int,
        test: Int,
        trueMonkey: Int,
        falseMonkey: Int
    ) {
        self.items = items
        self.operation = operation
        self.test = test
        self.trueMonkey = trueMonkey
        self.falseMonkey = falseMonkey
    }

    var description: String {
"""
{ Monkey
    Inspected items: \(inspectedItemsCount)
    Items: \(items)
    Test: \(test)
    True Monkey: \(trueMonkey)
    False Monkey: \(falseMonkey)
}
"""
    }
}

//private class MonkeyTwo: CustomStringConvertible {
//    var items: [BigInt]
//    let operation: (_ old: BigInt) -> BigInt
//    let test: BigInt
//    let trueMonkey: Int
//    let falseMonkey: Int
//    var inspectedItemsCount: Int = 0
//
//    init(
//        items: [Int],
//        operation: @escaping (_ old: Int) -> Int,
//        test: Int,
//        trueMonkey: Int,
//        falseMonkey: Int
//    ) {
//        self.items = items
//        self.operation = operation
//        self.test = test
//        self.trueMonkey = trueMonkey
//        self.falseMonkey = falseMonkey
//    }
//
//    var description: String {
//"""
//{ Monkey
//    Inspected items: \(inspectedItemsCount)
//    Items: \(items)
//    Test: \(test)
//    True Monkey: \(trueMonkey)
//    False Monkey: \(falseMonkey)
//}
//"""
//    }
//}
