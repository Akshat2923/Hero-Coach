//
//  User.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//


import Foundation
import SwiftData

@available(iOS 17, *)
@Model
final class User {
    // MARK: - Properties
    @Attribute(.unique) var id: UUID
    
    //relationships
    var goals: [Goal] = []
    var coach: Coach
    var heroJourney: HeroJourney?
    
    //user attributes
    var name: String
    var traits: Set<String>
    var roleModel: String
    
    // MARK: - Initialization
    init(id: UUID = UUID(), name: String, traits: Set<String>, roleModel: String, coach: Coach) {
        self.id = id
        self.goals = []
        self.name = name
        self.traits = traits
        self.roleModel = roleModel
        self.coach = coach
        self.heroJourney = HeroJourney()
    }
}
