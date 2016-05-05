//
//  EditHabit.swift
//  GreenHomes
//
//  Created by Shao Qian MAH on 22/3/2016.
//
//

import UIKit

class EditHabit: UITableViewController {
    
    @IBOutlet weak var editNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            editNameTextField.becomeFirstResponder()
        }
    }
}
