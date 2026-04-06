//
//  Exercise.swift
//  body-track
//
//  Created by 殷艺翔 on 2026/1/25.
//

import Foundation

struct Exercise: Identifiable {
    let id: UUID = UUID()
    var name: String
    var history: [Int] = []
}
