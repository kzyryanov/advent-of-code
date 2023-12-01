//
//  ContentView.swift
//  AdventOfCode2015
//
//  Created by Konstantin Zyrianov on 2023-07-12.
//

import SwiftUI

struct ContentView: View {
    @State var selectedDay: Day?
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn

    var body: some View {
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            sidebar: {
                List(Days.days, selection: $selectedDay) { day in
                    if Days.isSolved(day) {
                        NavigationLink(day.title, value: day)
                    }
                    else {
                        Text(day.title)
                            .foregroundColor(.secondary)
                    }
                }
                .navigationTitle("AoC 2015")
            },
            detail: {
                if let selectedDay {
                    selectedDay.contentView
                        .navigationTitle(selectedDay.title)
                        .toolbar {
                            ToolbarItem(placement: .navigation) {
                                Button("Close") {
                                    self.selectedDay = nil
                                }
                            }
                        }
                } else {
                    TreeView()
                        .navigationTitle("Tree")
                }
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
