//
//  AsyncButton.swift
//  Advent2024
//
//  Created by Konstantin Zyrianov on 2024-12-02.
//

import SwiftUI

struct AsyncButton: View {
    let title: String
    let action: () async -> Void

    @State private var inProgress: Bool = false
    @State private var task: Task<Void, Never>?

    var body: some View {
        if inProgress {
            HStack {
                ProgressView()

                Button("Cancel") {
                    task?.cancel()
                    
                    withAnimation {
                        inProgress = false
                    }
                }
            }
        } else {
            Button(title) {
                withAnimation {
                    inProgress = true
                }

                task = Task {
                    defer {
                        withAnimation {
                            inProgress = false
                        }
                    }
                    await action()
                }
            }
        }
    }
}

#Preview {
    AsyncButton(title: "Solve") {
        try? await Task.sleep(for: .seconds(2))
    }
}
