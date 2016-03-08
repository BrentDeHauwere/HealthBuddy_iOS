//
//  PatientListController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 7/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//  Gebruik gemaakt van tutorial: https://www.raywenderlich.com/113772/uisearchcontroller-tutorial
//

import UIKit

class BudyListControler: UITableViewController {
    var patients = [User]();

    override func viewDidLoad() {
        super.viewDidLoad();
        self.navigationItem.hidesBackButton = true;
        loadPatientsList()
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil);
    }
    
    
    func loadPatientsList(){
        //TODO: haal alle patienten af met als buddy_id = user_id ingelogde user
        
        //mock:
        self.patients = [User(firstName:"Yen", lastName: "Jacobs"),User(firstName:"Elvin", lastName: "Jacobs"),User(firstName:"Gunther", lastName: "Jacobs"),User(firstName:"Sabine", lastName: "Baeyens"),User(firstName:"Dieter", lastName: "Roels")];
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.patients.count;
    }
    
    //Maakt de cell op in de table
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("patient", forIndexPath: indexPath) as UITableViewCell;
        let patient: User = patients[indexPath.row];
        cell.textLabel?.text = patient.firstName + " " + patient.lastName;
        return cell;
    }
    
    //Perform the segue bij klikken op een cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("gotoBuddyMenu", sender: self)
    }

    
    //Event dat uitgevoerd wordt bij klikken op een cel, voordat segue wordt afgevoerd
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoBuddyMenu" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let budyMainMenu = segue.destinationViewController as! BuddyMainMenuController ;
                budyMainMenu.patient = patients[indexPath.row];
            }
        }
    }
}