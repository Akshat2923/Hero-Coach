//
//  Coach.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/10/25.
//


import Foundation
import SwiftData

@available(iOS 17, *)
@Model
final class Coach: Identifiable {
    // MARK: - Properties
    @Attribute(.unique) var id: UUID
    
    //relationships
    var user: User?
    
    //coach attributes
    var name: String
    var archetype: CoachArchetype
    var traits: Set<String>
    var personality: String
    var speakingStyle: String
    
    init(id: UUID = UUID(), name: String, archetype: CoachArchetype, traits: Set<String>, personality: String, speakingStyle: String) {
        self.id = id
        self.name = name
        self.archetype = archetype
        self.traits = traits
        self.personality = personality
        self.speakingStyle = speakingStyle
    }
    
    static var empty: Coach {
        Coach(name: "",
              archetype: .mentor,
              traits: [],
              personality: "",
              speakingStyle: "")
    }
}

enum CoachArchetype: String, Codable, CaseIterable {
    case mentor = "The Wise Mentor"
    case challenger = "The Challenger"
    case motivator = "The Motivator"
    case nurturer = "The Nurturer"
    case strategist = "The Strategist"
    case innovator = "The Innovator"
    
    var description: String {
        switch self {
        case .mentor:
            return "A wise and experienced guide who combines deep knowledge with patient understanding."
        case .challenger:
            return "A dynamic force who pushes you to exceed your own expectations and break through barriers."
        case .motivator:
            return "An energetic enthusiast who inspires you to take action and stay positive."
        case .nurturer:
            return "A supportive presence who helps you grow while maintaining balance and well-being."
        case .strategist:
            return "A analytical thinker who helps you plan and execute your goals effectively."
        case .innovator:
            return "A creative force who helps you think outside the box and find unique solutions."
        }
    }
    
    var speakingStyle: String {
        switch self {
        case .mentor:
            return "speaks with wisdom and uses thought-provoking questions"
        case .challenger:
            return "uses direct, action-oriented language and challenging questions"
        case .motivator:
            return "speaks with enthusiasm and energy, using positive reinforcement"
        case .nurturer:
            return "uses gentle, supportive language and emphasizes personal growth"
        case .strategist:
            return "communicates clearly and logically, focusing on practical steps"
        case .innovator:
            return "speaks creatively and encourages exploring new perspectives"
        }
    }
    
    //maps traits to likely archetypes
    static func bestMatchForTraits(_ traits: Set<String>) -> CoachArchetype {
        var scores: [CoachArchetype: Int] = [:]
        
        // Initialize scores
        for archetype in CoachArchetype.allCases {
            scores[archetype] = 0
        }
        
        // Score each trait
        for trait in traits {
            switch trait.lowercased() {
            case "wisdom", "listening", "peace", "empathy":
                scores[.mentor, default: 0] += 2
                scores[.nurturer, default: 0] += 1
                
            case "grit", "hard work", "drive", "confidence":
                scores[.challenger, default: 0] += 2
                scores[.motivator, default: 0] += 1
                
            case "motivation", "optimism", "hope", "believe":
                scores[.motivator, default: 0] += 2
                scores[.challenger, default: 0] += 1
                
            case "kindness", "caring", "self-care", "gratitude":
                scores[.nurturer, default: 0] += 2
                scores[.mentor, default: 0] += 1
                
            case "leadership", "teamwork", "strategy":
                scores[.strategist, default: 0] += 2
                scores[.challenger, default: 0] += 1
                
            case "creativity", "curiosity", "innovation":
                scores[.innovator, default: 0] += 2
                scores[.strategist, default: 0] += 1
                
            default:
                // For unmatched traits, distribute points evenly
                for archetype in CoachArchetype.allCases {
                    scores[archetype, default: 0] += 1
                }
            }
        }
        
        //returns the archetype with the highest score
        return scores.max(by: { $0.value < $1.value })?.key ?? .mentor
    }
    
    func generateResponse(for goal: String) -> String {
        switch self {
        case .mentor:
            return "I see wisdom in your goal to \(goal). Let's explore this path together and understand its deeper meaning."
        case .challenger:
            return "That's an interesting goal - to \(goal). Are you ready to push your limits and make it happen?"
        case .motivator:
            return "I love your ambition to \(goal)! Together, we'll turn this goal into reality with passion and determination!"
        case .nurturer:
            return "Your goal to \(goal) is a wonderful step in your personal journey. Let's nurture this aspiration together."
        case .strategist:
            return "Your goal to \(goal) is clear. Let's break this down into actionable steps and create a winning strategy."
        case .innovator:
            return "What an interesting goal - to \(goal)! Let's think creatively about unique ways to achieve this."
        }
    }
}
