//
//  Day.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-01.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

enum Puzzle: String, CaseIterable {
    case puzzle01
    case puzzle02
    case puzzle03
    case puzzle04
    case puzzle05
    case puzzle06
    case puzzle07
    case puzzle08
    case puzzle09
    case puzzle10
    case puzzle11


    var name: String {
        self.rawValue.capitalized
    }

    var input: String {
        input(name: self.rawValue)
    }

    var testInputs: [String] {
        var testInputs: [String] = [
            input(name: self.rawValue + "_test")
        ]

        switch self {
        case .puzzle03:
            testInputs.append(input(name: self.rawValue + "_test1"))
        case .puzzle09:
            testInputs.append(input(name: self.rawValue + "_test1"))
        default:
            break
        }
        return testInputs
    }

    private func input(name: String) -> String {
        guard let asset = NSDataAsset(name: name) else {
            fatalError()
        }
        return String(decoding: asset.data, as: UTF8.self)
    }

    @MainActor
    var viewModel: PuzzleViewModel {
        switch self {
        case .puzzle01: Puzzle01ViewModel(puzzle: self)
        case .puzzle02: Puzzle02ViewModel(puzzle: self)
        case .puzzle03: Puzzle03ViewModel(puzzle: self)
        case .puzzle04: Puzzle04ViewModel(puzzle: self)
        case .puzzle05: Puzzle05ViewModel(puzzle: self)
        case .puzzle06: Puzzle06ViewModel(puzzle: self)
        case .puzzle07: Puzzle07ViewModel(puzzle: self)
        case .puzzle08: Puzzle08ViewModel(puzzle: self)
        case .puzzle09: Puzzle09ViewModel(puzzle: self)
        case .puzzle10: Puzzle10ViewModel(puzzle: self)
        case .puzzle11: Puzzle11ViewModel(puzzle: self)
        }
    }
}
