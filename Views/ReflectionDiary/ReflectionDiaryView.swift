//
//  ReflectionDiaryView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/16/25.
//
import SwiftUI
import SwiftData

@available(iOS 17, *)
struct ReflectionDiaryView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedFilter: SharedReflectionFilter = .all
    
    
    private var journey: HeroJourney? {
        appState.user?.heroJourney
    }
    
    private var filteredReflections: [Reflection] {
        guard let reflections = journey?.reflections else { return [] }
        let sorted = reflections.sorted { $0.createdAt > $1.createdAt }
        
        switch selectedFilter {
        case .all: return sorted
        case .recent: return Array(sorted.prefix(5))
        case .oldest: return sorted.reversed()
        }
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
                VStack(spacing: 0) {
                    VStack(spacing: 12) {
                        Image(systemName: "book.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.white.opacity(0.9))
                        
                        Text("Book of Wisdom")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        if let journey = journey {
                            Text("\(journey.reflections.count) reflections from your journey")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                    .padding(.vertical, 32)
                    .frame(maxWidth: .infinity)
                    
                    //Main Content
                    if let journey = journey, !journey.reflections.isEmpty {
                        VStack(spacing: 16) {
                            Picker("Filter", selection: $selectedFilter) {
                                ForEach(SharedReflectionFilter.allCases, id: \.self) { filter in
                                    Text(filter.rawValue).tag(filter)
                                }
                            }
                            .pickerStyle(.segmented)
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                            
                            LazyVStack(spacing: 12) {
                                ForEach(filteredReflections) { reflection in
                                    WisdomCard(reflection: reflection)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    } else {
                        ContentUnavailableView(
                            "Your Book Awaits",
                            systemImage: "book.closed",
                            description: Text("Complete goals and add reflections to fill your Book of Wisdom")
                                .foregroundStyle(.white.opacity(0.7))
                        )
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Book of Wisdom")
    }
}

@available(iOS 17, *)
private struct WisdomCard: View {
    let reflection: Reflection
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(reflection.goalTitle)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundStyle(.primary)
                        
                        Text(reflection.createdAt.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }
            
            if isExpanded {
                Text(reflection.content)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
                    .transition(.opacity)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

enum SharedReflectionFilter: String, CaseIterable {
    case all = "All"
    case recent = "Recent"
    case oldest = "Oldest"
}
