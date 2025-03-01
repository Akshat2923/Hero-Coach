//
//  HeroJourney.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/17/25.
//


import SwiftUI
import SwiftData

@available(iOS 17, *)
@Model
final class HeroJourney {
    // MARK: - Properties
    @Attribute(.unique) var id: UUID
    var completedGoalsCount: Int
    var currentRank: HeroRank
    var level: Int
    var createdAt: Date
    var reflections: [Reflection] = []
    
    // MARK: - Initialization
    init(id: UUID = UUID(), completedGoalsCount: Int = 0, createdAt: Date = Date()) {
        self.id = id
        self.completedGoalsCount = completedGoalsCount
        self.currentRank = .rookie
        self.level = 0
        self.createdAt = createdAt
        self.reflections = []
    }
    
    // MARK: - Methods
    func updateRank() {
        //completed goals = level num
        level = completedGoalsCount
        
        let newRank: HeroRank
        switch level {
        case 0...4:
            newRank = .rookie
        case 5...9:
            newRank = .guardian
        default:
            newRank = .hero
        }
        
        if newRank != currentRank {
            currentRank = newRank
        }
    }
}

// MARK: - Hero Rank Enum
@frozen
enum HeroRank: String, Codable, Sendable {
    case rookie = "Rookie"
    case guardian = "Guardian"
    case hero = "Hero"
    
    static let allRanks: [HeroRank] = [.rookie, .guardian, .hero]
    
    var index: Int {
        switch self {
        case .rookie: return 0
        case .guardian: return 1
        case .hero: return 2
        }
    }
    
    var requiredGoals: Int {
        switch self {
        case .rookie: return 0
        case .guardian: return 5
        case .hero: return 10
        }
    }
    
    var description: String {
        switch self {
        case .rookie:
            return "Beginning your journey to become a hero"
        case .guardian:
            return "Protecting and guiding others on their path"
        case .hero:
            return "A true champion of personal growth"
        }
    }
}
