//
//  Puzzle09ViewModel.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-09.
//

import SwiftUI

@Observable
final class Puzzle09ViewModel: PuzzleViewModel {
    let puzzle: Puzzle

    init(puzzle: Puzzle) {
        self.puzzle = puzzle
    }

    func solveOne(input: String) async -> String {
        let diskMap: [Int] = input.trimmingCharacters(in: .whitespacesAndNewlines).enumerated().flatMap { index, character in
            let blocks = character.wholeNumberValue!
            if index % 2 == 0 {
                return Array(repeating: index / 2, count: blocks)
            } else {
                return Array(repeating: -1, count: blocks)
            }
        }

        var defragmentedDiskMap: [Int] = dropEmptyTail(diskMap)

        var index = 0
        while index < defragmentedDiskMap.count {
            if defragmentedDiskMap[index] < 0 {
                while index < defragmentedDiskMap.count {
                    let last = defragmentedDiskMap.removeLast()
                    if last >= 0 {
                        defragmentedDiskMap[index] = last
                        break
                    }
                }
            }
            index += 1
        }

        defragmentedDiskMap = dropEmptyTail(defragmentedDiskMap)

        let result = checksum(of: defragmentedDiskMap)

        return "\(result)"
    }

    private func dropEmptyTail(_ array: [Int]) -> [Int] {
        array.reversed().drop(while: {
            $0 < 0
        }).reversed()
    }

    private func checksum(of array: [Int]) -> Int {
        array.enumerated().reduce(0) { acc, element in
            acc + max(0, element.offset * element.element)
        }
    }

    private class Node {
        let id: Int
        let size: Int

        var next: Node?
        var prev: Node?
        var moved = false

        init(id: Int, size: Int) {
            self.id = id
            self.size = size
        }
    }

    func solveTwoNew(input: String) async -> String {
        var head: Node?
        var tail: Node?

        for (index, character) in input.trimmingCharacters(in: .whitespacesAndNewlines).enumerated() {
            let size = character.wholeNumberValue!
            let newTail: Node
            if index % 2 == 0 {
                newTail = Node(id: index / 2, size: size)
            } else {
                newTail = Node(id: -1, size: size)
            }

            newTail.prev = tail
            tail?.next = newTail
            tail = newTail

            if nil == head {
                head = tail
            }
        }

        var file: Node? = tail

        while nil != file {
            while let checkFile = file, checkFile.id < 0 {
                file = file?.prev
            }

            guard let checkFile = file else {
                break
            }

            if checkFile.moved {
                file = file?.prev
                continue
            }

            var space = head
            while let checkSpace = space, checkSpace !== checkFile {
                if space === checkFile {
                    break
                }
                if checkSpace.id < 0, checkSpace.size >= checkFile.size {
                    space = checkSpace
                    break
                }
                space = space?.next
            }

            if space === checkFile {
                file = file?.prev
                continue
            }

            guard let space, space.size >= checkFile.size else {
                file = file?.prev
                continue
            }

            let oldFile = file

            repeat {
                file = file?.prev
            } while (nil != file && file!.id < 0)

            let diff = space.size - checkFile.size

            func merge(space: Node?) {
                if let space, space.id < 0, let prev = space.prev, prev.id < 0 {
                    let newSpace = Node(id: -1, size: space.size + prev.size)

                    let newPrev = prev.prev
                    let newNext = space.next

                    newPrev?.next = newSpace
                    newSpace.prev = newPrev

                    newSpace.next = newNext
                    newNext?.prev = newSpace

                    merge(space: newSpace.next)
                }
            }

            if diff > 0 {
                let diffSpace = Node(id: -1, size: diff)
                let diffSpaceTail = Node(id: -1, size: checkFile.size)

                let newFilePrev = space.prev
                let newFileNext = space.next

                let newSpacePrev = oldFile?.prev
                let newSpaceNext = oldFile?.next

                oldFile?.next = diffSpace
                diffSpace.prev = oldFile

                newFilePrev?.next = oldFile
                oldFile?.prev = newFilePrev

                diffSpace.next = newFileNext
                newFileNext?.prev = diffSpace

                newSpacePrev?.next = diffSpaceTail
                diffSpaceTail.prev = newSpacePrev

                diffSpaceTail.next = newSpaceNext
                newSpaceNext?.prev = diffSpaceTail

                merge(space: diffSpaceTail)
            } else {
                let newFilePrev = space.prev
                let newFileNext = space.next

                let newSpacePrev = oldFile?.prev
                let newSpaceNext = oldFile?.next

                newFilePrev?.next = oldFile
                oldFile?.prev = newFilePrev

                space.next = newSpaceNext
                newSpaceNext?.prev = space

                if newFileNext === oldFile {
                    oldFile?.next = space
                    space.prev = oldFile
                } else {
                    oldFile?.next = newFileNext
                    newFileNext?.prev = oldFile

                    newSpacePrev?.next = space
                    space.prev = newSpacePrev
                }

                merge(space: space)
            }
        }

        let array = mapList(node: head)
        let result = checksum(of: array)

        return "\(result)"
    }

    private func mapList(node: Node?) -> [Int] {
        var n = node
        var result: [Int] = []

        while let n1 = n {
            if n1.size > 0 {
                result.append(contentsOf: Array(repeating: n1.id, count: n1.size))
            }
            n = n1.next
        }

        return result
    }

    func solveTwo(input: String) async -> String {
        let diskMap: [Int] = input.trimmingCharacters(in: .whitespacesAndNewlines).enumerated().flatMap { index, character in
            let blocks = character.wholeNumberValue!
            if index % 2 == 0 {
                return Array(repeating: index / 2, count: blocks)
            } else {
                return Array(repeating: -1, count: blocks)
            }
        }

        var defragmentedDiskMap = diskMap

        var tailIndex = defragmentedDiskMap.count - 1

        var sortedIds: Set<Int> = []

        while tailIndex >= 0 {
            while tailIndex >= 0, defragmentedDiskMap[tailIndex] < 0 {
                tailIndex -= 1
            }

            let id = defragmentedDiskMap[tailIndex]

            if sortedIds.contains(id) {
                tailIndex -= 1
                continue
            }

            var fileSize = 1

            while tailIndex >= 1, defragmentedDiskMap[tailIndex-1] == id {
                tailIndex -= 1
                fileSize += 1
            }

            var headIndex = 0
            var freeSpaceCount = 0

            while headIndex < tailIndex, fileSize > freeSpaceCount {
                while headIndex < defragmentedDiskMap.count,
                      headIndex < tailIndex,
                      defragmentedDiskMap[headIndex] >= 0 {
                    headIndex += 1
                }

                freeSpaceCount = 1

                while headIndex + freeSpaceCount < defragmentedDiskMap.count, defragmentedDiskMap[headIndex + freeSpaceCount] < 0 {
                    freeSpaceCount += 1
                }

                if fileSize > freeSpaceCount {
                    headIndex += 1
                }
            }

            if headIndex >= tailIndex {
                tailIndex -= 1
                continue
            }

            for i in 0..<fileSize {
                defragmentedDiskMap[headIndex + i] = id
                defragmentedDiskMap[tailIndex + i] = -1
                sortedIds.insert(id)
            }

            tailIndex -= 1
        }

        let result = checksum(of: defragmentedDiskMap)

        return "\(result)"
    }
}
