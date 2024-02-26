//
//  Feature.swift
//  Me
//
//  Created by Artem on 23.02.2024.
//

import Foundation
import SwiftData


//enum FeatureType: Codable, CaseIterable {
//    var desc: String {
//        switch self {
//        case .intType:
//            return "int"
//        case .doubleType:
//            return "double"
//        case .stringType:
//            return "string"
//        }
//    }
//    
//    case intType
//    case doubleType
//    case stringType
//}

enum InputType: String, CaseIterable, Codable {
    case option = "Option"
    case yesNo = "Yes / No"
    case mumeric = "Numeric"
}

@Model
final class Feature {
    var name: String
    var type: InputType
    let options: [String]

    init(name: String, type: InputType, options: [String]) {
        self.name = name
        self.type = type
        self.options = options
    }
}
