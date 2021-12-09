//
//  Puzzle-2021-04.swift
//  Cmd
//
//  Created by Konstantin Zyrianov on 2021-12-06.
//

import Foundation

fileprivate struct Table {
    var tableItems: [[TableItem]]

    var isWinning: Bool {
        for i in 0..<tableItems.count {
            if tableItems[i].filter(\.marked).count == 5 { // find winning row
                return true
            }

            var column: [TableItem] = Array(repeating: TableItem(number: 0), count: 5)
            for j in 0..<tableItems.count {
                column[j] = tableItems[j][i]
            }

            if column.filter(\.marked).count == 5 {
                return true
            }
        }

        return false
    }

    var score: Int {
        tableItems.reduce(0, { $0 + $1.filter(\.notMarked).map(\.number).reduce(0, +) })
    }
}

fileprivate class TableItem {
    let number: Int
    var marked: Bool = false
    var notMarked: Bool { !marked }

    init(number: Int) {
        self.number = number
    }
}

func puzzle2021_04() {
    one()
    two()
}

fileprivate func one() {
    let input = puzzle2021_04_input()

    let numbers = input.numbers
    let tables = input.tables.map {
        Table(tableItems: $0.map { $0.map { TableItem(number: $0) } })
    }

    for number in numbers {
        for table in tables {
            table.tableItems.forEach {
                $0.forEach { item in
                    if item.number == number {
                        item.marked = true
                    }
                }
            }
            print(number, table.isWinning)
            if table.isWinning {
                print(table.score * number)
                return
            }
        }
    }
}

fileprivate func two() {
    let input = puzzle2021_04_input()

    let numbers = input.numbers
    var tables = input.tables.map {
        Table(tableItems: $0.map { $0.map { TableItem(number: $0) } })
    }

    for number in numbers {
        tables = tables.filter { table in
            table.tableItems.forEach {
                $0.forEach { item in
                    if item.number == number {
                        item.marked = true
                    }
                }
            }
            print(number, table.isWinning)
            if table.isWinning {
                print(table.score * number)
                return false
            }
            return true
        }
    }
}
