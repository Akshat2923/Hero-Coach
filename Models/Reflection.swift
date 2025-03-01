//
//  Reflection.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/17/25.
//


import SwiftUI
import SwiftData

@available(iOS 17, *)
@Model
final class Reflection {
    // MARK: - Properties
    @Attribute(.unique) var id: UUID
    var content: String
    var goalTitle: String
    var createdAt: Date
    var heroJourney: HeroJourney?
    
    // MARK: - Initialization
    init(id: UUID = UUID(), goalTitle: String, content: String, createdAt: Date = Date()) {
        self.id = id
        self.goalTitle = goalTitle
        self.content = content
        self.createdAt = createdAt
    }
}
