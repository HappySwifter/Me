//
//  Regressabe.swift
//  Me
//
//  Created by Artem on 17.02.2024.
//

import Foundation
import CreateML
import TabularData

protocol Regressabe {
    func evaluation(on labeledData: DataFrame) -> MLRegressorMetrics
    func predictions(from data: DataFrame) throws -> AnyColumn
}

extension MLLinearRegressor: Regressabe {}
extension MLRandomForestRegressor: Regressabe {}
extension MLBoostedTreeRegressor: Regressabe {}
extension MLDecisionTreeRegressor: Regressabe {}
