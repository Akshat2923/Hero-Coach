//
//  AddMiniGoalView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/16/25.
//
import SwiftUI
import SwiftData

@available(iOS 17, *)
struct AddMiniGoalsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let goal: Goal
    
    @State private var miniGoalTitles: [String] = [""]
    @State private var miniGoalDueDates: [Date] = [Calendar.current.date(
        byAdding: .day,
        value: 7,
        to: Date()
    ) ?? Date()]
    @FocusState private var focusedField: Int?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(miniGoalTitles.indices, id: \.self) { index in
                    MiniGoalEditRow(
                        title: $miniGoalTitles[index],
                        dueDate: $miniGoalDueDates[index],
                        isFocused: index == focusedField
                    )
                    .focused($focusedField, equals: index)
                }
                .onDelete(perform: deleteMiniGoal)
                
                Button(action: addMiniGoal) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Another Mini Goal")
                    }
                }
            }
            .navigationTitle("Add Mini Goals")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                focusedField = 0
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveMiniGoals()
                    }
                    .disabled(
                        miniGoalTitles.isEmpty || miniGoalTitles.contains(
                            where: {
                                $0.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ).isEmpty
                            })
                    )
                }
            }
        }
    }
    
    private func addMiniGoal() {
        miniGoalTitles.append("")
        miniGoalDueDates.append(Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date())
    }
    
    private func deleteMiniGoal(at offsets: IndexSet) {
        miniGoalTitles.remove(atOffsets: offsets)
        miniGoalDueDates.remove(atOffsets: offsets)
    }
    
    private func saveMiniGoals() {
        for (title, dueDate) in zip(miniGoalTitles, miniGoalDueDates) {
            if !title.isEmpty {
                let miniGoal = MiniGoal(title: title, dueDate: dueDate)
                miniGoal.goal = goal
                goal.miniGoals.append(miniGoal)
            }
        }
        dismiss()
    }
}
