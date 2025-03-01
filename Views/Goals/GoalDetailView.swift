//
//  GoalDetailView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/16/25.
//
import SwiftUI
import PhotosUI
@available(iOS 17, *)

struct GoalDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var appState: AppState
    let goal: Goal
    @Binding var path: NavigationPath
    @State private var showingAddMiniGoal = false
    @State private var showingCompletionModal = false
    @State private var showingAddMiniGoals = false
    @State private var showingReflectionSheet = false
    @State private var reflectionText = ""
    @StateObject private var advisorViewModel = GoalAdvisorViewModel()
    @State private var currentAdvice: String = "Analyzing your goal..."
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var newImagesData: [Data] = []
    private var percentDone: Double {
        let completedCount = goal.miniGoals.filter { $0.isCompleted }.count
        let totalCount = goal.miniGoals.count
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }
    
    private func updateAdvice() {
        advisorViewModel.userInput = goal.title + " " + goal.label
        advisorViewModel.analyzeGoal()
    }
    
    private var pastWisdom: String? {
        guard let journey = appState.user?.heroJourney,
              journey.currentRank == .hero,
              let match = ReflectionMatcher.findBestMatch(for: goal, in: journey.reflections),
              match.score > 0.5 else {
            return nil
        }
        return match.reflection.content
    }
    private var gradient: LinearGradient {
        getGradientForLabel(goal.label)
    }
    
    
    var body: some View {
        ZStack {
            let gradient = getGradientForLabel(goal.label)
            gradient
                .blur(radius: 50)
            ScrollView {
                VStack(spacing: 24) {
                    let gradient = getGradientForLabel(goal.label)
                    //Photo Upload Section
                    VStack(alignment: .leading, spacing: 12) {
                        
                        PhotoUploadView(imagesData: Binding(
                            get: { goal.imagesData },
                            set: { goal.imagesData = $0 }
                        )) {
                            saveImages()
                        }
                    }
                    
                    //Advice Section
                    if let user = appState.user {
                        VStack(alignment: .leading, spacing: 12) {
                            
                            HStack {
                                Image(systemName: "person.fill")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .background(gradient)
                                    .clipShape(Circle())
                                
                                Text("\(user.coach.name)’s Advice")
                                    .font(.title3.weight(.semibold))
                                    .foregroundStyle(.primary)
                            }
                            
                            Text(goal.advice)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    .ultraThinMaterial
                                )
                                .cornerRadius(12)
                                .shadow(radius: 2)
                        }
                        
                        .padding(.horizontal)
                        
                        //(Only for Hero Rank)
                        if let wisdom = pastWisdom {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "lightbulb.fill")
                                        .foregroundStyle(.yellow)
                                        .font(.title2)
                                    
                                    Text("Wisdom from Your Past Self")
                                        .font(.headline.weight(.bold))
                                }
                                
                                Text(wisdom)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        .ultraThinMaterial
                                    )
                                    .cornerRadius(12)
                                    .shadow(radius: 2)
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        if goal.miniGoals.isEmpty {
                            VStack(spacing: 12) {
                                Text("Break down your goal into mini goals")
                                    .font(.headline)
                                
                                Text("Mini goals avoids the possibility of getting overwhelmed!")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                
                                Button(action: { showingAddMiniGoal = true }) {
                                    Label("Add Mini Goals", systemImage: "plus.circle.fill")
                                        .font(.headline.weight(.bold))
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                        .background(gradient)
                                        .clipShape(Capsule())
                                        .shadow(radius: 3)
                                }
                                .padding(.top, 8)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(24)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(goal.miniGoals) { miniGoal in
                                    MiniGoalsView(miniGoal: miniGoal)
                                }
                                
                                Button(action: { showingAddMiniGoal = true }) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Add More Mini Goals")
                                    }
                                    .font(.headline.weight(.bold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(gradient)
                                    .clipShape(Capsule())
                                    .shadow(radius: 3)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                }
                .padding(.vertical)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 4)
                            .foregroundColor(.white.opacity(0.2))
                        
                        Circle()
                            .trim(from: 0, to: percentDone)
                            .stroke(Color.green.opacity(0.5), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                    }
                    .frame(width: 20, height: 20)
                    
                    Text("\(Int(percentDone * 100))%")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(gradient.opacity(0.8))
                .clipShape(Capsule())
                .shadow(radius: 2)
            }
        }
        .navigationTitle(goal.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddMiniGoal) {
            NavigationStack {
                AddMiniGoalsView(goal: goal)
            }
        }
        .sheet(isPresented: $showingCompletionModal) {
            CompletionView(goal: goal, isPresented: $showingCompletionModal, path: $path)
        }
        .sheet(isPresented: $showingReflectionSheet) {
            NavigationStack {
                Form {
                    Section {
                        TextField("What did you learn from this goal?", text: $reflectionText, axis: .vertical)
                            .lineLimit(5...10)
                    }
                }
                .navigationTitle("Add Reflection")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingReflectionSheet = false
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            saveReflection()
                            showingReflectionSheet = false
                        }
                        .disabled(reflectionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
            .presentationDetents([.medium])
        }
        .onChange(of: advisorViewModel.matchedAdvice.count) { newCount in
            if let advice = advisorViewModel.matchedAdvice.first?.text {
                currentAdvice = advice
            }
        }
        .onChange(of: goal.isCompleted) { _, isCompleted in
            if isCompleted && goal.completedDate == nil {
                goal.completedDate = Date()
                showingCompletionModal = true
            }
        }
        .onAppear {
            updateAdvice()
        }
    }
    
    private func saveReflection() {
        goal.reflection = reflectionText
        
        if let heroJourney = appState.user?.heroJourney {
            let reflection = Reflection(
                goalTitle: goal.title,
                content: reflectionText
            )
            heroJourney.reflections.append(reflection)
            reflection.heroJourney = heroJourney
        }
    }
    
    private func completeGoal() {
        goal.completedDate = Date()
        
        if let heroJourney = appState.user?.heroJourney {
            heroJourney.completedGoalsCount += 1
        }
        
        showingReflectionSheet = true
    }
    private func saveImages() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save images: \(error)")
        }
    }
    
}


