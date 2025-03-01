//
//  Goal.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//


import Foundation
import SwiftData

@available(iOS 17, *)
@Model
final class MiniGoal: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var dueDate: Date
    var isCompleted: Bool
    var completedDate: Date?
    var goal: Goal?
    
    init(id: UUID = UUID(), title: String, dueDate: Date, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }
}

@available(iOS 17, *)
@Model
final class Goal: Identifiable {
    // MARK: - Properties
    @Attribute(.unique) var id: UUID
    var title: String
    var label: String
    var miniGoals: [MiniGoal] = []
    var completedDate: Date?
    var reflection: String?
    var advice: String
    var createdAt: Date
    var user: User?
    var imagesData: [Data] = [] //accept an array for multi select
    var isPinned: Bool = false
    
    init(id: UUID = UUID(), title: String, label: String, advice: String, createdAt: Date = Date(), imagesData: [Data] = []) {
        self.id = id
        self.title = title
        self.label = label
        self.advice = advice
        self.createdAt = createdAt
        self.miniGoals = []
        self.imagesData = imagesData
    }
    
    var isCompleted: Bool {
        guard !miniGoals.isEmpty else { return false }
        return miniGoals.allSatisfy { $0.isCompleted }
    }
}
