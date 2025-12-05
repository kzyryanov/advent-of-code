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
//    case puzzle06
//    case puzzle07
//    case puzzle08
//    case puzzle09
//    case puzzle10
//    case puzzle11
//    case puzzle12
//    case puzzle13
//    case puzzle14
//    case puzzle15
//    case puzzle16
//    case puzzle17
//    case puzzle18
//    case puzzle19
//    case puzzle20
//    case puzzle21
//    case puzzle22
//    case puzzle23
//    case puzzle24
//    case puzzle25

    var name: String {
        self.rawValue.capitalized
    }

    var input: String {
        input(name: self.rawValue)
    }

    var testInputs: [String] {
        let testInputs: [String] = [
            input(name: self.rawValue + "_test")
        ]

//        switch self {
//        case .puzzle03:
//            testInputs.append(input(name: self.rawValue + "_test1"))
//        case .puzzle09:
//            testInputs.append(input(name: self.rawValue + "_test1"))
//        case .puzzle12:
//            testInputs.append(input(name: self.rawValue + "_test1"))
//            testInputs.append(input(name: self.rawValue + "_test2"))
//            testInputs.append(input(name: self.rawValue + "_test3"))
//            testInputs.append(input(name: self.rawValue + "_test4"))
//        case .puzzle16:
//            testInputs.append(input(name: self.rawValue + "_test1"))
//        case .puzzle17:
//            testInputs.append(input(name: self.rawValue + "_test1"))
//        case .puzzle22:
//            testInputs.append(input(name: self.rawValue + "_test1"))
//        case .puzzle24:
//            testInputs.append(input(name: self.rawValue + "_test1"))
//        default:
//            break
//        }
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
//        case .puzzle06: Puzzle06ViewModel(puzzle: self)
//        case .puzzle07: Puzzle07ViewModel(puzzle: self)
//        case .puzzle08: Puzzle08ViewModel(puzzle: self)
//        case .puzzle09: Puzzle09ViewModel(puzzle: self)
//        case .puzzle10: Puzzle10ViewModel(puzzle: self)
//        case .puzzle11: Puzzle11ViewModel(puzzle: self)
//        case .puzzle12: Puzzle12ViewModel(puzzle: self)
//        case .puzzle13: Puzzle13ViewModel(puzzle: self)
//        case .puzzle14: Puzzle14ViewModel(puzzle: self)
//        case .puzzle15: Puzzle15ViewModel(puzzle: self)
//        case .puzzle16: Puzzle16ViewModel(puzzle: self)
//        case .puzzle17: Puzzle17ViewModel(puzzle: self)
//        case .puzzle18: Puzzle18ViewModel(puzzle: self)
//        case .puzzle19: Puzzle19ViewModel(puzzle: self)
//        case .puzzle20: Puzzle20ViewModel(puzzle: self)
//        case .puzzle21: Puzzle21ViewModel(puzzle: self)
//        case .puzzle22: Puzzle22ViewModel(puzzle: self)
//        case .puzzle23: Puzzle23ViewModel(puzzle: self)
//        case .puzzle24: Puzzle24ViewModel(puzzle: self)
//        case .puzzle25: Puzzle25ViewModel(puzzle: self)
        }
    }
}
