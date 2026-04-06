//
//  Exercises.swift
//  body-track
//
//  Created by 殷艺翔 on 2026/1/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class Exercises: ObservableObject {
    
    @Published var exercises: [Exercise] = [
        Exercise(
            name: "Bench Press",
            history: [
                ExerciseHistoryEntry(
                    date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
                    weight: 20,
                    reps: 15
                ),
                ExerciseHistoryEntry(
                    date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
                    weight: 20,
                    reps: 15
                ),
                ExerciseHistoryEntry(
                    date: Calendar.current.date(byAdding: .day, value: -14, to: Date())!,
                    weight: 15,
                    reps: 16
                )
            ]
        )
    ]
    
    func add(name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let newExercise = Exercise(name: trimmedName)
        exercises.append(newExercise)
    }
    func delete(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
    }
}
