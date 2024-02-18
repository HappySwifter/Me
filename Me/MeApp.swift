//
//  MeApp.swift
//  Me
//
//  Created by Artem on 17.02.2024.
//

import SwiftUI
import SwiftData
import TabularData
import FeatureExtractor

@main
struct MeApp: App {
    
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    
    var body: some Scene {
        WindowGroup {
            FeaturesChartView(viewModel: FeatureChartViewModel())
        }
        .modelContainer(sharedModelContainer)
    }
}
