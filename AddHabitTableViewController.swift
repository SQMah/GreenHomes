//
//  AddHabitTableViewController.swift
//  GreenHomes
//
//  Created by Shao Qian MAH on 22/3/2016.
//
//

import UIKit

class AddHabitTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var habitNameCell: UITableViewCell!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var timeSelectLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    @IBAction func timePickerValue(sender: UIDatePicker) {
        timePickerChanged()
    }
    
    var habit: Habit?
    
    var category: String = "Water" {
        didSet {
            categoryLabel.text? = category
        }
    }
    
    var timePickerHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePickerChanged()
        
        self.nameTextField.delegate = self
        nameTextField.returnKeyType = UIReturnKeyType.Done
        
        // Set the background of the habit name cell and time picker cell to none
        
        habitNameCell.selectionStyle = UITableViewCellSelectionStyle.None
        
        toggleTimePickerColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Animates selection
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // Sets keyboard to respond when cell for habit name is clicked
        if indexPath.section == 0 {
            nameTextField.becomeFirstResponder()
        }
        // Toggles date picker when when cell for time is clicked
        if indexPath.section == 2 && indexPath.row == 0 {
            
            // Shows and hides time picker: toggleTimePicker()
            timePickerHidden = !timePickerHidden
            tableView.beginUpdates()
            tableView.endUpdates()
            
            toggleTimePickerColor()
        }
    }
    
    // Sets cell background colour according to active state
    func toggleTimePickerColor() {
        if timePickerHidden == false {
            timeSelectLabel.textColor = UIColor(red: 21/255, green: 126/255, blue: 251/255, alpha: 1)
        }
        if timePickerHidden == true {
            timeSelectLabel.textColor = UIColor.blackColor()
        }
    }
    
    // Changes cell height according to whether or not time picker is hidden
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if timePickerHidden && indexPath.section == 2 && indexPath.row == 1 {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    // Set label text to time picked
    
    func timePickerChanged () {
        timeLabel.text = NSDateFormatter.localizedStringFromDate(timePicker.date, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
    }
    
    // Textfield editing ends on 'Done/Return'
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // Category information is passed to this view controller
    
    @IBAction func unwindWithSelectedCategory(segue:UIStoryboardSegue) {
        if let categoryTableViewController = segue.sourceViewController as? CategoryTableViewController,
            selectedCategory = categoryTableViewController.selectedCategory {
            category = selectedCategory
        }
   }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "saveHabit" {
            if (nameTextField.text!.isEmpty) {
                let alert = UIAlertController(title: "Missing name", message: "Please add a name for the habit", preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                }
                
                alert.addAction(OKAction)
                
                self.presentViewController(alert, animated: true) {
                }
                return false
            }
            if categoryLabel.text == "Select" {
                let alert = UIAlertController(title: "Missing category", message: "Please select a category for the habit", preferredStyle: .Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                }
                
                alert.addAction(OKAction)
                
                self.presentViewController(alert, animated: true) {
                }
                return false
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveHabit" {
            habit = Habit(name: nameTextField.text!, category: categoryLabel.text!, time: timeLabel.text)
        }
        if segue.identifier == "pickCategory" {
            if let categoryTableViewController = segue.destinationViewController as? CategoryTableViewController {
                categoryTableViewController.selectedCategory = category
            }
        }
    }
}
