//
//  habitData.swift
//  GreenHomes
//
//  Created by Shao Qian MAH on 26/4/2016.
//
//

import UIKit
import CoreData

struct Habit {
    var name: String?
    var category: String?
    var time: String?
    
    init(name: String?, category: String?, time: String?) {
        self.name = name
        self.category = category
        self.time = time
    }
}

var habitsData = [NSManagedObject]()