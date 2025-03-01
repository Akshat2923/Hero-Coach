//
//  CoachPreviewView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//
import SwiftUI

@available(iOS 17, *)
struct CoachPreviewView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Binding var isLoading: Bool
    var completeOnboarding: () -> Void
    
    
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
            VStack(spacing: 20) {
                Text("Meet Your Coach")
                    .font(.title)
                    .fontWeight(.bold)
                
                if let coach = viewModel.coach {
                    CoachCard(coach: coach)
                        .padding()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Coaching Style")
                            .font(.headline)
                        Text(coach.speakingStyle)
                            .foregroundColor(.secondary)
                        
                        Text("Personality")
                            .font(.headline)
                            .padding(.top)
                        Text(coach.personality)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .padding()
                } else {
                    Text("Creating your personalized coach...")
                        .foregroundColor(.secondary)
                        .onAppear {
                            viewModel.updateCoach()
                        }
                }
                
                
                // Check if required fields are filled
                if viewModel.isRequiredFieldsFilled {
                    AIButton(
                        title: "Get Started",
                        action: {
                            isLoading = true
                            completeOnboarding()
                        },
                        width: UIScreen.main.bounds.width - 40,
                        height: 50
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    
                } else {
                    Text("Please fill in all required fields to continue.")
                        .foregroundColor(.red)
                        .padding(.bottom, 20)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
}


