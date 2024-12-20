//
//  Collection+Extensions.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-02.
//

import Foundation

extension Collection {
    var isNotEmpty: Bool { !isEmpty }
}

extension StringProtocol {
    var lines: [SubSequence] { split(omittingEmptySubsequences: false, whereSeparator: \.isNewline) }
}

struct Rect: Hashable, CustomStringConvertible {
    let origin: Point
    let size: Size

    var description: String { "(\(origin), \(size))" }

    func isPointInside(_ point: Point) -> Bool {
        origin.x..<(origin.x + size.width) ~= point.x &&
        origin.y..<(origin.y + size.height) ~= point.y
    }
}

struct Size: Hashable, CustomStringConvertible {
    var width: Int
    var height: Int

    static let zero = Size(width: 0, height: 0)

    var description: String { "(\(width), \(height))" }
}

struct Point: Hashable, CustomStringConvertible {
    let x: Int
    let y: Int

    static let zero = Point(x: 0, y: 0)

    var description: String { "(\(x), \(y))" }

    func distance(from point: Point) -> Int {
        return abs(x - point.x) + abs(y - point.y)
    }
}

enum Direction: String, Hashable, CaseIterable, CustomStringConvertible {
    case upLeft, up, upRight, left, right, downLeft, down, downRight

    static let noDiagonals: [Direction] = [.up, .left, .right, .down]

    var description: String { rawValue }

    func move(from point: Point) -> Point {
        switch self {
        case .upLeft: return Point(x: point.x-1, y: point.y-1)
        case .up: return Point(x: point.x, y: point.y-1)
        case .upRight: return Point(x: point.x+1, y: point.y-1)
        case .left: return Point(x: point.x-1, y: point.y)
        case .right: return Point(x: point.x+1, y: point.y)
        case .downLeft: return Point(x: point.x-1, y: point.y+1)
        case .down: return Point(x: point.x, y: point.y+1)
        case .downRight: return Point(x: point.x+1, y: point.y+1)
        }
    }

    var rotated90Right: Direction {
        switch self {
        case .upLeft: return .upRight
        case .up: return .right
        case .upRight: return .downRight
        case .right: return .down
        case .downRight: return .downLeft
        case .down: return .left
        case .downLeft: return .upLeft
        case .left: return .up
        }
    }

    var opposite: Direction {
        switch self {
        case .upLeft: return .downRight
        case .upRight: return .downLeft
        case .downLeft: return .upRight
        case .downRight: return .upLeft
        case .left: return .right
        case .right: return .left
        case .up: return .down
        case .down: return .up
        }
    }

    func isOpposite(to direction: Direction) -> Bool {
        self.opposite == direction
    }
}
