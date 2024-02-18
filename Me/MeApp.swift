//
//  MeApp.swift
//  Me
//
//  Created by Artem on 17.02.2024.
//

import SwiftUI
import SwiftData
import TabularData

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

    init() {
        do {
            let csvFile = Bundle.main.url(forResource: "MarsHabitats", withExtension: "csv")!
            let dataFrame = try DataFrame(contentsOfCSVFile: csvFile)

            let regressorColumns = ["price", "solarPanels", "greenhouses", "size", "mood"]
            let df = dataFrame[regressorColumns]
            print(df)


            let regressors = Regressors()
            try regressors.train(df: df, l1Penalty: 1)


            var results = try House.FeatureEnum.allCases.map {
                try Predictor.adjust(regr: regressors.linearRegressor!,
                           df: df,
                           maxCount: 400,
                           featureName: $0.description)
            }

            Helpers.printError(from: results)
        } catch {
            print(error)
        }



        // туду вычислять разницу для мах ошибки и для мсе
            // забилдить на телефоне
        // интерфейс чтобы можно было добавлять новое значение и смотреть как меняется важность фичей

    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
