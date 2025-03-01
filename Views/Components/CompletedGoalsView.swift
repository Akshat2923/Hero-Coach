//
//  CompletedGoalsView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/17/25.
//
import SwiftUI
import SwiftData

@available(iOS 17, *)
struct CompletedGoalsView: View {
    let goals: [Goal]
    
    var body: some View {
        let completedGoals = goals.filter { $0.isCompleted }
        
        if completedGoals.isEmpty {
            Text("No completed goals yet.")
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.top, 4)
        } else {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(completedGoals) { goal in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(goal.title)
                                .font(.subheadline.bold())
                        }
                        
                        if !goal.miniGoals.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(goal.miniGoals) { miniGoal in
                                    HStack(spacing: 8) {
                                        Image(systemName: "checkmark")
                                            .font(.caption)
                                            .foregroundColor(.green)
                                        Text(miniGoal.title)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.leading)
                                }
                            }
                        }
                        
                        if let reflection = goal.reflection, !reflection.isEmpty {
                            Text("Reflection: \(reflection)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.leading)
                        }
                        
                        Divider()
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
    }
}
