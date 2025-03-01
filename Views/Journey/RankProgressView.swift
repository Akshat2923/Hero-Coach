//
//  RankProgressView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/17/25.
//
import SwiftUI

@available(iOS 17, *)
struct RankProgressView: View {
    let completedGoals: Int
    let currentRank: HeroRank
    let nextRank: HeroRank?
    
    private var progress: Double {
        guard let nextRank = nextRank else { return 1.0 }
        let currentRequired = currentRank.requiredGoals
        let nextRequired = nextRank.requiredGoals
        let completed = Double(completedGoals - currentRequired)
        let total = Double(nextRequired - currentRequired)
        return completed / total
    }
    
    var body: some View {
        VStack(spacing: 16) {
            //Current Rank Badge
            VStack(spacing: 8) {
                Circle()
                    .fill(Color.accentColor.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay {
                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.accentColor)
                    }
                
                Text(currentRank.rawValue)
                    .font(.title2.bold())
                
                Text(currentRank.description)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            if let nextRank = nextRank {
                VStack(spacing: 8) {
                    Text("Progress to \(nextRank.rawValue)")
                        .font(.headline)
                    
                    ProgressView(value: progress) {
                        Text("\(completedGoals) / \(nextRank.requiredGoals) goals")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
    }
}
