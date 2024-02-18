//
//  EvalParameters.swift
//  Me
//
//  Created by Artem on 18.02.2024.
//

import Foundation
import CreateML
import TabularData

public struct EvalParameters {
    /// Number of rows to evaluate on
    public let maxRowsCount: Int
    /// If true, then will be calculated difference between evaluation error and training/validation errors
    public let normalized: Bool
    /// If true, then value will be returned in percents (multiply by 100)
    public let percentValue: Bool
    
    public init(maxRowsCount: Int, normalized: Bool, percentValue: Bool) {
        self.maxRowsCount = maxRowsCount
        self.normalized = normalized
        self.percentValue = percentValue
    }
}


