//
//  House.swift
//  Me
//
//  Created by Artem on 17.02.2024.
//

import Foundation

public struct House: Codable {
    public var price: Int
    public var solarPanels: Double
    public var greenhouses: Double
    public var size: Int
    public var mood: Double

    public init(price: Int, solarPanels: Double, greenhouses: Double, size: Int, mood: Double) {
        self.price = price
        self.solarPanels = solarPanels
        self.greenhouses = greenhouses
        self.size = size
        self.mood = mood
    }

    public enum FeatureEnum: CaseIterable, CustomStringConvertible {
        case solar
        case green
        case size
        case price
        
        public var description: String {
            switch self {
            case .solar:
                return "solarPanels"
            case .green:
                return "greenhouses"
            case .size:
                return "size"
            case .price:
                return "price"
            }
        }
    }

}
