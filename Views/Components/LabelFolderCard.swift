//
//  LabelFolderCard.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/19/25.
//
import SwiftUI

struct LabelFolderCard: View {
    let label: String
    let count: Int
    let icon: String
    let gradient: LinearGradient

    var body: some View {
        VStack(spacing: 10) {
            Text(icon)
                .font(.system(size: 40))
            Text(label)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            Text("\(count) goals")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 140) 
        .background(gradient)
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}
