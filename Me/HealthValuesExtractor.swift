//
//  HealthValuesExtractor.swift
//  Me
//
//  Created by Artem on 18.02.2024.
//

import Foundation
import SwiftUI
import OSLog
import HealthKit


@Observable
class FeatureChartViewModel {
    var healthStore: HKHealthStore?
    var steps: Double?
    var heartRate: Double?
        
    init(healthStore: HKHealthStore?) {
        self.healthStore = healthStore
    }
        
    func getSteps() async throws {
        guard let healthStore = healthStore else { return }

        let startOfDay = Calendar.current.startOfDay(for: Date())
        let today = HKQuery.predicateForSamples(withStart: startOfDay, end: Date())

        // Create the query descriptor.
        let stepType = HKQuantityType(.stepCount)
        let predicate = HKSamplePredicate.quantitySample(type: stepType, predicate: today)
        let sumOfStepsQuery = HKStatisticsQueryDescriptor(predicate: predicate, options: .cumulativeSum)

        // Run the query.
        self.steps = try await sumOfStepsQuery.result(for: healthStore)?
            .sumQuantity()?
            .doubleValue(for: HKUnit.count())
        print("stepCount", steps)
    }
    
    func getHeartRate() async throws {
        guard let healthStore = healthStore else { return }
        let today = Helpers.getThisDayPredicate()

        // Create the query descriptor.
        let heartRate = HKQuantityType(.heartRate)
        let heartRateToday = HKSamplePredicate.quantitySample(type: heartRate, predicate: today)
        let sumOfStepsQuery = HKStatisticsQueryDescriptor(predicate: heartRateToday, options: .discreteAverage)

        // Run the query.
        self.heartRate = try await sumOfStepsQuery.result(for: healthStore)?
            .sumQuantity()?
            .doubleValue(for: HKUnit.count())
        print("heartRate", heartRate)
    }
}



// TODO
// Если для новой строки не хватает значения столбца, можно взять медиану от всех строк для данного столбца
// использовать значения вчерашнего дня, позавчера, позапоза, среднее за неделю для некоторых полей. Шаги, зарядка, сладкое, порно

// At least 50 times as many rows as the number of columns for Accurate inferense
// Если мало строк, то evaluate нужно будет делать несколько раз и взять среднюю ошибку

// засунуть в интерфейс результат сегодняшнего дня при помощи regressor.predictions(from: DataFrame)


/* Чего нет/недоступно в HealthKit:
 настроение
 
 
 
 */
 
