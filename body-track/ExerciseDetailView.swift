//
//  ExerciseDetailView.swift
//  body-track
//

// TODO: how to make the changes persist
// TODO: how to add a time label date and weekday for each day, if there are multiple aggregate under one title
// TODO: add some button for body weight exercise to adjust the weight maybe a tickbox?

import SwiftUI

struct ExerciseDetailView: View {
    @Binding var exercise: Exercise
    @State private var repsText: String = ""
    @State private var weightText: String = ""

    private var canSave: Bool {
        guard let reps = Int(repsText.trimmingCharacters(in: .whitespacesAndNewlines)),
                let weight = Double(weightText.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return false
        }
        return reps > 0 && weight >= 0
    }

    var body: some View {
        Form {
            Section("Exercise") {
                Text(exercise.name)
                    .font(.headline)
            }

            Section("Add Entry") {
                TextField("Weight (kg)", text: $weightText).keyboardType(.decimalPad)
                TextField("Reps", text: $repsText)
                    .keyboardType(.numberPad)

                Button("Save") {
                    save()
                }
                .disabled(!canSave)
            }

            Section("History") {
                if exercise.history.isEmpty {
                    Text("No reps recorded yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(Array(exercise.history.enumerated().reversed()), id: \.offset) { index, entry in
                        HStack {
                            Text("\(formatWeight(entry.weight))kg")
                            Spacer()
                            Text("\(entry.reps) reps")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(exercise.name)
    }

    private func save() {
        let trimmedReps = repsText.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedWeight = weightText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let reps = Int(trimmedReps),
              let weight = Double(trimmedWeight),
              reps > 0,
              weight >= 0 else { return }

        let newEntry = ExerciseHistoryEntry(date: Date(), weight: weight, reps: reps)
        exercise.history.append(newEntry)

        repsText = ""
        weightText = ""
    }
    private func formatWeight(_ weight: Double) -> String {
        if weight == floor(weight) {
            return String(Int(weight))
        } else {
            return String(weight)
        }
    }
}
