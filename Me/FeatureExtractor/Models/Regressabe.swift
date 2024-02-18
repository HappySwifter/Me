//
//  Regressabe.swift
//  Me
//
//  Created by Artem on 17.02.2024.
//

import Foundation
import CreateML
import TabularData

public protocol Regressabe {
    var trainingMetrics: MLRegressorMetrics { get }
    var validationMetrics: MLRegressorMetrics { get }
    
    func evaluation(on labeledData: DataFrame) -> MLRegressorMetrics
    func predictions(from data: DataFrame) throws -> AnyColumn
}

extension MLLinearRegressor: Regressabe {}
extension MLRandomForestRegressor: Regressabe {}
extension MLBoostedTreeRegressor: Regressabe {}
extension MLDecisionTreeRegressor: Regressabe {}


