//
//  TraitsSelectionView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//
import SwiftUI
@available(iOS 17, *)
struct TraitsSelectionView: View {
    @Binding var selectedTraits: Set<String>
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var searchQuery: String = ""
    @State private var animateTraits: Bool = false
    
    private let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 150), spacing: 12)
    ]
    
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
    private func filteredTraits() -> [String] {
        if searchQuery.isEmpty {
            return viewModel.availableTraits
        } else {
            return viewModel.availableTraits.filter { $0.localizedCaseInsensitiveContains(searchQuery) }
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
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 16) {
                    Text("What motivates you?")
                        .font(.system(size: 32, weight: .bold))
                        .multilineTextAlignment(.center)
                    
                    Text("Select the traits that resonate with your personality")
                        .font(.system(size: 16, weight: .regular))
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                //Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search traits...", text: $searchQuery)
                        .textFieldStyle(.plain)
                    if !searchQuery.isEmpty {
                        Button(action: { searchQuery = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.systemGray6))
                )
                .padding(.horizontal)
                
                //Traits Grid
                if viewModel.error != nil {
                    ErrorView()
                } else if viewModel.availableTraits.isEmpty {
                    LoadingView()
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(Array(filteredTraits().enumerated()), id: \.element) { index, trait in
                                if !trait.isEmpty && trait != "\"" {
                                    TraitButton(
                                        label: trait,
                                        isSelected: selectedTraits.contains(trait),
                                        colors: colorPairForIndex(index),
                                        action: {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                if selectedTraits.contains(trait) {
                                                    selectedTraits.remove(trait)
                                                } else {
                                                    selectedTraits.insert(trait)
                                                }
                                                viewModel.onTraitsSelected()
                                            }
                                        }
                                    )
                                    .offset(y: animateTraits ? 0 : 50)
                                    .opacity(animateTraits ? 1 : 0)
                                    .animation(
                                        .spring(response: 0.5, dampingFraction: 0.8)
                                        .delay(Double(index) * 0.03),
                                        value: animateTraits
                                    )
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                
            }
            .onAppear {
                withAnimation {
                    animateTraits = true
                }
            }
        }
    }
}

struct TraitButton: View {
    let label: String
    let isSelected: Bool
    let colors: (Color, Color)
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(isSelected ? .white : .primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(
                            isSelected ?
                            LinearGradient(
                                gradient: Gradient(colors: [colors.0, colors.1]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                                LinearGradient(
                                    gradient: Gradient(
                                        colors: [
                                            Color.AI.silverSand.opacity(
                                                0.2
                                            ),
                                            Color.AI.silverSand.opacity(
                                                0.2
                                            )
                                        ]
                                    ),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                        )
                )
                .shadow(color: isSelected ? colors.0.opacity(0.3) : .clear, radius: 8, y: 2)
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.2), value: isSelected)
    }
}

private struct ErrorView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundStyle(Color.AI.redRibbon)
            Text("Failed to load traits")
                .font(.headline)
            Text("Please try again later")
                .font(.subheadline)
                .foregroundStyle(Color.AI.silverSand)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


