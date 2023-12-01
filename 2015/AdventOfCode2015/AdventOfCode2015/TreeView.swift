//
//  StartView.swift
//  AdventOfCode2015
//
//  Created by Konstantin Zyrianov on 2023-07-12.
//

import SwiftUI

struct TreeView: View {
    @State private var treeStrings: [Day: [TreeSymbol]]?

    var body: some View {
        GeometryReader { geometry in
            if let treeStrings = treeStrings {
                ScrollView {
                    VStack {
                        ForEach(Days.days.reversed()) { day in
                            let treeString = treeStrings[day] ?? []
                            HStack {
                                HStack(spacing: 0) {
                                    ForEach(treeString.indices, id: \.self) { index in
                                        let symbol = treeString[index]
                                        Text(String(symbol.rawValue))
                                            .foregroundColor(color(for: symbol, in: day))
                                            .shadow(color: color(for: symbol, in: day), radius: shadowRadius(for: day))
                                    }
                                    .drawingGroup()
                                }
                                .frame(maxWidth: .infinity, alignment: .center)

                                Text("\(day.day)")
                            }
                        }
                    }
                    .monospaced()
                    .padding()
                    .frame(minHeight: geometry.size.height)
                }
            } else {
                ProgressView()
                    .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
            }
        }
        .task {
            Task {
                let treeStrings = Dictionary(
                    uniqueKeysWithValues: Days.days.map({ ($0, $0.treeString) })
                )

                await MainActor.run {
                    self.treeStrings = treeStrings
                }
            }
        }
    }

    private func color(for symbol: TreeSymbol, in day: Day) -> Color {
        Days.isSolved(day) ? symbol.color : TreeSymbol.nonSolvedColor
    }

    private func shadowRadius(for day: Day) -> CGFloat {
        Days.isSolved(day) ? 2 : 0
    }
}

struct TreeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TreeView()
        }
    }
}
