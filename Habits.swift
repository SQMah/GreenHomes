//
//  Habits.swift
//  GreenHomes
//
//  Created by Shao Qian MAH on 22/3/2016.
//
//

import UIKit

struct Habit {
    var name: String
    var category: String
    var time: String
    
    init(name: String, category: String, time: String) {
        self.name = name
        self.category = category
        self.time = time
    }
}

let habitData = [
    Habit(name: "Turn off tap", category: "Water", time: "9:00 AM"),
    Habit(name: "Turn off lights", category: "Power", time: "12:00 PM"),
    Habit(name: "Turn off charger", category: "Power", time: "3:00 PM"),
    Habit(name: "Recycle glass", category: "Waste", time: "8:00 PM")
]