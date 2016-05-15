//
//  HabitCell.swift
//  GreenHomes
//
//  Created by Shao Qian MAH on 9/5/2016.
//
//

import UIKit

class HabitCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var habit: Habit! {
        didSet {
            nameLabel.text = habit.name
            categoryLabel.text = habit.category
            timeLabel.text = habit.time
        }
    }
}


