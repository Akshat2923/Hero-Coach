//
//  AddGoalWithTypingViewModel.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/19/25.
//


import Foundation

class AddGoalWithTypingViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var goals: [(label: String, mainGoal: String, miniGoals: [(title: String, dueDate: Date?)])] = []
    @Published var error: Error?
    @Published var isLoading = false
    
    func processInput() {
        isLoading = true
        error = nil
        print("input Text: \(inputText)")
        
        do {
            //Extract multiple goals from the input text
            let extractedGoals = try GoalExtractor.extractMultipleGoals(from: inputText)
            
            goals = extractedGoals
        } catch {
            self.error = error
            print("Error extracting goals: \(error)")
        }
        
        isLoading = false
    }
}
