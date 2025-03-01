//
//  LoadingView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/19/25.
//
import SwiftUI

@available(iOS 17, *)
struct LoadingView: View {
    var body: some View {
        VStack {
            Text("Loading...")
                .font(.largeTitle)
                .padding()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
