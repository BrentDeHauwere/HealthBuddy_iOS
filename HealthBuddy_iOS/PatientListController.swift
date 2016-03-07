//
//  PatientListController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 7/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit

class PatientListController: UITableViewController {
    var patients = [User]();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view, typically from a nib.
        loadPatientsList()
    
    }
    
    func loadPatientsList(){
        //TODO: haal alle patienten af met als buddy_id = user_id ingelogde user
        
        //mock:
        self.patients = [User(firstName:"Yen", lastName: "Jacobs"),User(firstName:"Elvin", lastName: "Jacobs"),User(firstName:"Gunther", lastName: "Jacobs"),User(firstName:"Sabine", lastName: "Baeyens"),User(firstName:"Dieter", lastName: "Roels")];

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.patients.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("patient", forIndexPath: indexPath) as UITableViewCell;
        let patient: User = patients[indexPath.row];
        
        
        cell.textLabel?.text = patient.firstName + " " + patient.lastName;
        return cell;
    }
    
}