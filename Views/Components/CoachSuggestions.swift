//
//  CoachSuggestions.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/22/25.
//
import SwiftUI
@available(iOS 17, *)
struct CoachSuggestions: View {
    let goals: [(
        label: String,
        mainGoal: String,
        miniGoals: [(
            title: String,
            dueDate: Date?
        )]
    )]
    
    var body: some View {
        ForEach(goals.indices, id: \.self) { index in
            let gradient = getGradientForLabel(goals[index].label)
            
            ZStack {
                gradient
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 6)
                
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(goals[index].mainGoal)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(goals[index].label)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    if !goals[index].miniGoals.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(goals[index].miniGoals, id: \.title) { miniGoal in
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 8))
                                        .foregroundColor(.white)
                                    Text(miniGoal.title)
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    //Display the due date if it exists
                                    if let dueDate = miniGoal.dueDate {
                                        Text(dueDate.formatted(date: .abbreviated, time: .omitted))
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding(20)
            }
            .padding(.vertical, 8)
        }
    }
}
