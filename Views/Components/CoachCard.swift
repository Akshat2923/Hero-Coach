//
//  CoachCard.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//
import SwiftUI

@available(iOS 17, *)
struct CoachCard: View {
    let coach: Coach
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Coach")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    Text("Coach \(coach.name)")
                        .font(.title3)
                        .bold()
                    
                    Text("Specializes in: \(coach.traits.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(10)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
