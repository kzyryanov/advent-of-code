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
        case .puzzle01: return Puzzle01ViewModel(puzzle: self)
        case .puzzle02: return Puzzle02ViewModel(puzzle: self)
        case .puzzle03: return Puzzle03ViewModel(puzzle: self)
        }
    }
}
