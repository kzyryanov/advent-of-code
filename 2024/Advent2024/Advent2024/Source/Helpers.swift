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
    var lines: [SubSequence] { split(whereSeparator: \.isNewline) }
}

struct Rect: Hashable, CustomStringConvertible {
    let origin: Point
    let size: Size

    var description: String { "(\(origin), \(size))" }

    func isPointInside(_ point: Point) -> Bool {
        origin.x...(origin.x + size.width) ~= point.x &&
        origin.y...(origin.y + size.height) ~= point.y
    }
}

struct Size: Hashable, CustomStringConvertible {
    let width: Int
    let height: Int

    var description: String { "(\(width), \(height))" }
}

struct Point: Hashable, CustomStringConvertible {
    let x: Int
    let y: Int

    var description: String { "(\(x), \(y))" }
}

enum Direction: String, Hashable, CaseIterable, CustomStringConvertible {
    case upLeft, up, upRight, left, right, downLeft, down, downRight

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
}
