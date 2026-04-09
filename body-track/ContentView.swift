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
    @State private var searchText = ""

    private var filteredExercises: [Exercise] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return store.exercises
        } else {
            return store.exercises.filter { exercise in
                exercise.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if filteredExercises.isEmpty {
                    if searchText.isEmpty {
                        Text("No exercises yet. Tap + to add one.")
                            .foregroundStyle(.secondary)
                    } else {
                        Text("No matching exercises found.")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    ForEach(filteredExercises) { exercise in
                        NavigationLink {
                            if let index = store.exercises.firstIndex(where: { $0.id == exercise.id }) {
                                ExerciseDetailView(exercise: $store.exercises[index])
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(exercise.name)
                                    .font(.headline)

                                if exercise.history.isEmpty {
                                    Text("No history yet")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                } else if let latest = exercise.history.last {
                                    Text("\(formatWeight(latest.weight))kg × \(latest.reps) reps")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteFilteredExercises)
                }
            }
            .navigationTitle("My Exercises")
            .searchable(text: $searchText, prompt: "Search exercises")
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

    private func deleteFilteredExercises(at offsets: IndexSet) {
        let exercisesToDelete = offsets.map { filteredExercises[$0].id }
        store.exercises.removeAll { exercise in
            exercisesToDelete.contains(exercise.id)
        }
    }

    private func formatWeight(_ weight: Double) -> String {
        if weight == floor(weight) {
            return String(Int(weight))
        } else {
            return String(weight)
        }
    }
}
