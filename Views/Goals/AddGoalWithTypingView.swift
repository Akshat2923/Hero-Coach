//
//  AddGoalWithTypingView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/19/25.
//
import SwiftUI
@available(iOS 17, *)
struct AddGoalWithTypingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var typingViewModel = AddGoalWithTypingViewModel()
    @StateObject private var analysisViewModel: AddGoalViewModel
    let onComplete: (Goal?) -> Void
    @FocusState private var isTextFieldFocused: Bool
    
    init(advisor: GoalAdvisorViewModel, onComplete: @escaping (Goal?) -> Void) {
        _analysisViewModel = StateObject(wrappedValue: AddGoalViewModel(advisor: advisor))
        self.onComplete = onComplete
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextEditorSection(inputText: $typingViewModel.inputText, isTextFieldFocused: _isTextFieldFocused)
                Text("Coach's Suggestions")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                CoachSuggestions(goals: typingViewModel.goals)
                
                CoachCreateButtonSection(
                    typingViewModel: typingViewModel,
                    analysisViewModel: analysisViewModel,
                    onComplete: onComplete
                )
                
                LoadingSection(isLoading: typingViewModel.isLoading || analysisViewModel.isLoading)
                
                ErrorSection(error: analysisViewModel.error)
            }
            .listRowBackground(Color.clear)
            
            .onChange(of: typingViewModel.inputText) { oldValue, newValue in
                if !newValue.isEmpty {
                    typingViewModel.processInput()
                }
            }
            .navigationTitle("Type to Coach")
            .onAppear {
                isTextFieldFocused = true
            }
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
struct LoadingSection: View {
    var isLoading: Bool
    
    var body: some View {
        if isLoading {
            Section {
                HStack {
                    Spacer()
                    ProgressView("Processing your goal...")
                    Spacer()
                }
            }
        }
    }
}

@available(iOS 17, *)
struct ErrorSection: View {
    var error: Error?
    
    var body: some View {
        if let error = error {
            Section {
                Text(error.localizedDescription)
                    .foregroundColor(.red)
            }
        }
    }
}
@available(iOS 17, *)
struct CoachCreateButtonSection: View {
    @ObservedObject var typingViewModel: AddGoalWithTypingViewModel
    @ObservedObject var analysisViewModel: AddGoalViewModel
    let onComplete: (Goal?) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        AIButton(title: "Create") {
            Task {
                for goal in typingViewModel.goals {
                    let mainGoal = goal.mainGoal
                    
                    if mainGoal.isEmpty { continue }
                    
                    analysisViewModel.goalText = mainGoal
                    await analysisViewModel.analyzeAndAddGoal()
                    
                    if analysisViewModel.error == nil, let createdGoal = analysisViewModel.createdGoal {
                        for miniGoalTitle in goal.miniGoals {
                            let miniGoal = MiniGoal(
                                title: miniGoalTitle.title,
                                dueDate: miniGoalTitle.dueDate ?? Calendar.current
                                    .date(
                                        byAdding: .day,
                                        value: 7,
                                        to: Date()
                                    )!
                            )
                            miniGoal.goal = createdGoal
                            createdGoal.miniGoals.append(miniGoal)
                        }
                        
                        onComplete(createdGoal)
                    }
                }
                dismiss()
            }
        }
        .listRowBackground(Color.clear)
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
        .padding(.horizontal)
        .disabled(typingViewModel.inputText.isEmpty)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

@available(iOS 17, *)
struct TextEditorSection: View {
    @Binding var inputText: String
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        Section("Write whatever's on your mind") {
            HStack {
                ZStack {
                    TextEditor(text: $inputText)
                        .frame(minHeight: 100)
                        .textFieldStyle(.automatic)
                        .focused($isTextFieldFocused)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                                .opacity(isTextFieldFocused ? 0 : 1)
                        )
                }
                .shadow(
                    color: isTextFieldFocused ?
                    Color.AI.cornflowerBlue.opacity(0.4) : .clear,
                    radius: 10
                )
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
                            ).opacity(isTextFieldFocused ? 1 : 0),
                            lineWidth: 2
                        )
                )
                
                Image(systemName: "apple.writing.tools")
            }
        }
        .listRowBackground(Color.clear)
    }
}
