//
//  LabelFolderView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/19/25.
//
import SwiftUI

struct LabelGradient: Hashable, Equatable {
    let label: String
    let colors: (Color, Color)
    
    static func == (lhs: LabelGradient, rhs: LabelGradient) -> Bool {
        return lhs.label == rhs.label && lhs.colors == rhs.colors
    }
    
    // Implementing Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(label)
        hasher.combine(colors.0)
        hasher.combine(colors.1)
    }
}

@available(iOS 17, *)
struct LabelFoldersView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var appState: AppState
    @Binding var path: NavigationPath
    @State private var showingAddGoalOptions = false
    @State private var selectedAddGoalOption: AddGoalOption?
    @StateObject private var advisor = GoalAdvisorViewModel()
    
    
    let labelData: [String: (icon: String, colorIndex: Int)] = [
        "Personal Growth": ("📈", 0),
        "Humor": ("😂", 1),
        "Health & Fitness": ("💪", 2),
        "Recreation & Leisure": ("🎮", 3),
        "Family/Friends/Relationships": ("❤️", 4),
        "Finance": ("💰", 5),
        "Career": ("🚀", 6),
        "Education/Training": ("📚", 7),
        "Time Management/Organization": ("⏳", 8),
        "Philanthropic": ("🌍", 9)
    ]
    
    var uniqueLabels: [String] {
        Array(Set(appState.user?.goals.map { $0.label } ?? [])).sorted()
    }
    func colorPairForIndex(_ index: Int) -> (Color, Color) {
        let pairs: [(Color, Color)] = [
            (Color.AI.mandy, Color.AI.redRibbon),
            (Color.AI.cornflowerBlue, Color.AI.danube),
            (Color.AI.mediumPurple, Color.AI.wisteria),
            (Color.AI.ecstasy, Color.AI.tonysPink),
            (Color.AI.fuchsiaPink, Color.AI.wisteria),
            (Color.AI.mandy, Color.AI.ecstasy),
            (Color.AI.cornflowerBlue, Color.AI.wisteria),
            (Color.AI.redRibbon, Color.AI.tonysPink),
            (Color.AI.fuchsiaPink, Color.AI.cornflowerBlue),
            (Color.AI.mediumPurple, Color.AI.redRibbon)
        ]
        return pairs[index % pairs.count]
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
                VStack {
                    if let quote = advisor.matchedQuote {
                        QuoteCard(quote: quote)
                            .padding()
                    }
                    if uniqueLabels.isEmpty {
                        ContentUnavailableView(
                            "No Paths",
                            systemImage: "plus",
                            description: Text("Add your first goal to create a path")
                        )
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(uniqueLabels, id: \.self) { label in
                                let data = labelData[label] ?? ("📁", 0)  // Default icon/color if missing
                                let colors = colorPairForIndex(data.colorIndex)
                                let labelGradient = LabelGradient(label: label, colors: colors)
                                
                                NavigationLink(value: labelGradient) {
                                    LabelFolderCard(
                                        label: label,
                                        count: appState.user?.goals.filter {
                                            $0.label == label && $0.completedDate == nil
                                        }.count ?? 0,
                                        icon: data.icon,
                                        gradient: LinearGradient(
                                            gradient: Gradient(colors: [colors.0, colors.1]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                }
                            }
                        }
                        .padding()
                    }
                }
                .onAppear {
                    if let user = appState.user {
                        if advisor.roleModel != user.roleModel || advisor.selectedLabels != user.traits {
                            advisor.roleModel = user.roleModel
                            advisor.selectedLabels = user.traits
                            advisor.updateMatchedQuote()
                        }
                    }
                }
            }
        }
        .navigationTitle("Paths")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddGoalOptions = true }) {
                    if #available(iOS 18.0, *) {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                            .cornerRadius(8)
                            .foregroundStyle(
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
                                
                            )
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddGoalOptions) {
            NavigationStack {
                AddGoalOptionsView { option in
                    showingAddGoalOptions = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        selectedAddGoalOption = option
                    }
                }
            }
        }
        .sheet(item: $selectedAddGoalOption) { option in
            NavigationStack {
                switch option {
                case .normal:
                    AddGoalView(advisor: GoalAdvisorViewModel()) { newGoal in
                        if let newGoal = newGoal {
                            appState.addGoal(newGoal)
                            selectedAddGoalOption = nil
                            path.append(newGoal)
                        }
                    }
                case .talk:
                    AddGoalWithSpeechView(advisor: GoalAdvisorViewModel()) { newGoal in
                        if let newGoal = newGoal {
                            appState.addGoal(newGoal)
                            selectedAddGoalOption = nil
                        }
                    }
                case .type:
                    AddGoalWithTypingView(advisor: GoalAdvisorViewModel()) { newGoal in
                        if let newGoal = newGoal {
                            appState.addGoal(newGoal)
                            selectedAddGoalOption = nil
                        }
                    }
                }
            }
        }
    }
}
