//
//  Structures.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-14.
//

import Foundation

struct Size: Hashable, Equatable, CustomStringConvertible {
    var width, height: Int

    static let zero = Self(width: 0, height: 0)

    func isPointInside(_ point: Point) -> Bool {
        (0..<width).contains(point.x) && (0..<height).contains(point.y)
    }

    var description: String {
        "{\(width), \(height)}"
    }
}

struct Point: Hashable, Equatable, CustomStringConvertible {
    let x, y: Int

    static let zero = Self(x: 0, y: 0)

    var description: String {
        "{\(x), \(y)}"
    }
}

enum Direction: String, CaseIterable, CustomStringConvertible {
   case north
   case west
   case south
   case east

   var opposite: Direction {
       switch self {
       case .north: return .south
       case .south: return .north
       case .east: return .west
       case .west: return .east
       }
   }

   var description: String { rawValue }
}

extension Point {
    func location(for move: Direction) -> Point {
        switch move {
        case .north: return Point(x: x, y: y - 1)
        case .south: return Point(x: x, y: y + 1)
        case .east: return Point(x: x + 1, y: y)
        case .west: return Point(x: x - 1, y: y)
        }
    }
}
