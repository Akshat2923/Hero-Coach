//
//  RoleModelInputView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//
import SwiftUI

struct RoleModelInputView: View {
    @Binding var roleModel: String
    
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
                .ignoresSafeArea()
                
            } else {
                // Fallback on earlier versions
            }
            VStack(spacing: 20) {
                Text("Who inspires you?")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Enter the name of your role model (optional)")
                    .foregroundColor(.secondary)
                
                TextField("Role model's name", text: $roleModel)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
}
