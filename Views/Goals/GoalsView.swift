//
//  GoalsView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//
import SwiftData
import SwiftUI

@available(iOS 17, *)
struct GoalsView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var appState: AppState
    @StateObject private var advisor = GoalAdvisorViewModel()
    @Binding var path: NavigationPath
    @State private var showingAddGoalOptions = false
    @State private var selectedAddGoalOption: AddGoalOption?
    @State private var searchText = ""
    let labelGradient: LabelGradient
    
    @State private var activeGoals: [Goal] = []
    
    init(path: Binding<NavigationPath>, labelGradient: LabelGradient) {
        _path = path
        self.labelGradient = labelGradient
    }
    
    var filteredGoals: [Goal] {
        let filtered = searchText.isEmpty ?
        activeGoals :
        activeGoals.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        
        return filtered.sorted { goal1, goal2 in
            if goal1.isPinned && !goal2.isPinned {
                return true
            } else if !goal1.isPinned && goal2.isPinned {
                return false
            }
            return goal1.title < goal2.title
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [labelGradient.colors.0, labelGradient.colors.1]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .blur(radius: 50)
            
            ScrollView {
                VStack {
                    if filteredGoals.isEmpty {
                        ContentUnavailableView(
                            searchText.isEmpty ? "No Active Goals" : "No Matching Goals",
                            systemImage: "target",
                            description: Text(
                                searchText.isEmpty ? "Tap the + button to add your first goal" : "No goals match your search"
                            )
                        )
                    } else {
                        GoalListView(goals: filteredGoals, labelGradient: labelGradient)
                    }
                    
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search goals")
            .onAppear {
                updateActiveGoals()
            }
            .onChange(of: appState.user?.goals) { _ in
                updateActiveGoals()
            }
            .navigationTitle(labelGradient.label)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddGoalOptions = true }) {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [labelGradient.colors.0, labelGradient.colors.1]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddGoalOptions) {
            AddGoalOptionsSheet(
                selectedAddGoalOption: $selectedAddGoalOption,
                showingAddGoalOptions: $showingAddGoalOptions
            )
        }
        .sheet(item: $selectedAddGoalOption) { option in
            AddGoalSheet(
                option: option,
                advisor: advisor,
                appState: _appState,
                path: $path,
                selectedAddGoalOption: $selectedAddGoalOption
            )
        }
    }
    
    private func updateActiveGoals() {
        activeGoals = appState.user?.goals.filter {
            $0.completedDate == nil && $0.label == labelGradient.label
        } ?? []
    }
}

@available(iOS 17, *)
struct GoalListView: View {
    let goals: [Goal]
    let labelGradient: LabelGradient
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible())], spacing: 16) {
            ForEach(goals) { goal in
                NavigationLink(value: goal) {
                    GoalCard(
                        goal: goal,
                        gradient: LinearGradient(
                            gradient: Gradient(colors: [labelGradient.colors.0, labelGradient.colors.1]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(alignment: .topTrailing) {
                        if goal.isPinned {
                            Image(systemName: "pin.fill")
                                .foregroundColor(.yellow)
                                .padding(8)
                        }
                    }
                }
                .contextMenu {
                    Button {
                        withAnimation {
                            appState.togglePinGoal(withId: goal.id)
                        }
                    } label: {
                        Label(goal.isPinned ? "Unpin Goal" : "Pin Goal",
                              systemImage: goal.isPinned ? "pin.slash" : "pin")
                    }
                    
                    Button(role: .destructive) {
                        withAnimation {
                            appState.deleteGoal(withId: goal.id)
                        }
                    } label: {
                        Label("Delete Goal", systemImage: "trash")
                    }
                }
            }
        }
        .padding()
    }
}

// MARK: - Add Goal Options Sheet
struct AddGoalOptionsSheet: View {
    @Binding var selectedAddGoalOption: AddGoalOption?
    @Binding var showingAddGoalOptions: Bool
    
    var body: some View {
        NavigationStack {
            if #available(iOS 17, *) {
                AddGoalOptionsView { option in
                    showingAddGoalOptions = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        selectedAddGoalOption = option
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

// MARK: - Add Goal Sheet
@available(iOS 17, *)
struct AddGoalSheet: View {
    let option: AddGoalOption
    @ObservedObject var advisor: GoalAdvisorViewModel
    @EnvironmentObject var appState: AppState
    @Binding var path: NavigationPath
    @Binding var selectedAddGoalOption: AddGoalOption?
    
    var body: some View {
        NavigationStack {
            switch option {
            case .normal:
                AddGoalView(advisor: advisor) { newGoal in
                    if let newGoal = newGoal {
                        appState.addGoal(newGoal)
                        path.append(newGoal)
                        selectedAddGoalOption = nil
                    }
                }
            case .talk:
                AddGoalWithSpeechView(advisor: advisor) { newGoal in
                    if let newGoal = newGoal {
                        appState.addGoal(newGoal)
                        selectedAddGoalOption = nil
                    }
                }
            case .type:
                AddGoalWithTypingView(advisor: advisor) { newGoal in
                    if let newGoal = newGoal {
                        appState.addGoal(newGoal)
                        selectedAddGoalOption = nil
                    }
                }
            }
        }
    }
}

// MARK: - AddGoalOption Enum
enum AddGoalOption: Identifiable {
    case normal, talk, type
    
    var id: String {
        switch self {
        case .normal: return "normal"
        case .talk: return "talk"
        case .type: return "type"
        }
    }
}
