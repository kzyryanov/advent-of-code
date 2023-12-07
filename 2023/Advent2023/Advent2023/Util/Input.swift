//
//  Input.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-01.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

enum Input: String {
    case puzzle01
    case puzzle02
    case puzzle03
    case puzzle04
    case puzzle05
    case puzzle06

    var input: String {
        NSDataAsset(name: name).map {
            String(decoding: $0.data, as: UTF8.self)
        } ?? ""
    }

    var testInput: String {
        NSDataAsset(name: testName).map {
            String(decoding: $0.data, as: UTF8.self)
        } ?? ""
    }

    func testInput(number: Int) -> String {
        NSDataAsset(name: testName(number: number)).map {
            String(decoding: $0.data, as: UTF8.self)
        } ?? ""
    }

    var name: String { rawValue }
    var testName: String { "\(rawValue)_test" }
    func testName(number: Int) -> String { "\(rawValue)_test\(number)" }

}
