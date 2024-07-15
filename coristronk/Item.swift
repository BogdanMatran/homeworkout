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
    var timestamp: String
    var name: String
    var reps: Int
    
    init(timestamp: Date, name: String, reps: Int) {
        self.timestamp = timestamp.formatted(date: .abbreviated, time: .omitted)
        self.name = name
        self.reps = reps
    }
}
