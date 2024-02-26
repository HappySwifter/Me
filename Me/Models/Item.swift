//
//  Item.swift
//  Me
//
//  Created by Artem on 17.02.2024.
//

import Foundation
import SwiftData


final class Item<T> {
    var timestamp: Date
    var featureName: String
    var value: T
    
    init(timestamp: Date, featureName: String, value: T) {
        self.timestamp = timestamp
        self.featureName = featureName
        self.value = value
    }
}

class Row<T> {
    var items: [Item<T>]
    
    init(items: [Item<T>]) {
        self.items = items
    }
}

