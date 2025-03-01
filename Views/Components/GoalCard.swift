//
//  GoalCard.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/16/25.
//
import SwiftUI

@available(iOS 17, *)
struct GoalCard: View {
    let goal: Goal
    let gradient: LinearGradient
    
    var completedMiniGoalsCount: Int {
        goal.miniGoals.filter { $0.isCompleted }.count
    }
    
    var progress: Double {
        guard !goal.miniGoals.isEmpty else { return 0 }
        return Double(completedMiniGoalsCount) / Double(goal.miniGoals.count)
    }
    
    var body: some View {
        ZStack {
            gradient
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 6)
            
            VStack(alignment: .leading, spacing: 16) {
                if !goal.imagesData.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(goal.imagesData, id: \.self) { data in
                                if let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }
                
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(goal.title)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(goal.label)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                if !goal.miniGoals.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .frame(height: 6)
                                    .foregroundColor(.white.opacity(0.2))
                                
                                Capsule()
                                    .frame(width: CGFloat(progress) * geometry.size.width, height: 6)
                                    .foregroundColor(.white)
                                    .shadow(color: .white.opacity(0.5), radius: 4, x: 0, y: 0)
                            }
                        }
                        .frame(height: 6)
                        
                        Text("\(completedMiniGoalsCount) of \(goal.miniGoals.count) mini goals completed")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity, minHeight: 120) 
    }
}
