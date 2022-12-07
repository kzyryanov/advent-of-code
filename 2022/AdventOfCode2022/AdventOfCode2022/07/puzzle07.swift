//
//  template.swift
//  AdventOfCode2022
//
//  Created by Konstantin on 2022-12-03.
//

import Foundation

func puzzle07() {
    print("Test")
    print("One")
    one(input: testInput07)
    print("Two")
    two(input: testInput07)

    print("")
    print("Real")
    print("One")
    one(input: input07)
    print("Two")
    two(input: input07)
}

private func one(input: String) {
    let rootDirectory = makeTree(input: input)
    rootDirectory.printDir()

    let result = findAll(withAtMost: 100000, in: rootDirectory).map(\.size).reduce(0, +)
    print("Result: \(result)")
}

private func two(input: String) {
    let rootDirectory = makeTree(input: input)

    let diskSpace = 70000000
    let requiredSpace = 30000000
    let rootSize = rootDirectory.size

    let sizeToDelete = rootSize - (diskSpace - requiredSpace)

    guard sizeToDelete > 0 else {
        print("Result: 0")
        return
    }

    let result = findAll(withAtLeast: sizeToDelete, in: rootDirectory).map(\.size).min()!
    print("Result: \(result)")
}

private func findAll(withAtLeast size: Int, in dir: Directory) -> [Directory] {
    var result: [Directory] = []
    if dir.size >= size {
        result.append(dir)
    }
    dir.directories.forEach { dir in
        result.append(contentsOf: findAll(withAtLeast: size, in: dir))
    }
    return result
}

private func findAll(withAtMost size: Int, in dir: Directory) -> [Directory] {
    var result: [Directory] = []
    if dir.size <= size {
        result.append(dir)
    }
    dir.directories.forEach { dir in
        result.append(contentsOf: findAll(withAtMost: size, in: dir))
    }
    return result
}

private func makeTree(input: String) -> Directory {
    var rootDirectory: Directory?
    var currentDirectory: Directory?

    input.components(separatedBy: "\n").forEach { output in
        if output.hasPrefix("$ ") {
            let commandComponents = output.suffix(output.count - 2).components(separatedBy: " ")
            let command = commandComponents[0]
            switch command {
            case "cd":
                let directory = commandComponents[1]
                if directory == ".." {
                    currentDirectory = currentDirectory?.parentDirectory
                    return
                }
                if let currentDir = currentDirectory {
                    if !currentDir.directories.contains(where: { $0.name == directory }) {
                        currentDir.add(directory: Directory(name: directory, parent: currentDirectory))
                    }
                    let newDir = currentDir.directories.first(where: { $0.name == directory })
                    currentDirectory = newDir
                    return
                }
                currentDirectory = Directory(name: directory, parent: nil)
                rootDirectory = currentDirectory
            case "ls": break
            default: break
            }
            return
        }

        let components = output.components(separatedBy: " ")
        if components.first == "dir" {
            currentDirectory?.add(directory: Directory(name: components.last!, parent: currentDirectory))
        } else {
            let size = Int(components.first!)!
            let name = components.last!
            currentDirectory?.add(file: File(name: name, size: size))
        }
    }

    guard let rootDirectory else {
        fatalError()
    }

    return rootDirectory
}

private class Directory {
    let name: String
    let parentDirectory: Directory?
    private(set) var directories: [Directory] = []
    private(set) var files: [File] = []

    var size: Int {
        directories.map(\.size).reduce(0, +) + files.map(\.size ).reduce(0, +)
    }

    init(name: String, parent: Directory?) {
        self.name = name
        self.parentDirectory = parent
    }

    func add(file: File) {
        files.append(file)
    }

    func add(directory: Directory) {
        directories.append(directory)
    }

    func printDir() {
        var space: String = ""
        var parent = parentDirectory
        while nil != parent {
            space += "  "
            parent = parent?.parentDirectory
        }
        print("\(space)- \(name) (dir, size = \(size))")
        directories.forEach { $0.printDir() }
        files.forEach {
            print("\(space)  - \($0.name) (file, size = \($0.size))")
        }
    }
}

private struct File {
    let name: String
    let size: Int
}
