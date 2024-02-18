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

struct Predictor {
    
    
//    // Define a function to shuffle rows in a column
//    static func shuffleRowsInColumn(df: DataFrame, column: String) -> DataFrame {
//      // Get the values of the column as an array
//      var values = df[column].values
//      // Shuffle the array using the Fisher-Yates algorithm
//      for i in stride(from: values.count - 1, to: 0, by: -1) {
//        let j = Int.random (in: 0...i)
//        values.swapAt (i, j)
//      }
//      // Create a new DataFrame with the shuffled column
//      var newDf = df
//      newDf[column] = Column(values)
//      // Return the new DataFrame
//      return newDf
//    }
    

//    static func dataFrame(from house: [House]) throws -> DataFrame {
//        let data = try JSONEncoder().encode(house)
//        return try DataFrame(jsonData: data)
//    }

//    static func predict(regr: Regressabe, house: House) throws {
//        let dataframe = try dataFrame(from: [house])
//        let pred = try regr.predictions(from: dataframe)
//        let type = pred.assumingType(Double.self)
//        let mean = type.mean()!
//        print("Predicted mood: ", String(format: "%.2f", mean))
//        print("Actual mood: ", house.mood)
//    }
    
    static func evaluate(regr: Regressabe, featureName: String, df: DataFrame) throws -> EvalResult {
        let eval = regr.evaluation(on: df)
        if let error = eval.error {
            print("!!!!", error.localizedDescription)
        }
        
        
        return EvalResult(feature: featureName,
                          maxError: eval.maximumError,
                          rmse: eval.rootMeanSquaredError)
    }

    static func adjust(regr: Regressabe,
                       df: DataFrame,
                       maxCount: Int,
                       featureName: String) throws -> EvalResult {
        var mutableCopy = df
        if featureName == "price" || featureName == "size" {
            mutableCopy[featureName] = mutableCopy[featureName].map { _ in
                (mutableCopy[featureName].randomElement()! as! Int)
            }
        } else {
            mutableCopy[featureName] = mutableCopy[featureName].map { _ in
                (mutableCopy[featureName].randomElement()! as! Double)
            }
        }
        let truncated = DataFrame(mutableCopy.prefix(maxCount))
        return try evaluate(regr: regr, featureName: featureName, df: mutableCopy)
    }
    
}
