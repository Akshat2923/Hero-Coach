//
//  AchievementCardView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/17/25.
//
import SwiftUI

@available(iOS 17, *)
struct AchievementCardView: View {
    let user: User
    let journey: HeroJourney
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 6) {
                Text("Hero's Journey")
                    .font(.title.bold())
                    .foregroundColor(.primary)
                
                Text(user.name)
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            Divider()
            
            HStack(
                spacing: 32
            ) {
                StatView(
                    icon: "star.circle.fill",
                    value: journey.currentRank.rawValue,
                    label: "Rank",
                    color: .blue
                )
                StatView(
                    icon: "trophy.fill",
                    value: "\(journey.level)",
                    label: "Level",
                    color: .yellow
                )
                StatView(
                    icon: "flag.fill",
                    value: "\(journey.completedGoalsCount)",
                    label: "Goals",
                    color: .green
                )
            }
            
            Divider()
            
            let completedGoals = user.goals.filter { $0.isCompleted }
            if !completedGoals.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recent Goals")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    ForEach(Array(completedGoals.prefix(3))) { goal in
                        HStack {
                            Text(goal.title)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Spacer()
                            Text("Completed")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            if !user.traits.isEmpty {
                VStack(spacing: 8) {
                    Text("Motivated by")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        ForEach(Array(user.traits.prefix(3)), id: \.self) { trait in
                            Text(trait)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .padding(24)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: Color.primary.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}

struct StatView: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
