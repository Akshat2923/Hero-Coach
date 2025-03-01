//
//  AddGoalViewModel.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/13/25.
//


import SwiftUI
import CoreML

@available(iOS 17, *)
struct GoalPrediction: Sendable {
    let label: String
    
    init(output: GoalClassificationModelOutput) {
        self.label = output.label
    }
}

@available(iOS 17, *)
@MainActor
class AddGoalViewModel: ObservableObject {
    @Published var goalText = ""
    @Published var isLoading = false
    @Published var error: Error?
    @Published var createdGoal: Goal?
    var imagesData: [Data] = []
    
    private let advisor: GoalAdvisorViewModel
    
    init(advisor: GoalAdvisorViewModel) {
        self.advisor = advisor
    }
    
    func analyzeAndAddGoal() async {
        print("\n=== Starting Goal Analysis ===")
        print("Goal Text: \(goalText)")
        isLoading = true
        error = nil
        createdGoal = nil
        
        do {
            let model = try GoalClassificationModel(configuration: MLModelConfiguration())
            let input = GoalClassificationModelInput(text: goalText)
            
            let prediction = try await Task.detached(priority: .userInitiated) { () -> GoalPrediction in
                guard let output = try? model.prediction(input: input) else {
                    print("ML Model prediction failed")
                    throw GoalAdvisorError.predictionError("Failed to analyze goal")
                }
                return GoalPrediction(output: output)
            }.value
            
            print("ML Model predicted label: \(prediction.label)")
            print("\nGetting advice for label: \(prediction.label)")
            
            let advice = await advisor.getAdvice(for: prediction.label)
            print("✅ Got advice: \(advice)")
            
            createdGoal = Goal(
                
                title: goalText,
                label: prediction.label,
                advice: advice,
                createdAt: Date(),
                imagesData: imagesData
            )
            print("\n✅ Goal created successfully!")
            print("=== End Goal Analysis ===")
            
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
}
