//
//  HomeTableViewController.swift
//  GreenHomes
//
//  Created by Shao Qian MAH on 26/4/2016.
//
//

import UIKit
import CoreData

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

let managedContext = appDelegate.managedObjectContext

let entity =  NSEntityDescription.entityForName("Habit", inManagedObjectContext:managedContext)

let habitObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)

class HomeTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var habits = habitsData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Textfield in search bar
        let searchTextField = self.searchBar.valueForKey("searchField") as! UITextField
        
        //Set text color to white
        searchTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Search", comment: ""), attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        searchTextField.textColor = UIColor.whiteColor()
        
        numberLabel.text = String(habits.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("habitCell", forIndexPath: indexPath)
            
            let habit = habits[indexPath.row]
            cell.textLabel!.text = habit.valueForKey("name") as? String
            cell.detailTextLabel!.text = habit.valueForKey("category") as? String
            return cell
    }
    
    func updateCounts() {
        numberLabel.text = String(habits.count)
    }
    
    @IBAction func settingstoHome(segue:UIStoryboardSegue) {
    }
    
    @IBAction func cancelToHome(segue:UIStoryboardSegue) {
    }
    
    @IBAction func saveHabit(segue:UIStoryboardSegue) {
        if let addHabitTableViewController = segue.sourceViewController as? AddHabitTableViewController {
            
            //add the new player to the players array
            if let habit = addHabitTableViewController.habit {
                habitObject.setValue(habit.name, forKey: "name")
                habitObject.setValue(habit.category, forKey: "category")
                habitObject.setValue(habit.time, forKey: "time")
                do {
                    try managedContext.save()
                    habitsData.append(habitObject)
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                updateCounts()
            }
        }
    }
}