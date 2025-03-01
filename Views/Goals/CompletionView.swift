//
//  CompletionView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/22/25.
//
import SwiftUI

@available(iOS 17, *)
struct CompletionView: View {
    let goal: Goal
    @Binding var isPresented: Bool
    @EnvironmentObject var appState: AppState
    @Binding var path: NavigationPath
    @State private var reflection = ""
    @FocusState private var isTextFieldFocused: Bool
    @State private var showConfetti = false
    @State private var isAnimated = false
    @State private var showingRankUp = false
    @State private var newRank: HeroRank?
    
    private func completeGoalAndUpdateJourney() {
        if let heroJourney = appState.user?.heroJourney {
            let oldRank = heroJourney.currentRank
            heroJourney.completedGoalsCount += 1
            heroJourney.updateRank()
            
            if heroJourney.currentRank != oldRank {
                newRank = heroJourney.currentRank
                showingRankUp = true
            }
        }
        
        if !reflection.isEmpty {
            goal.reflection = reflection
            if let heroJourney = appState.user?.heroJourney {
                let reflection = Reflection(
                    goalTitle: goal.title,
                    content: reflection
                )
                heroJourney.reflections.append(reflection)
                reflection.heroJourney = heroJourney
            }
        }
        
        goal.completedDate = Date()
    }
    
    var body: some View {
        NavigationStack {
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
                    .ignoresSafeArea()
                    .blur(radius: 50)
                } else {
                    // Fallback on earlier versions
                }
                
                ScrollView {
                    VStack(spacing: 32) {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Color.yellow.opacity(0.2))
                                    .frame(width: 130, height: 130)
                                    .scaleEffect(isAnimated ? 1.1 : 1.0)
                                    .animation(.easeInOut(duration: 1).repeatForever(), value: isAnimated)
                                
                                Image(systemName: "hands.clap.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.yellow)
                                    .scaleEffect(isAnimated ? 1.2 : 1.0)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.5), value: isAnimated)
                            }
                            
                            Text("You did it! 🎉")
                                .font(.largeTitle.bold())
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                            
                            Text("You've successfully completed:")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                            
                            Text("“\(goal.title)”")
                                .font(.title2.bold())
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                                .padding(.horizontal)
                        }
                        .padding(.top, 40)
                        
                        if !goal.miniGoals.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Mini Goals Completed")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.leading)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    ForEach(goal.miniGoals.filter { $0.isCompleted }) { miniGoal in
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                                .font(.headline)
                                            
                                            Text(miniGoal.title)
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                        }
                                        .padding(.vertical, 4)
                                        .transition(.scale.combined(with: .opacity))
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                            .animation(.easeInOut, value: goal.miniGoals)
                        }
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Take a Moment to Reflect (Optional)")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $reflection)
                                    .frame(height: 120)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 12)
                                    .background(Color(UIColor.systemBackground).opacity(0.8))
                                    .cornerRadius(12)
                                    .focused($isTextFieldFocused)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                                    .foregroundColor(.primary)
                                    .scrollContentBackground(.hidden)
                                
                                if reflection.isEmpty {
                                    Text("Example: This goal helped me build discipline. Next time, I'll improve by staying more consistent.")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 20)
                                        .allowsHitTesting(false)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        AIButton(
                            title: "Mark Complete",
                            action: {
                                completeGoalAndUpdateJourney()
                                isPresented = false
                                path.removeLast()
                            },
                            width: UIScreen.main.bounds.width - 40,
                            height: 50
                        )
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .presentationDetents([.large])
        .interactiveDismissDisabled(true)
        .onAppear {
            isAnimated = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showConfetti = true
            }
        }
    }
}
