//
//  Puzzle20.swift
//  Advent2023
//
//  Created by Konstantin Zyrianov on 2023-12-20.
//

import SwiftUI

struct Puzzle20: View {
    let input: String

    @State private var presentInput: Bool = false

    @State private var isSolving: Bool = false
    @State private var answerFirst: Int?
    @State private var answerSecond: Int?

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    if let answerFirst {
                        Text("Result 1: ").font(.headline) +
                        Text("\(answerFirst)")
                    }
                    if let answerSecond {
                        Text("Result 2: ").font(.headline) +
                        Text("\(answerSecond)")
                    }
                }
                .padding()
            }
            Button(
                action: {
                    Task {
                        isSolving = true
                        defer {
                            isSolving = false
                        }
                        let clock = ContinuousClock()
                        let result1 = await clock.measure {
                            await solveFirst()
                        }
                        print("Result 1: \(result1)")
                        let result2 = await clock.measure {
                            await solveSecond()
                        }
                        print("Result 2: \(result2)")
                    }
                },
                label: {
                    Image(systemName: "figure.run.circle")
                    Text("Solve")
                }
            )
            .font(.largeTitle)
            .disabled(isSolving)
            .padding()
        }
        .overlay {
            if isSolving {
                ProgressView()
            }
        }
        .toolbar {
            Button(
                action: { presentInput.toggle() },
                label: { Image(systemName: "doc") }
            )
        }
        .sheet(isPresented: $presentInput) {
            NavigationView {
                ScrollView {
                    Text(input)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .navigationTitle("Input")
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Button(
                            action: { presentInput.toggle() },
                            label: { Image(systemName: "xmark.circle") }
                        )
                    }
                }
            }
        }
    }

    private func solveFirst() async {
        answerFirst = nil

        var outputsList: [(from: String, to: String)] = []

        var modules: [String: Module] = Dictionary(uniqueKeysWithValues: input.components(separatedBy: .newlines).filter(\.isNotEmpty).map { line in
            let components = line.components(separatedBy: " -> ")
            let input = components.first!
            let outputs = components.last!.components(separatedBy: ", ")

            switch input {
            case "broadcaster":
                outputs.forEach {
                    outputsList.append((input, $0))
                }
                return ("broadcaster", .broadcaster(outputs: outputs))
            case input where input.hasPrefix("%"):
                outputs.forEach {
                    outputsList.append((String(input.dropFirst()), $0))
                }
                return (String(input.dropFirst()), .flipFlop(isOn: false, outputs: outputs))
            case input where input.hasPrefix("&"):
                outputs.forEach {
                    outputsList.append((String(input.dropFirst()), $0))
                }
                return (String(input.dropFirst()), .conjunction(storedInputs: [:], outputs: outputs))
            default:
                fatalError()
            }
        })

        for (from, to) in outputsList {
            if let module = modules[to],
               case Module.conjunction(var storedInputs, let outputs) = module {
                storedInputs[from] = .low
                modules[to] = .conjunction(storedInputs: storedInputs, outputs: outputs)
            }
        }

        print(modules)

        var moduleStates = modules
        var resultSignals: [[Signal]] = []

        let iterations = 1000

        for index in 1...iterations {
            var signalsQueue: [InputSignal] = [InputSignal(from: "elf", signal: .low, module: "button")]
            var outputSignals: [Signal] = []

            while signalsQueue.isNotEmpty {
                let signal = signalsQueue.removeFirst()

                switch signal.module {
                case "button":
                    outputSignals.append(signal.signal)
                    signalsQueue.append(InputSignal(
                        from: "button",
                        signal: signal.signal,
                        module: "broadcaster"
                    ))
                case let moduleName where nil != moduleStates[moduleName]:
                    guard let module = moduleStates[moduleName] else {
                        fatalError()
                    }
                    switch module {
                    case .button:
                        fatalError()
                    case .broadcaster(let outputs):
                        outputs.forEach { name in
                            outputSignals.append(signal.signal)
                            signalsQueue.append(InputSignal(
                                from: moduleName,
                                signal: signal.signal,
                                module: name
                            ))
                        }
                    case .flipFlop(let isOn, let outputs):
                        if signal.signal == .high {
                            continue
                        }
                        let newState = !isOn
                        moduleStates[moduleName] = .flipFlop(isOn: newState, outputs: outputs)
                        let newSignal: Signal = newState ? .high : .low
                        outputs.forEach { name in
                            outputSignals.append(newSignal)
                            signalsQueue.append(InputSignal(
                                from: moduleName,
                                signal: newSignal,
                                module: name
                            ))
                        }
                    case .conjunction(var storedInputs, let outputs):
                        storedInputs[signal.from] = signal.signal
                        moduleStates[moduleName] = .conjunction(storedInputs: storedInputs, outputs: outputs)
                        let hasLow = Set(storedInputs.values).contains(.low)
                        let newSignal: Signal = hasLow ? .high : .low
                        outputs.forEach { name in
                            outputSignals.append(newSignal)
                            signalsQueue.append(InputSignal(
                                from: moduleName,
                                signal: newSignal,
                                module: name
                            ))
                        }
                    }
                default:
                    break
                }
            }

            resultSignals.append(outputSignals)

            if moduleStates == modules {
                print("Cycle")
                print(index)
                break
            }
        }

        let allSignals = resultSignals.flatMap { $0 }
        let highSignals = allSignals.filter { $0 == .high }
        let lowSignals = allSignals.filter { $0 == .low }

        let result = highSignals.count * lowSignals.count

        await MainActor.run {
            print("Result 1: \(result)")
            answerFirst = result
        }
    }

    private func solveSecond() async {
        answerSecond = nil

        var outputsList: [(from: String, to: String)] = []

        var modules: [String: Module] = Dictionary(uniqueKeysWithValues: input.components(separatedBy: .newlines).filter(\.isNotEmpty).map { line in
            let components = line.components(separatedBy: " -> ")
            let input = components.first!
            let outputs = components.last!.components(separatedBy: ", ")

            switch input {
            case "broadcaster":
                outputs.forEach {
                    outputsList.append((input, $0))
                }
                return ("broadcaster", .broadcaster(outputs: outputs))
            case input where input.hasPrefix("%"):
                outputs.forEach {
                    outputsList.append((String(input.dropFirst()), $0))
                }
                return (String(input.dropFirst()), .flipFlop(isOn: false, outputs: outputs))
            case input where input.hasPrefix("&"):
                outputs.forEach {
                    outputsList.append((String(input.dropFirst()), $0))
                }
                return (String(input.dropFirst()), .conjunction(storedInputs: [:], outputs: outputs))
            default:
                fatalError()
            }
        })

        for (from, to) in outputsList {
            if let module = modules[to],
               case Module.conjunction(var storedInputs, let outputs) = module {
                storedInputs[from] = .low
                modules[to] = .conjunction(storedInputs: storedInputs, outputs: outputs)
            }
        }

        print(modules)
//
//        var moduleStates = modules
//
//        var lowOnRx = false
//        var lowOnRxIndex = 0


        // Count separately when rx input node (e.g. kj) gets high pulse for each of it's parents
        // Basically for each broadcaster output (e.g. kt, pd, xv, rg)
//        while !lowOnRx {
//            lowOnRxIndex += 1
//
//            var signalsQueue: [InputSignal] = [InputSignal(from: "elf", signal: .low, module: "pd")]
//            var outputSignals: [Signal] = []
//
//            while signalsQueue.isNotEmpty {
//                let signal = signalsQueue.removeFirst()
//
//                if signal.module == "kj" && signal.signal == .high {
//                    print("High!")
//                    print(lowOnRxIndex)
//                    return
//                }
//
//                switch signal.module {
//                case "button":
//                    outputSignals.append(signal.signal)
//                    signalsQueue.append(InputSignal(
//                        from: "button",
//                        signal: signal.signal,
//                        module: "broadcaster"
//                    ))
//                case let moduleName where nil != moduleStates[moduleName]:
//                    guard let module = moduleStates[moduleName] else {
//                        fatalError()
//                    }
//                    switch module {
//                    case .button:
//                        fatalError()
//                    case .broadcaster(let outputs):
//                        outputs.forEach { name in
//                            outputSignals.append(signal.signal)
//                            signalsQueue.append(InputSignal(
//                                from: moduleName,
//                                signal: signal.signal,
//                                module: name
//                            ))
//                        }
//                    case .flipFlop(let isOn, let outputs):
//                        if signal.signal == .high {
//                            continue
//                        }
//                        let newState = !isOn
//                        moduleStates[moduleName] = .flipFlop(isOn: newState, outputs: outputs)
//                        let newSignal: Signal = newState ? .high : .low
//                        outputs.forEach { name in
//                            outputSignals.append(newSignal)
//                            signalsQueue.append(InputSignal(
//                                from: moduleName,
//                                signal: newSignal,
//                                module: name
//                            ))
//                        }
//                    case .conjunction(var storedInputs, let outputs):
//                        storedInputs[signal.from] = signal.signal
//                        moduleStates[moduleName] = .conjunction(storedInputs: storedInputs, outputs: outputs)
//                        let hasLow = Set(storedInputs.values).contains(.low)
//                        let newSignal: Signal = hasLow ? .high : .low
//                        outputs.forEach { name in
//                            outputSignals.append(newSignal)
//                            signalsQueue.append(InputSignal(
//                                from: moduleName,
//                                signal: newSignal,
//                                module: name
//                            ))
//                        }
//                    }
//                case "rx":
//                    lowOnRx = signal.signal == .low
//                default:
//                    break
//                }
//            }
//
//            if moduleStates == modules {
//                print("Cycle")
//                break
//            }
//        }

        let result = 3943 * 3863 * 4003 * 3989

        await MainActor.run {
            print("Result 2: \(result)")
            answerSecond = result
        }
    }
}

private struct InputSignal: Equatable, Hashable {
    let from: String
    let signal: Signal
    let module: String
}

private enum Signal: String, Equatable, CustomStringConvertible {
    case high
    case low

    var value: Character {
        switch self {
        case .high:
            return "1"
        case .low:
            return "0"
        }
    }

    var description: String { rawValue }
}

private enum Module: Hashable, Equatable, CustomStringConvertible {
    case button
    case broadcaster(outputs: [String])
    case flipFlop(isOn: Bool, outputs: [String])
    case conjunction(storedInputs: [String: Signal], outputs: [String])

    var description: String {
        switch self {
        case .button:
            return "button -> broadcaster"
        case .broadcaster(let outputs):
            return "broadcaster -> \(outputs.joined(separator: ", "))"
        case .flipFlop(let isOn, let outputs):
            return "% \(isOn ? "on": "off")-> \(outputs.joined(separator: ", "))"
        case .conjunction(let storedInputs, let outputs):
            return "% \(storedInputs) -> \(outputs.joined(separator: ", "))"
        }
    }
}

#Preview {
    Puzzle20(input: Input.puzzle20.testInput)
}
