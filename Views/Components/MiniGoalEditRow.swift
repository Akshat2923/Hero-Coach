//
//  MiniGoalEditRow.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/17/25.
//
import SwiftUI

@available(iOS 17, *)
struct MiniGoalEditRow: View {
    @Binding var title: String
    @Binding var dueDate: Date
    var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Mini goal title", text: $title)
            
            DatePicker(
                "Due date",
                selection: $dueDate,
                displayedComponents: .date
            )
        }
        .padding(.vertical, 4)
    }
}
