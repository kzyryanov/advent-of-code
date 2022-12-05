import Foundation

let strings = try! String(contentsOfFile: "input08_01.txt").components(separatedBy: "\n").filter { !$0.isEmpty }
let total = strings.map { $0.count }

enum State {
    case letter
    case escaping
    case escapingHex
    case excapingHex2
}

let unescaped = strings.map { string in
    var count: Int = 0
    var state = State.letter
    string.forEach { character in
        switch state {
        case .letter:
            switch character {
            case "\"": return
            case "\\": state = .escaping
            default: count += 1
            }
        case .escaping:
            switch character {
            case "x": state = .escapingHex
            default: state = .letter; count += 1
            }
        case .escapingHex:
            switch character {
            case "0"..."9", "a"..."f": state = .excapingHex2
            default:
                print(string)
                print(character)
                fatalError("Not a number")
            }
        case .excapingHex2:
            state = .letter
            count += 1
        }
    }
    return count
}
print(total)
print(unescaped)

let result = total.reduce(0, +) - unescaped.reduce(0, +)
print(result)

print("\n\nTwo")
let escaped = strings.map { string in
    var result: String = ""
    result.append("\"")
    string.forEach { character in
        switch character {
        case "\"": result.append("\\\"")
        case "\\": result.append("\\\\")
        default: result.append(character)
        }
    }
    result.append("\"")
    return result
}.map { $0.count }

print(escaped)

let result02 = escaped.reduce(0, +) - total.reduce(0, +)
print(result02)
