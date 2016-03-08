//
//  BuddyMainMenuController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 8/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit

class BuddyMainMenuController: UITableViewController {
    var patient:User!;
    var menuItems = ["Medisch ID","Medicatie","Gewicht"];
    var descriptions = ["Persoonlijke gegevens","Monitoring","Monitoring"];
    var logos = [UIImage(named: "MedischID"),UIImage(named: "Medicatie"),UIImage(named: "Gewicht")];
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(patient.firstName) \(patient.lastName)";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }





    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuItem", forIndexPath: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row];
        cell.detailTextLabel?.text = descriptions[indexPath.row];
        cell.imageView?.image = logos[indexPath.row];
        return cell
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    

}
