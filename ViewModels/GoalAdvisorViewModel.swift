//
//  GoalAdvisorViewModel.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//
import SwiftUI
import CoreML
import NaturalLanguage

@available(iOS 17, *)
@MainActor
class GoalAdvisorViewModel: ObservableObject {
    @Published var userInput = ""
    @Published var roleModel = ""
    @Published var selectedLabels: Set<String> = []
    @Published var predictedLabel = ""
    @Published var matchedAdvice: [Advice] = []
    @Published var matchedQuote: Quote?
    @Published var isLoading = false
    @Published var error: GoalAdvisorError?
    @Published var availableLabels: [String] = []
    @Published var coach: Coach?
    
    private var advice: [Advice] = []
    private var quotes: [Quote] = []
    
    init() {
        loadData()
    }
    
    private func loadData() {
        do {
            try loadAdviceData()
            try loadQuotesData()
            
            let uniqueLabels = Set(advice.map { $0.label })
            availableLabels = Array(uniqueLabels).sorted()
        } catch {
            createTestData()
            print("Using test data: \(error.localizedDescription)")
        }
    }
    
    private func loadAdviceData() throws {
        guard let path = Bundle.main.path(forResource: "advice", ofType: "csv") else {
            throw GoalAdvisorError.fileNotFound("advice.csv")
        }
        
        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            let rows = content.components(separatedBy: .newlines)
                .filter { !$0.isEmpty }
                .dropFirst()
            
            advice = rows.compactMap { row in
                var columns: [String] = []
                var currentField = ""
                var insideQuotes = false
                
                for char in row {
                    switch char {
                    case "\"":
                        insideQuotes.toggle()
                    case ",":
                        if !insideQuotes {
                            columns.append(currentField.trimmingCharacters(in: .whitespacesAndNewlines))
                            currentField = ""
                        } else {
                            currentField.append(char)
                        }
                    default:
                        currentField.append(char)
                    }
                }
                columns.append(currentField.trimmingCharacters(in: .whitespacesAndNewlines))
                
                guard columns.count >= 2 else { return nil }
                
                return Advice(
                    label: columns[0].trimmingCharacters(in: .whitespacesAndNewlines),
                    text: columns[1].replacingOccurrences(of: "\"", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                )
            }
        } catch {
            throw GoalAdvisorError.parsingError(error.localizedDescription)
        }
    }
    
    private func loadQuotesData() throws {
        guard let path = Bundle.main.path(forResource: "quotes", ofType: "csv") else {
            throw GoalAdvisorError.fileNotFound("quotes.csv")
        }
        
        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            let rows = content.components(separatedBy: .newlines)
                .filter { !$0.isEmpty }
                .dropFirst()
            
            quotes = rows.compactMap { row in
                let columns = row.components(separatedBy: ",")
                guard columns.count >= 3 else { return nil }
                
                let labels = columns[2].components(separatedBy: ",").map {
                    $0.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                
                return Quote(
                    text: columns[0].replacingOccurrences(of: "\"", with: "").trimmingCharacters(in: .whitespacesAndNewlines),
                    author: columns[1].trimmingCharacters(in: .whitespacesAndNewlines),
                    labels: labels
                )
            }
        } catch {
            throw GoalAdvisorError.parsingError(error.localizedDescription)
        }
    }
    
    private func createTestData() {
        advice = [
            Advice(label: "LOVE", text: "Let us see what love can do."),
            Advice(label: "LISTENING", text: "Listen with curiosity. Speak with honesty. Act with integrity."),
            Advice(label: "STEWARDSHIP", text: "There are no problems we cannot solve together.")
        ]
        
        quotes = [
            Quote(text: "If you're so afraid of failure, you will never succeed. You have to take chances.",
                  author: "Mario Andretti",
                  labels: ["Failure", "Chance", "Succeed"])
        ]
    }
    
    func analyzeGoal() {
        isLoading = true
        error = nil
        
        //Create or update coach based on selected traits
        if !selectedLabels.isEmpty {
            let archetype = CoachArchetype.bestMatchForTraits(Set(selectedLabels))
            coach = Coach(name: "Coach \(archetype.rawValue)",
                          archetype: archetype,
                          traits: Set(selectedLabels),
                          personality: archetype.description,
                          speakingStyle: archetype.speakingStyle)
        }
        
        //Find matching advice and quotes
        matchedAdvice = findAdviceForLabels(
            goal: userInput,
            predictedLabel: predictedLabel,
            selectedLabels: selectedLabels,
            in: advice
        )
        
        
        isLoading = false
    }
    func updateMatchedQuote() {
        let newQuote = findBestQuoteMatch(goal: userInput, selectedLabels: selectedLabels, roleModel: roleModel)
        
        //Only update if the quote is actually changing
        if newQuote?.text != matchedQuote?.text {
            matchedQuote = newQuote
            print("Found new quote: '\(newQuote?.text ?? "None")'")
        } else {
            print("Same quote detected, skipping update")
        }
    }
    func getAdvice(for label: String) async -> String {
        print("\n=== Finding Advice for Goal ===")
        print("Selected Traits: \(selectedLabels)")
        
        guard let embedding = NLEmbedding.wordEmbedding(for: .english) else {
            print("Failed to load word embedding, falling back to trait-based advice")
            return fallbackAdvice(for: label)
        }
        
        //Split compound labels like "Health & Fitness" into individual words
        let labelWords = label.components(separatedBy: CharacterSet(charactersIn: " &,"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        print("Looking for advice matching words: \(labelWords)")
        
        var bestAdvice: [(Advice, Double)] = []
        
        for item in advice {
            let itemWords = item.label.components(separatedBy: CharacterSet(charactersIn: " &,"))
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            
            var totalSimilarity = 0.0
            var matchCount = 0
            
            for labelWord in labelWords {
                var bestWordSimilarity = 0.0
                for itemWord in itemWords {
                    let similarity = embedding.distance(between: labelWord.lowercased(),
                                                        and: itemWord.lowercased())
                    bestWordSimilarity = max(bestWordSimilarity, similarity)
                }
                if bestWordSimilarity > 0.6 { //Good semantic match threshold
                    totalSimilarity += bestWordSimilarity
                    matchCount += 1
                    print("Found good match: '\(labelWord)' matches '\(itemWords)' with score \(bestWordSimilarity)")
                }
            }
            
            //Only consider advice if we have a good match
            if matchCount > 0 {
                let averageSimilarity = totalSimilarity / Double(labelWords.count)
                if averageSimilarity > 0.3 { //Overall match threshold
                    bestAdvice.append((item, averageSimilarity))
                    print("Found potential advice from '\(item.label)' with overall score \(averageSimilarity)")
                }
            }
        }
        
        //Sort by similarity and get top matches
        bestAdvice.sort { $0.1 > $1.1 }
        
        //If we found good matches, return a random one from the top 3
        if !bestAdvice.isEmpty {
            print("\nFound \(bestAdvice.count) matching pieces of advice")
            let topMatches = Array(bestAdvice.prefix(3))
            print("Top 3 matching labels: \(topMatches.map { $0.0.label })")
            let selectedAdvice = topMatches.randomElement()?.0.text ?? fallbackAdvice(for: label)
            print("Selected advice: \(selectedAdvice)")
            print("=== End Finding Advice ===")
            return selectedAdvice
        }
        
        return fallbackAdvice(for: label)
    }
    
    private func fallbackAdvice(for label: String) -> String {
        print("\nNo semantic matches found, falling back to trait-based advice")
        //Use advice matching the selected traits
        let traitAdvice = advice.filter { selectedLabels.contains($0.label) }
        print("Found \(traitAdvice.count) pieces of advice matching selected traits")
        return traitAdvice
            .randomElement()?.text ?? "Break this goal down into smaller, manageable steps. Start with what you can do today."
    }
    
    private func findAdviceForLabels(
        goal: String,
        predictedLabel: String,
        selectedLabels: Set<String>,
        in advice: [Advice]
    ) -> [Advice] {
        guard let embedding = NLEmbedding.wordEmbedding(for: .english) else { return [] }
        
        var selectedAdvice: [Advice] = []
        let goalWords = goal.lowercased().components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        
        for label in selectedLabels {
            let matchingAdvice = advice.filter { $0.label.lowercased() == label.lowercased() }
            guard !matchingAdvice.isEmpty else { continue }
            
            if !goal.isEmpty {
                var scoredAdvice: [(advice: Advice, score: Double)] = []
                
                for item in matchingAdvice {
                    let itemWords = item.text.lowercased().components(
                        separatedBy: .whitespacesAndNewlines
                    ).filter {
                        !$0.isEmpty
                    }
                    var score = 0.0
                    
                    for goalWord in goalWords {
                        if itemWords.contains(goalWord) {
                            score += 1.0
                            continue
                        }
                        
                        var bestWordSimilarity = 0.0
                        for itemWord in itemWords {
                            let similarity = embedding.distance(between: goalWord, and: itemWord)
                            bestWordSimilarity = max(bestWordSimilarity, similarity)
                        }
                        score += bestWordSimilarity
                    }
                    
                    score = score / Double(goalWords.count)
                    if score > 0.2 {
                        scoredAdvice.append((item, score))
                    }
                }
                
                if let bestMatch = scoredAdvice.sorted(by: { $0.score > $1.score }).first?.advice {
                    selectedAdvice.append(bestMatch)
                }
            } else {
                if let randomAdvice = matchingAdvice.randomElement() {
                    selectedAdvice.append(randomAdvice)
                }
            }
        }
        
        return selectedAdvice
    }
    
    func findBestQuoteMatch(goal: String, selectedLabels: Set<String>, roleModel: String) -> Quote? {
        //If role model is provided, try to find their quote first
        if !roleModel.isEmpty {
            let roleModelQuotes = quotes.filter { $0.author.lowercased().contains(roleModel.lowercased()) }
            if let roleModelQuote = roleModelQuotes.randomElement() {
                print("Found quote from role model: '\(roleModelQuote.text)'")
                return roleModelQuote
            }
        }
        
        //Prevent infinite loop if quotes array is empty
        guard !quotes.isEmpty else {
            print("No quotes available!")
            return nil
        }
        
        return quotes.randomElement()
    }
}
