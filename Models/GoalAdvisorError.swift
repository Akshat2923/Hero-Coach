//
//  GoalAdvisorErro.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//


import Foundation
//remove if not using
enum GoalAdvisorError: LocalizedError {
    case fileNotFound(String)
    case parsingError(String)
    case predictionError(String)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let filename):
            return "Could not find file: \(filename)"
        case .parsingError(let details):
            return "Error parsing data: \(details)"
        case .predictionError(let details):
            return "Error making prediction: \(details)"
        }
    }
}
