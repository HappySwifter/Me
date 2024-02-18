//
//  Item.swift
//  Me
//
//  Created by Artem on 17.02.2024.
//

import Foundation
import SwiftData


@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}


