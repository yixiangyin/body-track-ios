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
    
    @Published var exercises: [Exercise] = [        Exercise(name: "Bench Press", history: [10, 8, 6]),
                                                    Exercise(name: "Squat", history: [12, 10, 8]),
                                                    Exercise(name: "Push Up", history: [])]
    
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
