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
                    Text("No history recorded yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(groupedHistory, id: \.title) { group in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(group.title)
                                .font(.headline)

                            ForEach(group.entries) { entry in
                                Text("\(formatWeight(entry.weight))kg \(entry.reps) reps")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
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
    private var groupedHistory: [(title: String, entries: [ExerciseHistoryEntry])] {
        let calendar = Calendar.current

        let grouped = Dictionary(grouping: exercise.history) { entry in
            relativeDateLabel(for: entry.date, using: calendar)
        }

        let sortedGroups = grouped.map { key, value in
            (
                title: key,
                sortKey: relativeDateSortKey(for: value.first!.date, using: calendar),
                entries: value.sorted { $0.date > $1.date }
            )
        }
        .sorted { $0.sortKey < $1.sortKey }

        return sortedGroups.map { ($0.title, $0.entries) }
    }

    private func relativeDateLabel(for date: Date, using calendar: Calendar) -> String {
        let now = Date()

        if calendar.isDate(date, equalTo: now, toGranularity: .year) &&
           calendar.isDate(date, equalTo: now, toGranularity: .month) &&
           calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) {
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.dateFormat = "EEEE"
            let weekday = formatter.string(from: date)
            return "This week on \(weekday)"
        }
        
        let years = calendar.dateComponents([.year], from: date, to: now).year ?? 0
        if years >= 1 {
            return years == 1 ? "1 year ago" : "\(years) years ago"
        }

        let months = calendar.dateComponents([.month], from: date, to: now).month ?? 0
        if months >= 1 {
            return months == 1 ? "1 month ago" : "\(months) months ago"
        }

        let weeks = calendar.dateComponents([.weekOfYear], from: date, to: now).weekOfYear ?? 0
        if weeks <= 1 {
            return "Last week"
        } else {
            return "\(weeks) weeks ago"
        }
    }

    private func relativeDateSortKey(for date: Date, using calendar: Calendar) -> Int {
        let now = Date()

        if calendar.isDate(date, equalTo: now, toGranularity: .year) &&
           calendar.isDate(date, equalTo: now, toGranularity: .month) &&
           calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) {
            let weekday = calendar.component(.weekday, from: date)
            return weekday
        }

        let years = calendar.dateComponents([.year], from: date, to: now).year ?? 0
        if years >= 1 {
            return years * 1000
        }

        let months = calendar.dateComponents([.month], from: date, to: now).month ?? 0
        if months >= 1 {
            return months * 100
        }

        let weeks = max(1, calendar.dateComponents([.weekOfYear], from: date, to: now).weekOfYear ?? 1)
        return 10 + weeks
    }

    private func formatWeight(_ weight: Double) -> String {
        if weight == floor(weight) {
            return String(Int(weight))
        } else {
            return String(weight)
        }
    }
}
