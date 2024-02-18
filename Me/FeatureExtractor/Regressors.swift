//
//  Regressors.swift
//  Me
//
//  Created by Artem on 17.02.2024.
//

import Foundation
import CreateML
import TabularData

class Regressors {
    public var linearRegressor: MLLinearRegressor?
    public var randomForest: MLRandomForestRegressor?
    public var boostedTree: MLBoostedTreeRegressor?
    public var decisionTree: MLDecisionTreeRegressor?
    
    
    func printRegrMetrics(title: String, metr: MLRegressorMetrics) {
        func x2(_ val: Double) -> String {
            String(format: "%.2f", val)
        }
        print(title, " RMSE:", x2(metr.rootMeanSquaredError * 100), "MAX:", x2(metr.maximumError * 100))
    }
    
    public func train(df: DataFrame, l1Penalty: Double = 0) throws {

        
        let params = MLLinearRegressor.ModelParameters(validation: .split(strategy: .automatic), l1Penalty: l1Penalty)
        linearRegressor = try MLLinearRegressor(trainingData: df, targetColumn: "mood", parameters: params)
        printRegrMetrics(title: "Train LinearRegressor", metr: linearRegressor!.trainingMetrics)
        printRegrMetrics(title: "Validate LinearRegressor", metr: linearRegressor!.validationMetrics)
        print("\n")

//        regressor = try MLRegressor(trainingData: df, targetColumn: "mood")
//        printRegrMetrics(title: "Train Regressor", metr: regressor!.trainingMetrics)
//        printRegrMetrics(title: "Validate Regressor", metr: regressor!.validationMetrics)
//        print("\n")

//        randomForest = try MLRandomForestRegressor(trainingData: df, targetColumn: "mood")
//        printRegrMetrics(title: "Train RandomForest", metr: randomForest!.trainingMetrics)
//        printRegrMetrics(title: "Validate RandomForest", metr: randomForest!.validationMetrics)
//
//        print("\n")

        boostedTree = try MLBoostedTreeRegressor(trainingData: df, targetColumn: "mood")
        printRegrMetrics(title: "Train boostedTree", metr: boostedTree!.trainingMetrics)
        printRegrMetrics(title: "Validate boostedTree", metr: boostedTree!.validationMetrics)
        print("\n")


//        decisionTree = try MLDecisionTreeRegressor(trainingData: regressorTable, targetColumn: "mood")
//        printRegrMetrics(title: "Train decisionTree", metr: decisionTree!.trainingMetrics)
//        printRegrMetrics(title: "Validate decisionTree", metr: decisionTree!.validationMetrics)
//        print("\n")
    }
}
