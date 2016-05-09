//
//  HomeTableViewController.swift
//  GreenHomes
//
//  Created by Shao Qian MAH on 26/4/2016.
//
//

import UIKit
import CoreData

let managedContext = AppDelegate().managedObjectContext

class HomeTableViewController: UITableViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
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
        updateCounts()
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
    
// Fetch from CoreData
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest = NSFetchRequest(entityName: "Habit")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            habits = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        updateCounts()
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
            
            let entity =  NSEntityDescription.entityForName("Habit", inManagedObjectContext: managedContext)
            let habitObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            
            let habit = addHabitTableViewController.habit
            habitObject.setValue(habit!.name, forKey: "name")
            habitObject.setValue(habit!.category, forKey: "category")
            habitObject.setValue(habit!.time, forKey: "time")
                
                
            do {
                try managedContext.save()
                habits.append(habitObject)
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            tableView.reloadData()
            updateCounts()
        }
    }
}