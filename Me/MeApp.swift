//
//  MeApp.swift
//  Me
//
//  Created by Artem on 17.02.2024.
//

import SwiftUI
import SwiftData
import TabularData
import HealthKit
import OSLog

@main
struct MeApp: App {
    private var healthStore: HKHealthStore?
    private let logger = Logger(subsystem: "Me", category: "MeApp")
    let csv: CsvHelpers
        
    
    
    init() {
        csv = CsvHelpers(fileManager: FileManager.default, modelContext: sharedModelContainer.mainContext)
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            requestHealthkitPermissions()
        } else {
            logger.critical("This app requires a device that supports HealthKit")
        }
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Feature.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    
    private func requestHealthkitPermissions() {
        
        
        let sampleTypesToRead = Set([
            HKObjectType.electrocardiogramType(),
            HKObjectType.categoryType(forIdentifier: .mindfulSession)!,
            HKObjectType.categoryType(forIdentifier: .sexualActivity)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .bodyTemperature)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
        ])
        
        healthStore?.requestAuthorization(toShare: nil, read: sampleTypesToRead) { (success, error) in
            if let error = error {
                logger.error("requestAuthorization error: \(error.localizedDescription)")
            } else if success == false {
                logger.error("requestAuthorization not successful")
            } else {
                logger.notice("requestAuthorization success")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(csvHelpers: csv)
                .modelContainer(sharedModelContainer)
                
            if let healthStore = healthStore {
//                FeaturesChartView(viewModel: FeatureExtractorModel())
//                    .environmentObject(healthStore)
            } else {
//                FeaturesChartView(viewModel: FeatureExtractorModel())
            }

        }
        
    }
}

extension HKHealthStore: ObservableObject{}
