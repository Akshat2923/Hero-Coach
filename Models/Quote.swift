//
//  Quote.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//

import Foundation

struct Quote: Identifiable {
    let id = UUID()
    let text: String
    let author: String
    let labels: [String]
}
