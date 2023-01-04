//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle21() {
    print("Test")
    print("One")
    one(input: testInput21)
    print("Two")
    two(input: testInput21)

    print("")
    print("Real")
    print("One")
    one(input: input21)
    print("Two")
    two(input: input21)
}

private typealias MonkeyName = String

private enum Operation: CustomStringConvertible {
    case number(Int)
    case multiplication(MonkeyName, MonkeyName)
    case division(MonkeyName, MonkeyName)
    case addition(MonkeyName, MonkeyName)
    case substraction(MonkeyName, MonkeyName)

    var description: String {
        switch self {
        case .number(let int):
            return "\(int)"
        case .multiplication(let monkeyName, let monkeyName2):
            return "\(monkeyName) * \(monkeyName2)"
        case .division(let monkeyName, let monkeyName2):
            return "\(monkeyName) / \(monkeyName2)"
        case .addition(let monkeyName, let monkeyName2):
            return "\(monkeyName) + \(monkeyName2)"
        case .substraction(let monkeyName, let monkeyName2):
            return "\(monkeyName) - \(monkeyName2)"
        }
    }

    var members: [MonkeyName]? {
        switch self {
        case .number: return nil
        case .multiplication(let monkeyName, let monkeyName2),
                .division(let monkeyName, let monkeyName2),
                .addition(let monkeyName, let monkeyName2),
                .substraction(let monkeyName, let monkeyName2):
            return [monkeyName, monkeyName2]
        }
    }

    func inverted(for name: MonkeyName, operand: MonkeyName) -> Operation {
        switch self {
        case .number(let int): return .number(int)
        case .multiplication(let monkeyName, let monkeyName2) where monkeyName == operand:
            return .division(name, monkeyName2)
        case .multiplication(let monkeyName, let monkeyName2) where monkeyName2 == operand:
            return .division(name, monkeyName)
        case .division(let monkeyName, let monkeyName2) where monkeyName == operand:
            return .multiplication(name, monkeyName2)
        case .division(let monkeyName, let monkeyName2) where monkeyName2 == operand:
            return .division(monkeyName, name)
        case .addition(let monkeyName, let monkeyName2) where monkeyName == operand:
            return .substraction(name, monkeyName2)
        case .addition(let monkeyName, let monkeyName2) where monkeyName2 == operand:
            return .substraction(name, monkeyName)
        case .substraction(let monkeyName, let monkeyName2) where monkeyName == operand:
            return .addition(name, monkeyName2)
        case .substraction(let monkeyName, let monkeyName2) where monkeyName2 == operand:
            return .substraction(monkeyName, name)
        default:
            fatalError("Invalid invertion attempt: \(name) \(operand)")
        }
    }

}

private func parseMonkeys(input: String) -> [MonkeyName: Operation] {
    Dictionary(
        uniqueKeysWithValues: input
            .components(separatedBy: "\n")
            .map { string in
                let components = string.components(separatedBy: ": ")
                let name = components[0]
                if let number = Int(components[1]) {
                    return (name, Operation.number(number))
                }

                let operationComponents = components[1].components(separatedBy: " ")
                switch operationComponents[1] {
                case "+": return (name, Operation.addition(operationComponents[0], operationComponents[2]))
                case "*": return (name, Operation.multiplication(operationComponents[0], operationComponents[2]))
                case "/": return (name, Operation.division(operationComponents[0], operationComponents[2]))
                case "-": return (name, Operation.substraction(operationComponents[0], operationComponents[2]))
                default: fatalError("Unknown operation: \(operationComponents[1])")
                }
            }
    )
}

private func one(input: String) {
    let monkeys: [MonkeyName: Operation] = parseMonkeys(input: input)

    let result = solveMonkeys(monkeys, for: "root")

    print("Result: \(result)")
}

private func solveMonkeys(_ monkeys: [MonkeyName: Operation], for name: MonkeyName) -> Int {
    var monkeys = monkeys

    func solve(_ name: MonkeyName) -> Int {
        guard let operation = monkeys[name] else {
            fatalError("Monkey not found")
        }

        switch operation {
        case .number(let number): return number
        case .addition(let name1, let name2):
            let result = solve(name1) + solve(name2)
            monkeys[name] = .number(result)
            return result
        case .multiplication(let name1, let name2):
            let result = solve(name1) * solve(name2)
            monkeys[name] = .number(result)
            return result
        case .division(let name1, let name2):
            let result = solve(name1) / solve(name2)
            monkeys[name] = .number(result)
            return result
        case .substraction(let name1, let name2):
            let result = solve(name1) - solve(name2)
            monkeys[name] = .number(result)
            return result
        }
    }

    return solve(name)
}

private func two(input: String) {
    var monkeys: [MonkeyName: Operation] = parseMonkeys(input: input)

    let modifyName = "humn"
    var modified: Set<MonkeyName> = []

    func modify(for name: MonkeyName) {
        var operations = monkeys.filter { (_, operation) -> Bool in
            if let members = operation.members {
                return members.contains(name)
            }
            return false
        }

        if let operation = operations["root"],
           let anotherOperand = operation.members?.filter({ $0 != name }).first {
            monkeys["root"] = nil
            operations["root"] = nil
            monkeys[name] = monkeys[anotherOperand]
            modify(for: anotherOperand)
        }

        for (monkeyName, operation) in operations where !modified.contains(monkeyName) {
            monkeys[name] = operation.inverted(for: monkeyName, operand: name)
            modified.insert(name)
            if case Operation.number = operation {} else {
                modify(for: monkeyName)
            }
        }
    }

    modify(for: modifyName)

    let result = solveMonkeys(monkeys, for: "humn")
    print("Result: \(result)")
}
