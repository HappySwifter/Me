//
//  EvalResult.swift
//  Me
//
//  Created by Artem on 17.02.2024.
//

import Foundation

public struct EvalResult: Identifiable {
    public let id = UUID()
    public let feature: String
    public let maxError: Double
    public let rmse: Double
}
