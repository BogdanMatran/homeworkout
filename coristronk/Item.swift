//
//  Item.swift
//  coristronk
//
//  Created by Matran Bogdan on 08.07.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var name: String
    var reps: Int
    
    init(timestamp: Date, name: String, reps: Int) {
        self.timestamp = timestamp
        self.name = name
        self.reps = reps
    }
}
