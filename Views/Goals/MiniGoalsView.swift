//
//  MiniGoalsView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/22/25.
//
import SwiftUI
@available(iOS 17, *)
struct MiniGoalsView: View {
    let miniGoal: MiniGoal
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(miniGoal.isCompleted ? Color.green.opacity(0.5) : Color.gray.opacity(0.3), lineWidth: 4)
                    .frame(width: 28, height: 28)
                
                if miniGoal.isCompleted {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 24, height: 24)
                        .transition(.scale.combined(with: .opacity))
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .transition(.opacity)
                }
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.8)) {
                    miniGoal.isCompleted.toggle()
                    miniGoal.completedDate = miniGoal.isCompleted ? Date() : nil
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(miniGoal.title)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .strikethrough(miniGoal.isCompleted, color: .green)
                    .foregroundColor(miniGoal.isCompleted ? .secondary : .primary)
                    .animation(.easeInOut, value: miniGoal.isCompleted)
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text("Due: \(miniGoal.dueDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    if let completedDate = miniGoal.completedDate {
                        Text("•")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Text("Completed: \(completedDate.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            .thinMaterial
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(miniGoal.isCompleted ? Color.green.opacity(0.3) : Color.clear, lineWidth: 4)
        )
        .contentShape(Rectangle())
        .transition(.opacity)
    }
}
