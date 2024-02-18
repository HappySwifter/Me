//
//  Predictor.swift
//  Me
//
//  Created by Artem on 17.02.2024.
//

import Foundation
import TabularData
import CoreML
import CreateML

public struct Predictor {
    
    private static func shuffle(columnName: String, for df: DataFrame) -> DataFrame {
        let shuffled = df[columnName].shuffled()
        var mutableCopy = df
        for index in 0..<shuffled.count {
            mutableCopy[columnName][index] = shuffled[index]
        }
        return mutableCopy
    }
    
    public static func getFeatureImportance(dataFrame: DataFrame,
                                            featureName: String,
                                            regressor: Regressabe,
                                            parameters: EvalParameters) throws -> Mse
    {
        let truncated = DataFrame(dataFrame.prefix(parameters.maxRowsCount))
        let shuffledDf = shuffle(columnName: featureName, for: truncated)
        let evaluation = regressor.evaluation(on: shuffledDf)
        if let error = evaluation.error {
            throw RegressorError.customError(text: error.localizedDescription)
        } else {
            return normalizeErrorValues(feature: featureName,
                                        regressor: regressor,
                                        shuffled: evaluation,
                                        parameters: parameters)
        }
    }
    
    public static func normalizeErrorValues(feature: String,
                                            regressor: Regressabe,
                                            shuffled: MLRegressorMetrics,
                                            parameters: EvalParameters) -> Mse {
        let percentValue: Double = parameters.percentValue ? 100 : 1
        if parameters.normalized {
            let trainMse = regressor.trainingMetrics.rootMeanSquaredError
            let validationMse = regressor.validationMetrics.rootMeanSquaredError
            let trainDiff = abs(shuffled.rootMeanSquaredError - trainMse) * percentValue
            let validateDiff = abs(shuffled.rootMeanSquaredError - validationMse) * percentValue
            return Mse(feature: feature, train: trainDiff, validate: validateDiff)
        } else {
            let mse = shuffled.rootMeanSquaredError * percentValue
            return Mse(feature: feature,
                       train: mse,
                       validate: mse)
        }
    }
    
//    private static func fd(_ val: Double, pres: Int = 0) -> String {
//        String(format: "%.\(pres)f", val)
//    }
//        
//    public static func printError(mse: Mse) {
//        print("Diif with trained")
//        print("Mean:", fd(mse.train))
////        print("Max:", fd((shufMax - train.maximumError) * 100))
//        
//        print("Diff with validation")
//        print("Mean:", fd(mse.validate))
////        print("Max:", fd((shufMax - validate.maximumError) * 100))
//        print()
//    }
}
