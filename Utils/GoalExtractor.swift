//
//  GoalExtractor.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/19/25.
//


import NaturalLanguage
import CoreML

class GoalExtractor {
    private static let auxiliaryPhrases = Set([
        "i really wanna", "i wanna", "i want to", "i need to", "i definitely need to",
        "but i do not know where to start", "i do not know where to start", "i gotta", "i should",
        "but i also want to", "i also want to", "but i", "i also"
    ])
    
    //date phrases to detect
    // TODO: - add more if time remaining and test
    private static let datePhrases = [
        "tomorrow": Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
        "next week": Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!,
        "next month": Calendar.current.date(byAdding: .month, value: 1, to: Date())!
    ]
    
    static func extractMultipleGoals(from text: String) throws -> [(label: String, mainGoal: String, miniGoals: [(title: String, dueDate: Date?)])] {
        guard !text.isEmpty else { return [] }
        
        //Preprocess the text
        var processedText = preprocessText(text.lowercased())
        
        //normalize conjunctions and sentence boundaries
        let normalizedText = processedText
            .replacingOccurrences(of: " but ", with: " and ")
            .replacingOccurrences(of: ",", with: " and ")
            .replacingOccurrences(of: ". ", with: " and ")
            .replacingOccurrences(of: ".", with: " and ")
        
        //Clean up extra spaces and get final text
        let cleanedText = normalizedText.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespaces)
            .trimmingCharacters(in: CharacterSet(charactersIn: "and")) // Remove leading/trailing "and"
        print("Cleaned Text: \(cleanedText)") // Debug
        
        //Split into potential goals and capitalize
        let potentialGoals = cleanedText.components(separatedBy: " and ")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .map { $0.capitalized }
        
        print("Potential Goals (capitalized): \(potentialGoals)") // Debug
        
        //Core ML model
        let model = try GoalClassificationModel(configuration: MLModelConfiguration())
        
        //Classify each phrase and build goals based on labels
        var allGoals: [(label: String, mainGoal: String, miniGoals: [(title: String, dueDate: Date?)])] = []
        var currentMainGoal: String = ""
        var currentMiniGoals: [(title: String, dueDate: Date?)] = []
        var previousLabel: String? = nil
        
        for phrase in potentialGoals {
            let input = GoalClassificationModelInput(text: phrase)
            guard let output = try? model.prediction(input: input) else {
                print("Failed to classify: \(phrase)")
                continue
            }
            
            let label = output.label
            print("Phrase: \(phrase), Label: \(label)")
            
            //skip if the label is "none"
            if label == "none" { continue }
            
            //extract date from the phrase if present
            let (cleanedPhrase, dueDate) = extractDate(from: phrase.lowercased())
            
            if previousLabel == nil || label != previousLabel {
                if !currentMainGoal.isEmpty {
                    allGoals.append((label: previousLabel ?? "Main Goal", mainGoal: currentMainGoal, miniGoals: currentMiniGoals))
                    currentMiniGoals = []
                }
                currentMainGoal = cleanedPhrase
            } else {
                currentMiniGoals.append((title: cleanedPhrase, dueDate: dueDate))
            }
            
            previousLabel = label
        }
        
        if !currentMainGoal.isEmpty {
            allGoals.append((label: previousLabel ?? "Main Goal", mainGoal: currentMainGoal, miniGoals: currentMiniGoals))
        }
        
        return allGoals
    }
    
    private static func preprocessText(_ text: String) -> String {
        var processed = text
        processed = processed.replacingOccurrences(of: "wanna", with: "want to")
            .replacingOccurrences(of: "don’t", with: "do not")
            .replacingOccurrences(of: "n't", with: " not")
        
        for phrase in auxiliaryPhrases {
            processed = processed.replacingOccurrences(of: phrase, with: "", options: .caseInsensitive)
        }
        
        return processed.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespaces)
    }
    
    //extract dates from phrases
    private static func extractDate(from phrase: String) -> (String, Date?) {
        var cleanedPhrase = phrase
        var dueDate: Date? = nil
        
        // Check for specific date phrases
        for (datePhrase, date) in datePhrases {
            if cleanedPhrase.contains("by \(datePhrase)") || cleanedPhrase.contains("in \(datePhrase)") {
                cleanedPhrase = cleanedPhrase.replacingOccurrences(of: "by \(datePhrase)", with: "")
                    .replacingOccurrences(of: "in \(datePhrase)", with: "")
                dueDate = date
                break
            }
        }
        
        //"in X days"
        let daysRegex = try! NSRegularExpression(pattern: "in (\\d+) days", options: [])
        if let match = daysRegex.firstMatch(in: phrase, options: [], range: NSRange(phrase.startIndex..., in: phrase)) {
            let daysRange = Range(match.range(at: 1), in: phrase)!
            let days = Int(phrase[daysRange])!
            dueDate = Calendar.current.date(byAdding: .day, value: days, to: Date())!
            cleanedPhrase = cleanedPhrase.replacingOccurrences(of: "in \(days) days", with: "")
        }
        
        return (cleanedPhrase.trimmingCharacters(in: .whitespaces), dueDate)
    }
}
