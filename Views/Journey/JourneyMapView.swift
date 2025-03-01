//
//  JourneyMapView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/17/25.
//
import SwiftUI
import SwiftData

@available(iOS 17, *)
struct JourneyMapView: View {
    @EnvironmentObject var appState: AppState
    
    private var journey: HeroJourney? {
        appState.user?.heroJourney
    }
    
    var body: some View {
        ZStack {
            
            if #available(iOS 18.0, *) {
                MeshGradient(
                    width: 3,
                    height: 3,
                    points: [
                        [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                        [0.0, 0.5], [0.6, 0.4], [1.0, 0.5],
                        [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                    ],
                    colors: [
                        Color.AI.mandy, Color.AI.redRibbon, Color.AI.ecstasy,
                        Color.AI.tonysPink, Color.AI.mediumPurple, Color.AI.fuchsiaPink,
                        Color.AI.wisteria, Color.AI.cornflowerBlue, Color.AI.danube
                    ]
                )
                .blur(radius: 50)
                
            } else {
                // Fallback on earlier versions
            }
            ScrollView {
                if let journey = journey {
                    VStack(spacing: 32) {
                        VStack(spacing: 8) {
                            Text("Current Rank")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text(journey.currentRank.rawValue)
                                .font(.title.bold())
                            
                            Text("Level \(journey.level)")
                                .font(.title3)
                                .foregroundColor(.accentColor)
                            
                            Text("\(journey.completedGoalsCount) goals completed")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        //Journey Map
                        VStack(spacing: 0) {
                            ForEach(HeroRank.allRanks, id: \.self) { rank in
                                JourneyNode(
                                    rank: rank,
                                    isCurrentRank: rank == journey.currentRank,
                                    isCompleted: journey.completedGoalsCount >= rank.requiredGoals,
                                    completedGoals: journey.completedGoalsCount
                                )
                                
                                if rank != .hero {
                                    JourneyPath(
                                        isCompleted: journey.completedGoalsCount >= rank.requiredGoals
                                    )
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                        )
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                } else {
                    ContentUnavailableView(
                        "Journey Not Started",
                        systemImage: "map",
                        description: Text("Complete your first goal to begin your hero's journey!")
                    )
                }
            }
            .navigationTitle("Hero's Journey")
        }
    }
}

struct JourneyNode: View {
    let rank: HeroRank
    let isCurrentRank: Bool
    let isCompleted: Bool
    let completedGoals: Int
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(isCompleted ? Color.accentColor : Color.gray.opacity(0.3))
                .frame(width: 60, height: 60)
                .overlay {
                    if isCompleted {
                        Image(systemName: "star.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    } else {
                        Text("\(rank.requiredGoals)")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                }
                .overlay {
                    if isCurrentRank {
                        Circle()
                            .strokeBorder(Color.accentColor, lineWidth: 3)
                            .frame(width: 70, height: 70)
                    }
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(rank.rawValue)
                    .font(.headline)
                
                Text(rank.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                
                if isCurrentRank {
                    Text("\(completedGoals)/\(rank == .hero ? rank.requiredGoals : HeroRank.allRanks[rank.index + 1].requiredGoals) goals")
                        .font(.caption)
                        .foregroundColor(.accentColor)
                        .padding(.top, 4)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(isCurrentRank ? Color.accentColor.opacity(0.1) : Color.clear)
        .cornerRadius(12)
    }
}

struct JourneyPath: View {
    let isCompleted: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(isCompleted ? Color.accentColor : Color.gray.opacity(0.3))
                .frame(width: 4, height: 40)
        }
        .padding(.leading, 29)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
