//
//  CoachAdviceView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/23/25.
//
import SwiftUI

@available(iOS 17, *)
struct CoachAdviceView: View {
    @EnvironmentObject var appState: AppState
    let goal: Goal
    
    var body: some View {
        if let user = appState.user {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .background(getGradientForLabel(goal.label))
                        .clipShape(Circle())
                    
                    Text("\(user.coach.name)’s Advice")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.primary)
                }
                
                Text(goal.advice)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                    .cornerRadius(12)
                    .shadow(radius: 2)
            }
            .background(.ultraThinMaterial)
            .padding(.horizontal)
        }
    }
}
