//
//  OnboardingViewModel.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//
import SwiftUI

@available(iOS 17, *)
class OnboardingViewModel: ObservableObject {
    @Published var currentStep = 0
    @Published var name = ""
    @Published var selectedTraits: Set<String> = []
    @Published var roleModel = ""
    @Published var coach: Coach?
    @Published var availableTraits: [String] = []
    @Published var error: Error?
    
    init() {
        loadTraits()
    }
    
    //Computed property to check if required fields are filled
    var isRequiredFieldsFilled: Bool {
        !name.isEmpty && !selectedTraits.isEmpty && coach != nil
    }
    
    private func loadTraits() {
        do {
            //Load advice data to extract traits
            guard let path = Bundle.main.path(forResource: "advice", ofType: "csv") else {
                throw GoalAdvisorError.fileNotFound("advice.csv")
            }
            
            let content = try String(contentsOfFile: path, encoding: .utf8)
            let rows = content.components(separatedBy: .newlines)
                .filter { !$0.isEmpty }
                .dropFirst()
            
            //Extract unique single-word traits (labels) from advice
            let traits = rows.compactMap { row -> String? in
                let columns = row.components(separatedBy: ",")
                guard !columns.isEmpty else { return nil }
                let trait = columns[0].trimmingCharacters(in: .whitespacesAndNewlines)
                // Only include non-empty traits that are single words (no spaces)
                return !trait.isEmpty && trait.components(separatedBy: .whitespaces).count == 1 ? trait : nil
            }
            
            //Remove duplicates and sort
            availableTraits = Array(Set(traits)).sorted()
            
        } catch {
            self.error = error
            print("Error loading traits: \(error)")
        }
    }
    
    var canProceed: Bool {
        switch currentStep {
        case 0:
            return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 1:
            return !selectedTraits.isEmpty
        case 2:
            return true //Role model is optional
        case 3:
            return coach != nil
        default:
            return false
        }
    }
    
    func onTraitsSelected() {
        updateCoach()
    }
    
    func updateCoach() {
        if !selectedTraits.isEmpty {
            let archetype = CoachArchetype.bestMatchForTraits(Set(selectedTraits))
            coach = Coach(
                name: "Coach \(archetype.rawValue)",
                archetype: archetype,
                traits: Set(selectedTraits),
                personality: archetype.description,
                speakingStyle: archetype.speakingStyle
            )
        }
    }
}
