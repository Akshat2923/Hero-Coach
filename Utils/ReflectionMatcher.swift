//
//  ReflectionMatcher.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/17/25.
//


import Foundation
import NaturalLanguage

@available(iOS 17, *)
struct ReflectionMatch {
    let reflection: Reflection
    let score: Double
}

class ReflectionMatcher {
    @available(iOS 17, *)
    static func findBestMatch(for goal: Goal, in reflections: [Reflection]) -> ReflectionMatch? {
        guard !reflections.isEmpty else { return nil }
        
        let embedder = NLEmbedding.wordEmbedding(for: .english)
        
        func calculateSimilarity(_ text1: String, _ text2: String) -> Double {
            let words1 = text1.lowercased().components(separatedBy: .whitespacesAndNewlines)
            let words2 = text2.lowercased().components(separatedBy: .whitespacesAndNewlines)
            
            var totalSimilarity = 0.0
            var comparisonCount = 0
            
            for word1 in words1 {
                for word2 in words2 {
                    if let similarity = embedder?.distance(between: word1, and: word2) {
                        totalSimilarity += similarity
                        comparisonCount += 1
                    }
                }
            }
            
            return comparisonCount > 0 ? totalSimilarity / Double(comparisonCount) : 0
        }
        
        //uses title and label for matching
        let goalText = [goal.title, goal.label].joined(separator: " ")
        
        let matches = reflections.map { reflection in
            let reflectionText = [reflection.goalTitle, reflection.content].joined(separator: " ")
            let similarity = calculateSimilarity(goalText, reflectionText)
            return ReflectionMatch(reflection: reflection, score: similarity)
        }
        
        return matches.max(by: { $0.score < $1.score })
    }
}
