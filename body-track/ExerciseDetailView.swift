//
//  ExerciseDetailView.swift
//  body-track
//

// TODO: how to make the changes persist
// TODO: how to add a time label date and weekday for each day, if there are multiple aggregate under one title
// TODO: how to sort the history in reverse, latest first
import SwiftUI

struct ExerciseDetailView: View {
    @Binding var exercise: Exercise
    @State private var repsText: String = ""

    private var canSave: Bool {
        guard let reps = Int(repsText.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return false
        }
        return reps > 0
    }

    var body: some View {
        Form {
            Section("Exercise") {
                Text(exercise.name)
                    .font(.headline)
            }

            Section("Add Reps") {
                TextField("Enter reps", text: $repsText)
                    .keyboardType(.numberPad)

                Button("Save Reps") {
                    saveReps()
                }
                .disabled(!canSave)
            }

            Section("Reps History") {
                if exercise.history.isEmpty {
                    Text("No reps recorded yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(Array(exercise.history.enumerated().reversed()), id: \.offset) { index, reps in
                        HStack {
                            Text("Set \(index + 1)")
                            Spacer()
                            Text("\(reps) reps")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(exercise.name)
    }

    private func saveReps() {
        let trimmed = repsText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let reps = Int(trimmed), reps > 0 else { return }

        exercise.history.append(reps)
        repsText = ""
    }
}
