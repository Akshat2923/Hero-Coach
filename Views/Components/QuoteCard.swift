//
//  QuoteCard.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//
import SwiftUI

struct QuoteCard: View {
    let quote: Quote

    var body: some View {
        if #available(iOS 18.0, *) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Daily Inspiration")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .shadow(color: .black.opacity(0.6), radius: 1, x: 0, y: 0)
                
                Text("\"\(quote.text)\"")
                    .font(.body)
                    .italic()
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .shadow(color: .black.opacity(0.6), radius: 1, x: 0, y: 0)
                
                HStack {
                    Text("— \(quote.author)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .fontWeight(.bold)
                        .shadow(color: .black.opacity(0.6), radius: 1, x: 0, y: 0)
                    Spacer()
                }
            }
            .padding()
            .background(
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
            .cornerRadius(12)
        } else {
            // Fallback on earlier versions
        }
    }
}
