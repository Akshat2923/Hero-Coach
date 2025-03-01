//
//  ProfileView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//
import SwiftUI

@available(iOS 17, *)
struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingStartOverAlert = false
    @Environment(\.displayScale) private var displayScale
    
    private func renderAchievementCard(user: User, journey: HeroJourney) -> Image {
        let renderer = ImageRenderer(content: AchievementCardView(user: user, journey: journey))
        renderer.scale = displayScale
        return renderer.uiImage.map(Image.init) ?? Image(systemName: "exclamationmark.triangle")
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
                if let user = appState.user {
                    
                    VStack(spacing: 0) {
                        VStack(spacing: 16) {
                            HStack(alignment: .center, spacing: 20) {
                                Image(systemName: "person")
                                    .resizable()
                                    .frame(width: 88, height: 88)
                                    .foregroundColor(.accentColor)
                                    .padding(.leading, 16)
                                
                                if let journey = user.heroJourney {
                                    HStack(spacing: 20) {
                                        StatColumn(title: "Rank", value: journey.currentRank.rawValue)
                                        StatColumn(title: "Level", value: String(journey.level))
                                        StatColumn(title: "Goals", value: String(journey.completedGoalsCount))
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.top, 8)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(user.name)
                                    .font(.headline)
                                
                                if !user.roleModel.isEmpty {
                                    Text("Inspired by \(user.roleModel)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                HStack {
                                    Text("Coach:")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(user.coach.name)
                                        .font(.subheadline)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(Array(user.traits), id: \.self) { trait in
                                        Text(trait)
                                            .font(.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(.thinMaterial)
                                            .cornerRadius(16)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            if let journey = user.heroJourney {
                                let achievementImage = renderAchievementCard(user: user, journey: journey)
                                ShareLink(
                                    item: achievementImage,
                                    preview: SharePreview("Hero's Journey - \(user.name)", image: achievementImage)
                                ) {
                                    HStack {
                                        Text("Share Progress")
                                            .font(.system(.subheadline, weight: .semibold))
                                        
                                        Image(systemName: "square.and.arrow.up")
                                        
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(LinearGradient(
                                        gradient: Gradient(colors: [Color.AI.cornflowerBlue, Color.AI.danube]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Divider()
                            .padding(.vertical)
                        
                        //Goals Feed
                        VStack(alignment: .leading) {
                            Text("Completed Goals")
                                .font(.headline)
                                .padding(.horizontal, 16)
                            
                            CompletedGoalsView(goals: user.goals)
                                .padding(.top, 4)
                                .padding(.horizontal, 16)
                        }
                        
                        
                        Button(role: .destructive) {
                            showingStartOverAlert = true
                        } label: {
                            Text("Start Over")
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.thinMaterial)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                    .navigationTitle("Profile")
                    
                }
            }
            .alert("Start Over?", isPresented: $showingStartOverAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Start Over", role: .destructive) {
                    appState.startOver()
                }
            } message: {
                Text("This will reset all your data and start the onboarding process again. This action cannot be undated.")
            }
        }
    }
}

struct StatColumn: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(.title3, weight: .bold))
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
