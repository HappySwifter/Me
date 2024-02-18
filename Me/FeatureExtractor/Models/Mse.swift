//
//  NormilizedMse.swift
//  Me
//
//  Created by Artem on 18.02.2024.
//

import Foundation

public struct Mse: Identifiable {
    public var id: String {
        feature
    }    
    public let feature: String
    public let train: Double
    public let validate: Double
    
    public init(feature: String, train: Double, validate: Double) {
        self.feature = feature
        self.train = train
        self.validate = validate
    }
}
