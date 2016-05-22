//
//  HomeTableViewController.swift
//  GreenHomes
//
//  Created by Shao Qian MAH on 26/4/2016.
//
//

import UIKit
import CoreData

// Core Data
let managedContext = AppDelegate().managedObjectContext
let fetchRequest = NSFetchRequest(entityName: "Habit")

var habits = habitsData



class HomeTableViewController: UITableViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var wasteLabel: UILabel!
    @IBOutlet weak var miscLabel: UILabel!
    
    var timer: dispatch_source_t!
    var passedBackIndexPath: Int = 0
    
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let isFirstLaunch = NSUserDefaults.isFirstLaunch()
        if isFirstLaunch == false {
            guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return }
        
            if settings.types == .None {
                let alertController = UIAlertController(
                    title: "Notifications is turned off for the app",
                    message: "In order for us to send you reminders for your habits, you should consider allowing our app to send notifications",
                    preferredStyle: .Alert)
            
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
            
                let openAction = UIAlertAction(title: "Settings", style: .Default) { (action) in
                    if let url = (NSURL(string: "prefs:root=NOTIFICATIONS_ID")) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
                alertController.addAction(openAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                
            }
        }
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
    
    // Delete habits
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            
            // Removes notification for the habit that is to be deleted
            
            let fetchRequest = NSFetchRequest(entityName: "Habit")
            
            do {
                let results = try managedContext.executeFetchRequest(fetchRequest)
                habits = results as! [NSManagedObject]
                let habitAtIndex = habits[indexPath.row]
                let habitName = habitAtIndex.valueForKey("name") as? String
                let habitCategory = habitAtIndex.valueForKey("category") as? String
                let habitTime = habitAtIndex.valueForKey("time") as? String
                let keyValuetoDelete = "Optional(\(habitName),\(habitCategory),\(habitTime))"
                
                let notifArray: NSArray = UIApplication.sharedApplication().scheduledLocalNotifications!
                for i in 0 ..< notifArray.count {
                    let notification: UILocalNotification = notifArray[i] as! UILocalNotification
                    
                    let userInfoDictionary: [NSObject : AnyObject] = notification.userInfo!
                    let uniqueKeyValue: String = "\(userInfoDictionary["ID"])"
                    if uniqueKeyValue == keyValuetoDelete {
                        UIApplication.sharedApplication().cancelLocalNotification(notification)
                    }
                }
                
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            
            // remove the deleted item from the model
            managedContext.deleteObject(habits[indexPath.row] as NSManagedObject)
            habits.removeAtIndex(indexPath.row)
            do {
                try managedContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            // remove the deleted item from the `UITableView`
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            return
            
        }
        updateCounts()
    }
    
    // Update counts of habits
    
    func updateCounts() {
        numberLabel.text = String(habits.count)
        let fetchRequest = NSFetchRequest(entityName: "Habit")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            habits = results as! [NSManagedObject]
            var numOfWater: Int = 0
            var numOfPower: Int = 0
            var numOfWaste: Int = 0
            var numOfMisc: Int = 0
            
            // Tests for different category strings for all the objects in habits database
            
            for index in 0 ..< habits.count {
                let habitAtIndex = habits[index]
                if habitAtIndex.valueForKey("category") as? String == "Water" {
                    numOfWater += 1
                } else if habitAtIndex.valueForKey("category") as? String == "Power" {
                    numOfPower += 1
                } else if habitAtIndex.valueForKey("category") as? String == "Waste" {
                    numOfWaste += 1
                } else if habitAtIndex.valueForKey("category") as? String == "Misc." {
                    numOfMisc += 1
                }
            }
            waterLabel.text = "\(numOfWater) water"
            powerLabel.text = "\(numOfPower) power"
            wasteLabel.text = "\(numOfWaste) waste"
            miscLabel.text = "\(numOfMisc) misc"
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editHabit" {
            let selectedRowIndex = self.tableView.indexPathForSelectedRow
            let editHabitTableViewController = segue.destinationViewController as? EditHabitTableViewController
            editHabitTableViewController?.indexPath = selectedRowIndex!.row
        }
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
            
            // create a corresponding local notification
            let notification:UILocalNotification = UILocalNotification()
            notification.alertTitle = "Habit reminder" // text for the notification title
            notification.alertBody = "It's time for habit '\(habit!.name!)'!" // text that will be displayed in the notification
            notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
            
            // converts saved habit time string to NSDate
            
            let timeAsString = habit!.time
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            let time = timeFormatter.dateFromString(timeAsString!)
            
            notification.fireDate = time // habit due date (when notification will be fired)
            notification.repeatInterval = NSCalendarUnit.Day // repeats every day
            notification.timeZone = NSCalendar.currentCalendar().timeZone // set to time zone user is in
            notification.soundName = UILocalNotificationDefaultSoundName // play default sound
            notification.category = "TODO_CATEGORY" // I have no idea but I'm going to keep it there
            notification.userInfo = ["ID": "\(habit!.name),\(habit!.category),\(habit!.time)"]
            UIApplication.sharedApplication().scheduleLocalNotification(notification) // schedules notification
        }
    }
    
    // This is only slightly different from the addHabit function: it deletes the initial version of the habit and appends the edited version by deleting the habits object at the indexPath that the user clicked to edit the habit
    @IBAction func editHabit(segue:UIStoryboardSegue) {
        if let editHabitTableViewController = segue.sourceViewController as? EditHabitTableViewController {
            let indexPath = editHabitTableViewController.indexPath
            let entity =  NSEntityDescription.entityForName("Habit", inManagedObjectContext: managedContext)
            let habitObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
            
            let habit = editHabitTableViewController.habit
            habitObject.setValue(habit!.name, forKey: "name")
            habitObject.setValue(habit!.category, forKey: "category")
            habitObject.setValue(habit!.time, forKey: "time")
            
            // deletes old object and notification
            
            do {
                // get old habit data
                let habitAtIndex = habits[indexPath]
                let habitName = habitAtIndex.valueForKey("name") as? String
                let habitCategory = habitAtIndex.valueForKey("category") as? String
                let habitTime = habitAtIndex.valueForKey("time") as? String
                let keyValuetoDelete = "Optional(\(habitName),\(habitCategory),\(habitTime))"
                let notifArray: NSArray = UIApplication.sharedApplication().scheduledLocalNotifications!
                for i in 0 ..< notifArray.count {
                    let notification: UILocalNotification = notifArray[i] as! UILocalNotification
                    
                    // compares old habit data with notification list ID and deletes the one with the old ID
                    let userInfoDictionary: [NSObject : AnyObject] = notification.userInfo!
                    let uniqueKeyValue: String = "\(userInfoDictionary["ID"])"
                    if uniqueKeyValue == keyValuetoDelete {
                         UIApplication.sharedApplication().cancelLocalNotification(notification)
                    }
                }
                
                managedContext.deleteObject(habits[indexPath] as NSManagedObject)
                habits.removeAtIndex(indexPath)
                
                try managedContext.save()
                habits.append(habitObject)
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            tableView.reloadData()
            updateCounts()
            
            // create a corresponding local notification
            let notification:UILocalNotification = UILocalNotification()
            notification.alertTitle = "Habit reminder" // text for the notification title
            notification.alertBody = "It's time for habit '\(habit!.name!)'!" // text that will be displayed in the notification
            notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
            
            // converts saved habit time string to NSDate
            
            let timeAsString = habit!.time
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            let time = timeFormatter.dateFromString(timeAsString!)
            
            notification.fireDate = time // habit due date (when notification will be fired)
            notification.repeatInterval = NSCalendarUnit.Day // repeats every day
            notification.timeZone = NSCalendar.currentCalendar().timeZone // set to time zone user is in
            notification.soundName = UILocalNotificationDefaultSoundName // play default sound
            notification.category = "TODO_CATEGORY" // I have no idea but I'm going to keep it there
            notification.userInfo = ["ID": "\(habit!.name),\(habit!.category),\(habit!.time)"]
            UIApplication.sharedApplication().scheduleLocalNotification(notification) // schedules notification
        }
    }
}

extension NSUserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    static func isFirstLaunch() -> Bool {
        let firstLaunchFlag = "FirstLaunchFlag"
        let isFirstLaunch = NSUserDefaults.standardUserDefaults().stringForKey(firstLaunchFlag) == nil
        if (isFirstLaunch) {
            NSUserDefaults.standardUserDefaults().setObject("false", forKey: firstLaunchFlag)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        return isFirstLaunch
    }
}

