//
//  AddGoalView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//
import SwiftUI
import SwiftData
import PhotosUI

@available(iOS 17, *)
struct AddGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel: AddGoalViewModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var imagesData: [Data] = []
    let onComplete: (Goal?) -> Void
    
    init(advisor: GoalAdvisorViewModel, onComplete: @escaping (Goal?) -> Void) {
        _viewModel = StateObject(wrappedValue: AddGoalViewModel(advisor: advisor))
        self.onComplete = onComplete
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    Text("Upload Images (Optional)")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.bottom)
                    PhotoUploadView(imagesData: $imagesData) {}
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(.top, 20)
                
                Form {
                    Section {
                        TextField("What's your goal?", text: $viewModel.goalText)
                            .textFieldStyle(.automatic)
                            .focused($isTextFieldFocused)
                    } footer: {
                        Text("Create a new goal then press Create!")
                            .foregroundColor(.secondary)
                    }
                    
                    if viewModel.isLoading {
                        Section {
                            HStack {
                                Spacer()
                                ProgressView("Analyzing your goal...")
                                Spacer()
                            }
                        }
                    }
                    
                    if viewModel.error != nil {
                        Section {
                            Text(viewModel.error?.localizedDescription ?? "Unknown error")
                                .foregroundColor(.red)
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Add New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isTextFieldFocused = true
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onComplete(nil)
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        Task {
                            viewModel.imagesData = imagesData
                            await viewModel.analyzeAndAddGoal()
                            if viewModel.error == nil {
                                if let goal = viewModel.createdGoal {
                                    onComplete(goal)
                                }
                                dismiss()
                            }
                        }
                    }) {
                        Text("Create")
                            .font(.headline)
                    }
                    .disabled(
                        viewModel.goalText.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty || viewModel.isLoading
                    )
                }
            }
        }
    }
}
