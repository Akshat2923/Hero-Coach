import SwiftUI
import SwiftData
import AppIntents

@available(iOS 17, *)
@main
struct MyApp: App {
    private let container: ModelContainer
    @StateObject private var appState: AppState
    @State private var isLoading = false
    
    init() {
        //configure swiftdata
        let schema = Schema([
            User.self,
            Goal.self,
            Coach.self,
            HeroJourney.self,
            MiniGoal.self,
            Reflection.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema
        )
        
        //create container init
        do {
            let container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            print("uccessfully initialized SwiftData container")
            // Set container and create AppState
            self.container = container
            let appState = AppState(modelContainer: container)
            self._appState = StateObject(wrappedValue: appState)
        } catch {
            print("Failed to initialize SwiftData: \(error)")
            fatalError("Cannot proceed without SwiftData container")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isLoading {
                    LoadingView()
                } else if appState.user != nil {
                    MainView()
                } else {
                    OnboardingView(isLoading: $isLoading)
                }
            }
            .environmentObject(appState)
        }
        .modelContainer(container)
    }
}
