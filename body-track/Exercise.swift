//
//  Exercise.swift
//  body-track
//
//  Created by 殷艺翔 on 2026/1/25.
//

import Foundation

// TODO: add some option for left hand or right hand exercises

struct ExerciseHistoryEntry: Identifiable {
    let id: UUID = UUID()
    let date: Date
    let weight: Double
    let reps: Int
}
struct Exercise: Identifiable {
    let id: UUID = UUID()
    var name: String
    var history: [ExerciseHistoryEntry] = []
}
