//
//  ContentView.swift
//  body-track
//
//  Created by 殷艺翔 on 2026/1/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = Exercises()
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            List {
                if store.exercises.isEmpty {
                    Text("No exercises yet. Tap + to add one.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(store.exercises) { ex in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(ex.name)
                                .font(.headline)

                        }
                    }
                    .onDelete(perform: store.delete)
                }
            }
            .navigationTitle("My Exercises")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddExerciseView { name in
                    store.add(name: name)
                }
            }
        }
    }
}
