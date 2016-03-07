//
//  PatientListController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 7/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//  Gebruik gemaakt van tutorial: https://www.raywenderlich.com/113772/uisearchcontroller-tutorial
//

import UIKit

class PatientListController: UITableViewController {
    var patients = [User]();

    
    override func viewDidLoad() {
        super.viewDidLoad();
        loadPatientsList()
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRowAtIndexPath(indexPath) {
            self.performSegueWithIdentifier("PatientSelectedSegue", sender: self)
        }
        
    }
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("You clicked one!");
        if segue.identifier == "showPatient" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let patientMedicaliDController = (segue.destinationViewController as! UINavigationController).topViewController as! PatientMedicaliDController;
                patientMedicaliDController.patient = patients[indexPath.row];
                patientMedicaliDController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem();
                patientMedicaliDController.navigationItem.leftItemsSupplementBackButton = true;
            }
        }
    }
*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("I clicked here!");
        if segue.identifier == "PatientSelectedSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let patientMedicaliDController = segue.destinationViewController as! PatientMedicaliDController;               patientMedicaliDController.patient = patients[indexPath.row];
                patientMedicaliDController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem();
                patientMedicaliDController.navigationItem.leftItemsSupplementBackButton = true;
            }
        }
    }
    

    
    /*
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let candy = candies[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailCandy = candy
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    */
}