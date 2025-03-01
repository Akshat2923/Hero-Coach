//
//  AddGoalOptionsView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/19/25.
//
import SwiftUI
import SwiftData

@available(iOS 17, *)
struct AddGoalOptionsView: View {
    var onSelect: (AddGoalOption) -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                goalOption(
                    icon: "pencil.circle.fill",
                    title: "Create a Goal",
                    description: "Create a goal then create mini goals.",
                    color: LinearGradient(
                        gradient: Gradient(colors: [Color.AI.cornflowerBlue, Color.AI.danube]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    action: { onSelect(.normal) }
                )
                
                if #available(iOS 18.0, *) {
                    goalOption(
                        icon: "apple.intelligence",
                        title: "Talk to Coach",
                        description: "Talk about what's on your mind and your coach will create an actionable plan.",
                        color: MeshGradient(
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
                        ),
                        action: { onSelect(.talk) }
                    )
                } else {
                    // Fallback on earlier versions
                }
                
                if #available(iOS 18.0, *) {
                    goalOption(
                        icon: "apple.writing.tools",
                        title: "Type to Coach",
                        description: "Write about what's on your mind and your coach will create an actionable plan.",
                        color: MeshGradient(
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
                        ),
                        action: { onSelect(.type) }
                    )
                } else {
                    // Fallback on earlier versions
                }
            }
            .padding()
            .navigationTitle("Create") 
            .presentationDragIndicator(.visible)
            .presentationDetents([.medium])
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    @ViewBuilder
    private func goalOption(
        icon: String,
        title: String,
        description: String,
        color: some ShapeStyle,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .cornerRadius(25)
            .shadow(radius: 5)
        }
    }
}
