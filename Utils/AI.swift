//
//  AI.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/20/25.
//


import SwiftUI

// MARK: - Color Extension
extension Color {
    struct AI {
        static let mandy = Color(hex: 0xED5A77)
        static let ecstasy = Color(hex: 0xFB861E)
        static let silverSand = Color(hex: 0xC5C8CC)
        static let mediumPurple = Color(hex: 0x967BE3)
        static let cornflowerBlue = Color(hex: 0x4999F5)
        static let tonysPink = Color(hex: 0xE79B8B)
        static let redRibbon = Color(hex: 0xFB105A)
        static let fuchsiaPink = Color(hex: 0xBF6FB6)
        static let wisteria = Color(hex: 0xA176C2)
        static let danube = Color(hex: 0x6494C4)
    }
    
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

//global func to get the gradient based on the goal's label
func getGradientForLabel(_ label: String) -> LinearGradient {
    let labelData: [String: (icon: String, colorIndex: Int)] = [
        "Personal Growth": ("📈", 0),
        "Humor": ("😂", 1),
        "Health & Fitness": ("💪", 2),
        "Recreation & Leisure": ("🎮", 3),
        "Family/Friends/Relationships": ("❤️", 4),
        "Finance": ("💰", 5),
        "Career": ("🚀", 6),
        "Education/Training": ("📚", 7),
        "Time Management/Organization": ("⏳", 8),
        "Philanthropic": ("🌍", 9)
    ]
    
    if let data = labelData[label] {
        let index = data.colorIndex
        let colors = colorPairForIndex(index)
        return LinearGradient(gradient: Gradient(colors: [colors.0, colors.1]), startPoint: .topLeading, endPoint: .bottomTrailing)
    } else {
        return LinearGradient(gradient: Gradient(colors: [Color.gray, Color.gray]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

//get color pairs based on index
func colorPairForIndex(_ index: Int) -> (Color, Color) {
    let pairs: [(Color, Color)] = [
        (Color.AI.mandy, Color.AI.redRibbon),
        (Color.AI.cornflowerBlue, Color.AI.danube),
        (Color.AI.mediumPurple, Color.AI.wisteria),
        (Color.AI.ecstasy, Color.AI.tonysPink),
        (Color.AI.fuchsiaPink, Color.AI.wisteria),
        (Color.AI.mandy, Color.AI.ecstasy),
        (Color.AI.cornflowerBlue, Color.AI.wisteria),
        (Color.AI.redRibbon, Color.AI.tonysPink),
        (Color.AI.fuchsiaPink, Color.AI.cornflowerBlue),
        (Color.AI.mediumPurple, Color.AI.redRibbon)
    ]
    return pairs[index % pairs.count]
}

// TODO: - use this instead of copy paste meshgradient
@available(iOS 18.0, *)
func pinnedMeshGradient() -> MeshGradient {
    return MeshGradient(
        width: 3,
        height: 3,
        points: [
            [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
            [0.0, 0.5], [0.6, 0.4], [1.0, 0.5],
            [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
        ],
        colors: [
            Color.AI.mandy, Color.AI.redRibbon, Color.AI.ecstasy,
            Color.AI.tonysPink, Color.AI.mediumPurple, Color.AI.fuchsiaPink,
            Color.AI.wisteria, Color.AI.cornflowerBlue, Color.AI.danube
        ]
    )
}
