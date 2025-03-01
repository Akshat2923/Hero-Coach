//
//  OnboardingView.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//
import SwiftUI

@available(iOS 17, *)
struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding var isLoading: Bool
    
    var body: some View {
        TabView(selection: $viewModel.currentStep) {
            NavigationStack{
                NameInputView(name: $viewModel.name)
            }
            
            .tag(0)
            
            NavigationStack{
                TraitsSelectionView(selectedTraits: $viewModel.selectedTraits, viewModel: viewModel)
            }
            .tag(1)
            
            NavigationStack{
                RoleModelInputView(roleModel: $viewModel.roleModel)
            }
            .tag(2)
            
            NavigationStack{
                CoachPreviewView(
                    viewModel: viewModel,
                    isLoading: $isLoading,
                    completeOnboarding: completeOnboarding
                )
                
                    .tag(3)
            }
        
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
    
    private func completeOnboarding() {
        guard let coach = viewModel.coach else { return }
        
        let newUser = User(
            name: viewModel.name,
            traits: viewModel.selectedTraits,
            roleModel: viewModel.roleModel,
            coach: coach
        )
        
        appState.saveUser(newUser)
        
        isLoading = false
    }
}
