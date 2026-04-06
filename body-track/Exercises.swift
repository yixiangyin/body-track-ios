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
    
    @Published var exercises: [Exercise] = []
    
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
