//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle13() {
    print("Test")
    print("One")
    one(input: testInput13)
    print("Two")
    two(input: testInput13)

    print("")
    print("Real")
    print("One")
    one(input: input13)
    print("Two")
    two(input: input13)
}

private func parse(input: String) -> [Pair] {
    input.components(separatedBy: "\n\n").map { pairString in
        let pairStrings = pairString.components(separatedBy: "\n")

        let first = (parseSignal(pairStrings[0]).result as! [Any]).first as! [Any]
        let second = (parseSignal(pairStrings[1]).result as! [Any]).first as! [Any]

        return Pair(first: first, second: second)
    }
}

private func parseSignal(_ input: String) -> (result: Any, input: String) {
    var input = input
    var number: String = ""
    var elements: [Any] = []

    while input.isNotEmpty {
        let first = input.removeFirst()
        switch first {
        case "[":
            let element = parseSignal(input)
            elements.append(element.result)
            input = element.input
        case ",":
            if number.isNotEmpty {
                elements.append(Int(number)!)
                number = ""
            }
        case "]":
            if number.isNotEmpty {
                elements.append(Int(number)!)
                number = ""
            }
            return (elements, input)
        default:
            number.append(first)
        }
    }
    return (elements, input)
}

private func one(input: String) {
    let signals = parse(input: input)
    let correctOrderIndices = signals.enumerated().compactMap { (index, pair) -> Int? in
        if compare(left: pair.first, right: pair.second) == .orderedAscending {
            return index + 1
        }
        return nil
    }

    let result = correctOrderIndices.reduce(0, +)

    print("Result: \(result)")
}

private func two(input: String) {
    let signals = parse(input: input)
    var packets: [Any] = []
    for signal in signals {
        packets.append(signal.first)
        packets.append(signal.second)
    }

    let dividerPacket1 = [[2]]
    let dividerPacket2 = [[6]]

    packets.append(dividerPacket1)
    packets.append(dividerPacket2)

    let sorted = packets.sorted { lhs, rhs in
        return (compare(left: lhs, right: rhs) == .orderedAscending)
    }

    let indices = sorted.enumerated().compactMap { index, packet in
        if compare(left: dividerPacket1, right: packet) == .orderedSame {
            return index+1
        }
        if compare(left: dividerPacket2, right: packet) == .orderedSame {
            return index+1
        }
        return nil
    }

    let result = indices.reduce(1, *)

    print("Result: \(result)")
}

private struct Pair: CustomStringConvertible {
    let first: [Any]
    let second: [Any]

    var description: String {
        "First: \(first), Second: \(second)"
    }
}

private func compare(left: Any, right: Any) -> ComparisonResult {
    if let left = left as? Int,
       let right = right as? Int {
        if left < right {
            return .orderedAscending
        }
        if left == right {
            return .orderedSame
        }
        return .orderedDescending
    }
    if let left = left as? [Any],
       let right = right as? [Any] {
        for i in 0..<(min(left.count, right.count)) {
            let result = compare(left: left[i], right: right[i])
            switch result {
            case .orderedDescending: return .orderedDescending
            case .orderedSame: continue
            case .orderedAscending: return .orderedAscending
            }
        }
        if left.count < right.count {
            return .orderedAscending
        }
        if left.count == right.count {
            return .orderedSame
        }
        return .orderedDescending
    }

    if left is Int {
        return compare(left: [left], right: right)
    }

    return compare(left: left, right: [right])
}
