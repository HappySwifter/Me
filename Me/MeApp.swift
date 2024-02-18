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
    var featuresImportance = [Mse]()
    
    
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

    init() {
        do {
            let csvFile = Bundle.main.url(forResource: "MarsHabitats", withExtension: "csv")!
            let columns = ["price", "solarPanels", "greenhouses", "size", "mood"]
            let dataFrame = try DataFrame(contentsOfCSVFile: csvFile, columns: columns)
            
            let regressor = try Regressors.trainLinearRegressor(dataFrame: dataFrame,
                                                                l1Penalty: 0.5)
            
            let params = EvalParameters(maxRowsCount: dataFrame.rows.count,
                                        normalized: true,
                                        percentValue: true)
            featuresImportance.removeAll()
            try House.FeatureEnum.allCases.forEach {
                let result = try Predictor.getFeatureImportance(
                    dataFrame: dataFrame,
                    featureName: $0.description,
                    regressor: regressor,
                    parameters: params)
                
                featuresImportance.append(result)
            }
        } catch {
            print(error)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            FeaturesChartView(data: featuresImportance)
        }
        .modelContainer(sharedModelContainer)
    }
}
