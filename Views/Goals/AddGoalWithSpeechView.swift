//
//  AddGoalWithSpeechView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/19/25.
//
import SwiftUI
@available(iOS 18.0, *)
private var meshGradient: MeshGradient {
    MeshGradient(
        width: 3,
        height: 3,
        points: [
            [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
            [0.0, 0.5], [0.6, 0.4], [1.0, 0.5],
            [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
        ],
        colors: [
            Color.AI.mandy,
            Color.AI.ecstasy,
            Color.AI.silverSand,
            Color.AI.mediumPurple,
            Color.AI.cornflowerBlue,
            Color.AI.tonysPink,
            Color.AI.redRibbon,
            Color.AI.fuchsiaPink,
            Color.AI.wisteria,
            Color.AI.danube
        ]
    )
}
@available(iOS 17.0, *)
struct MicButtonTransition: ViewModifier {
    let phase: TransitionPhase
    func body(content: Content) -> some View {
        content
            .scaleEffect(phase.isIdentity ? 1 : 0.5)
            .opacity(phase.isIdentity ? 1 : 0)
            .blur(radius: phase.isIdentity ? 0 : 10)
            .rotationEffect(.degrees(phase == .willAppear ? 360 : phase == .didDisappear ? -360 : .zero))
            .brightness(phase == .willAppear ? 1 : 0)
    }
}
@available(iOS 17, *)
struct AddGoalWithSpeechView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var speechViewModel = AddGoalWithSpeechViewModel()
    
    @StateObject private var analysisViewModel: AddGoalViewModel
    let onComplete: (Goal?) -> Void
    init(advisor: GoalAdvisorViewModel, onComplete: @escaping (Goal?) -> Void) {
        _analysisViewModel = StateObject(wrappedValue: AddGoalViewModel(advisor: advisor))
        self.onComplete = onComplete
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 24) {
                        SpeechInputSection(speechViewModel: speechViewModel)
                        
                        Text("Coach's Suggestions")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        if !speechViewModel.isRecording && !speechViewModel.goals.isEmpty {
                            CoachSuggestions(goals: speechViewModel.goals)
                                .padding(.horizontal, 24)
                            CreateButtonSection(
                                speechViewModel: speechViewModel,
                                analysisViewModel: analysisViewModel,
                                onComplete: onComplete
                            )
                        }
                        
                        if speechViewModel.isLoading || analysisViewModel.isLoading {
                            ProgressView("Processing your goal...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                        }
                        
                        if let error = analysisViewModel.error {
                            Text(error.localizedDescription)
                                .foregroundColor(.red)
                                .font(.subheadline)
                                .padding()
                        }
                        
                        Spacer()
                            .frame(height: 100)
                    }
                    .padding(.vertical)
                }
                
                VStack {
                    Spacer()
                    MicButton(speechViewModel: speechViewModel)
                        .padding(.bottom, 32)
                }
            }
            .navigationTitle("Talk to Coach")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onComplete(nil)
                        dismiss()
                    }
                }
                
            }
            
        }
    }
}
@available(iOS 17, *)
struct MicButton: View {
    
    @ObservedObject
    var speechViewModel: AddGoalWithSpeechViewModel
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                if speechViewModel.isRecording {
                    speechViewModel.stopRecording()
                } else {
                    speechViewModel.startRecording()
                }
            }
        } label: {
            ZStack {
                if #available(iOS 18.0, *) {
                    Circle()
                        .fill(meshGradient)
                        .frame(width: 64, height: 64)
                        .scaleEffect(speechViewModel.isRecording ? 1.2 : 1)
                        .animation(
                            .easeInOut(
                                duration: 1.0
                            ).repeatForever(
                                autoreverses: true
                            ),
                            value: speechViewModel.isRecording
                        )
                } else {
                    Circle()
                        .fill(Color.AI.mandy)
                        .frame(width: 64, height: 64)
                }
                
                Image(systemName: "apple.intelligence")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
            }
        }
        .transition(.modifier(
            active: MicButtonTransition(phase: .didDisappear),
            identity: MicButtonTransition(phase: .identity)
        ))
    }
}
@available(iOS 17, *)
struct SpeechInputSection: View {
    
    @ObservedObject
    var speechViewModel: AddGoalWithSpeechViewModel
    var body: some View {
        VStack {
            Text(speechViewModel.speechText.isEmpty ? "Tap the mic and start speaking..." : speechViewModel.speechText)
                .font(.title3)
            
                .padding()
            
                .shadow(
                    color: speechViewModel.isRecording ?
                    Color.AI.cornflowerBlue.opacity(0.4) : .clear,
                    radius: 10
                )
            
                .padding(.horizontal)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.AI.mandy,
                                    Color.AI.fuchsiaPink,
                                    Color.AI.cornflowerBlue
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ).opacity(speechViewModel.isRecording ? 1 : 0),
                            lineWidth: 2
                        )
                        .padding(.horizontal)
                )
        }
    }
}
@available(iOS 17, *)
struct CreateButtonSection: View {
    
    @ObservedObject
    var speechViewModel: AddGoalWithSpeechViewModel
    
    @ObservedObject
    var analysisViewModel: AddGoalViewModel
    let onComplete: (Goal?) -> Void
    var body: some View {
        AIButton(title: "Create") {
            Task {
                for goal in speechViewModel.goals {
                    let mainGoal = goal.mainGoal
                    
                    if mainGoal.isEmpty { continue }
                    
                    analysisViewModel.goalText = mainGoal
                    await analysisViewModel.analyzeAndAddGoal()
                    
                    if analysisViewModel.error == nil, let createdGoal = analysisViewModel.createdGoal {
                        for miniGoalInfo in goal.miniGoals {
                            let miniGoal = MiniGoal(
                                title: miniGoalInfo.title,
                                dueDate: miniGoalInfo.dueDate ?? Calendar.current
                                    .date(
                                        byAdding: .day,
                                        value: 7,
                                        to: Date()
                                    )! // Fallback
                            )
                            miniGoal.goal = createdGoal
                            createdGoal.miniGoals.append(miniGoal)
                        }
                        
                        onComplete(createdGoal)
                    }
                }
            }
        }
        .frame(width: 100, height: 40)
        .padding(.horizontal)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
