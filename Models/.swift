import SwiftData

enum DataMigrationPlan: SchemaMigrationPlan {
    @available(iOS 17, *)
    static var schemas: [VersionedSchema.Type] = [
        SchemaV1.self,
        SchemaV2.self
    ]
    
    static var stages: [MigrationStage] = [
        MigrationStage.custom(
            fromVersion: "1",
            toVersion: "2",
            willMigrate: { context in
                // Perform any necessary data transformations before migration
            },
            didMigrate: { context in
                // Initialize new properties after migration
                try? context.save()
            }
        )
    ]
}

// Original Schema
enum SchemaV1: VersionedSchema {
    static var versionIdentifier = "1"
    static var models: [any PersistentModel.Type] = [
        User.self,
        Goal.self,
        Coach.self,
        HeroJourney.self,
        MiniGoal.self,
        Reflection.self
    ]
}

// Updated Schema with level property
enum SchemaV2: VersionedSchema {
    static var versionIdentifier = "2"
    static var models: [any PersistentModel.Type] = [
        User.self,
        Goal.self,
        Coach.self,
        HeroJourney.self,
        MiniGoal.self,
        Reflection.self
    ]
}
