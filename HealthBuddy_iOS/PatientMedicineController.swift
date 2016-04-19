//
//  PatientMedicineController.swift
//  HealthBuddy_iOS
//
//  Created by Eli on 11/04/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit;
class PatientMedicineController: UITableViewController {
    var patient:User!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.title = "Medicatie";
    }
    
    func backButtonPressed(sender:UIButton){
        navigationController?.popViewControllerAnimated(true);
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.patient.medicines!.count;
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("MedicineCell", forIndexPath: indexPath) as UITableViewCell;
        let medicine:Medicine = self.patient.medicines![indexPath.row];
        cell.textLabel?.text = medicine.name;
        return cell;
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loadMedicine" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let Controller = segue.destinationViewController as? PatientShowMedicineController {
                    Controller.medicine =  self.patient.medicines![indexPath.row];
                    Controller.patientID = self.patient.userId;
                }
            }
        }
        
    }
    
    
}