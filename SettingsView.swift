//
//  SettingsView.swift
//  GreenHomes
//
//  Created by Shao Qian MAH on 20/4/2016.
//
//

import UIKit

class SettingsView: UITableViewController {
    @IBOutlet weak var settingsCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        settingsCell.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
