//
//  MainView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//
import SwiftUI

@available(iOS 17, *)
struct MainView: View {
    @EnvironmentObject var appState: AppState
    @State private var path: NavigationPath = NavigationPath()
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            NavigationStack(path: $path) {
                LabelFoldersView(path: $path)
                    .navigationDestination(for: LabelGradient.self) { labelGradient in
                        GoalsView(path: $path, labelGradient: labelGradient)
                    }
                    .navigationDestination(for: Goal.self) { goal in
                        GoalDetailView(goal: goal, path: $path)
                    }
            }
            .environmentObject(appState)
            .tabItem {
                Label("Goals", systemImage: "book")
            }
            .tag(0)
            
            NavigationStack {
                JourneyMapView()
            }
            .tabItem {
                Label("Journey", systemImage: "backpack")
            }
            .tag(1)
            
            NavigationStack {
                ReflectionDiaryView()
            }
            .tabItem {
                Label("Book", systemImage: "book.closed")
            }
            .tag(2)
            
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.text.rectangle")
            }
            .tag(3)
        }
    }
}
