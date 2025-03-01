//
//  AIButton.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/20/25.
//
import SwiftUI

struct AIButton: View {
    var title: String
    var action: () -> Void
    var width: CGFloat = 200
    var height: CGFloat = 50
    
    var body: some View {
        Button(action: action) {
            if #available(iOS 18.0, *) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: width, height: height)
                    .background(
                        ZStack {
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
                            .cornerRadius(30)
                            
                            
                        }
                    )
                    .overlay(
                        Text(title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.6), radius: 1, x: 0, y: 0)
                    )
                    .cornerRadius(30)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
            } else {
                
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
