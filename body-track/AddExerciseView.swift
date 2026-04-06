//
//  AddExerciseView.swift
//  body-track
//
//  Created by 殷艺翔 on 2026/1/26.
//


import SwiftUI

struct AddExerciseView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    
    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case name
    }


    let onSave: (String) -> Void

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Exercise") {
                    TextField("Exercise name (e.g., Bench Press)", text: $name)
                        .textInputAutocapitalization(.words).focused($focusedField, equals: .name)
                }
            }
            .navigationTitle("Add Exercise").onAppear {
                focusedField = .name
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(name,)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}
