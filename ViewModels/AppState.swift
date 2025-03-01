//
//  AppState.swift
//  Hero Coach
//
//  Created by Akshat  Saladi on 2/12/25.
//
import SwiftUI
import SwiftData

@available(iOS 17, *)
@MainActor
class AppState: ObservableObject {
    @Published var modelContext: ModelContext
    @Published var user: User?
    @Published var selectedTab: Int = 0
    @Published var showingAddGoal: Bool = false
    @Published var selectedLabelGradient: LabelGradient?
    
    init(modelContainer: ModelContainer) {
        self.modelContext = modelContainer.mainContext
        
        //fetch existing user
        let descriptor = FetchDescriptor<User>()
        if let existingUser = try? modelContext.fetch(descriptor).first {
            print("existing user: \(existingUser.name)")
            self.user = existingUser
        } else {
            print("no existing user found")
        }
    }
    
    func saveUser(_ newUser: User) {
        //if there's an existing user, update it
        if let existingUser = user {
            existingUser.name = newUser.name
            existingUser.traits = newUser.traits
            existingUser.roleModel = newUser.roleModel
            
            //Update coach relationship
            if existingUser.coach !== newUser.coach {
                existingUser.coach.user = nil
                existingUser.coach = newUser.coach
                newUser.coach.user = existingUser
            }
        } else {
            //insert new user and set up relationships
            user = newUser
            newUser.coach.user = newUser
            modelContext.insert(newUser)
            modelContext.insert(newUser.coach)
        }
        
        do {
            try modelContext.save()
            print("Successfully saved user: \(newUser.name)")
        } catch {
            print("Failed to save user: \(error)")
        }
    }
    
    func addGoal(_ goal: Goal) {
        guard let user = user else {
            return
        }
        
        goal.user = user
        user.goals.append(goal)
        
        //Insert and save
        modelContext.insert(goal)
        do {
            try modelContext.save()
            print("Successfully saved goal: \(goal.title)")
        } catch {
            print("Failed to save goal: \(error)")
        }
    }
    
    func deleteGoal(at offsets: IndexSet) {
        guard let user = user else {
            return
        }
        
        for index in offsets {
            let goal = user.goals[index]
            modelContext.delete(goal)
        }
        
        user.goals.remove(atOffsets: offsets)
        try? modelContext.save()
    }
    
    func deleteGoal(withId id: UUID) {
        guard let user = user,
              let index = user.goals.firstIndex(where: { $0.id == id }) else { return }
        let goal = user.goals[index]
        user.goals.remove(at: index)
        modelContext.delete(goal)
        
        do {
            try modelContext.save()
            print("Successfully deleted goal: \(id)")
        } catch {
            print("Failed to delete goal: \(error)")
        }
    }
    func togglePinGoal(withId id: UUID) {
        if let index = user?.goals.firstIndex(where: { $0.id == id }) {
            user?.goals[index].isPinned.toggle()
        }
    }
    
    let advisor = GoalAdvisorViewModel()
    
    //wipe user data
    func startOver() {
        guard let user = user else { return }
        
        self.user = nil
        selectedTab = 0
        
        do {
            for goal in user.goals {
                modelContext.delete(goal)
            }
            
            modelContext.delete(user.coach)
            
            modelContext.delete(user)
            
            try modelContext.save()
            print("Successfully cleared all user data")
        } catch {
            print("Failed to clear user data: \(error)")
        }
    }
}
