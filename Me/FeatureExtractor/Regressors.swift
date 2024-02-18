//
//  Regressors.swift
//  Me
//
//  Created by Artem on 17.02.2024.
//

import Foundation
import CreateML
import TabularData

public struct Regressors {
    public var randomForest: MLRandomForestRegressor?
    public var boostedTree: MLBoostedTreeRegressor?
    public var decisionTree: MLDecisionTreeRegressor?
    
    
    private static func printRegrMetrics(title: String, metr: MLRegressorMetrics) {
        func x2(_ val: Double) -> String { String(format: "%.2f", val) }
        print(title, " RMSE:", x2(metr.rootMeanSquaredError * 100), "MAX:", x2(metr.maximumError * 100))
    }
    
    public static func trainLinearRegressor(dataFrame: DataFrame, 
                                            targetColumn: String,
                                            l1Penalty: Double = 0) throws -> MLLinearRegressor {
        let params = MLLinearRegressor.ModelParameters(validation: .split(strategy: .automatic), l1Penalty: l1Penalty)
        let linearRegressor = try MLLinearRegressor(trainingData: dataFrame, targetColumn: targetColumn, parameters: params)
        printRegrMetrics(title: "Train LinearRegressor", metr: linearRegressor.trainingMetrics)
        printRegrMetrics(title: "Validate LinearRegressor", metr: linearRegressor.validationMetrics)
        return linearRegressor
        
//        regressor = try MLRegressor(trainingData: df, targetColumn: "mood")
//        printRegrMetrics(title: "Train Regressor", metr: regressor!.trainingMetrics)
//        printRegrMetrics(title: "Validate Regressor", metr: regressor!.validationMetrics)

//        randomForest = try MLRandomForestRegressor(trainingData: df, targetColumn: "mood")
//        printRegrMetrics(title: "Train RandomForest", metr: randomForest!.trainingMetrics)
//        printRegrMetrics(title: "Validate RandomForest", metr: randomForest!.validationMetrics)

//        decisionTree = try MLDecisionTreeRegressor(trainingData: regressorTable, targetColumn: "mood")
//        printRegrMetrics(title: "Train decisionTree", metr: decisionTree!.trainingMetrics)
//        printRegrMetrics(title: "Validate decisionTree", metr: decisionTree!.validationMetrics)
    }
    
    public static func trainBoostedTreeRegressor(dataFrame: DataFrame,
                                            targetColumn: String) throws -> MLBoostedTreeRegressor
    {
        let boostedTree = try MLBoostedTreeRegressor(trainingData: dataFrame, targetColumn: targetColumn)
        printRegrMetrics(title: "Train boostedTree", metr: boostedTree.trainingMetrics)
        printRegrMetrics(title: "Validate boostedTree", metr: boostedTree.validationMetrics)
        return boostedTree
        
    }

}
