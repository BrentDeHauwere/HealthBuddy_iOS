//
//  BuddyMedicineController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 8/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit

class BuddyMedicineController: UITableViewController {
    @IBOutlet weak var lblMedicine: UILabel!
    
    var patient:User!
    var medicines = [Medicine]();

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMedicine.text = "Medicatie";
        self.navigationItem.title="\(patient.firstName) \(patient.lastName)";
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(named:"Menu"), style:.Plain, target:self, action:"backButtonPressed:");
        loadMedicinesOfPatients()
    }
    
    func backButtonPressed(sender:UIButton){
        navigationController?.popViewControllerAnimated(true);
    }
    

    func loadMedicinesOfPatients(){
        medicines = [Medicine(id:1, name: "Buscopan", photo: nil),Medicine(id:2, name: "Sinutab", photo: nil),Medicine(id:3, name: "Motilium", photo: nil)];
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.medicines.count;
    }
    
    //Maakt de cell op in de table
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("MedicineCell", forIndexPath: indexPath) as UITableViewCell;
        let medicine:Medicine = medicines[indexPath.row];
        cell.textLabel?.text = medicine.name;
        return cell;
    }

    //Perform the segue bij klikken op een cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("loadNewMedicine", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loadNewMedicine" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let navController = segue.destinationViewController as? UINavigationController {
                    if let buddyNewMedicine = navController.viewControllers[0] as? BuddyNewMedicineController {
                        buddyNewMedicine.medicin =  medicines[indexPath.row];
                        buddyNewMedicine.indexMedicin = indexPath.row;
                    }
                }
            }
        }
    }
    
    
    @IBAction func cancelNewMedicine(segue:UIStoryboardSegue) {
    }
    
    @IBAction func saveNewMedicine(segue:UIStoryboardSegue) {
        if let buddynewMedicineController = segue.sourceViewController as? BuddyNewMedicineController{
            if let medicine = buddynewMedicineController.medicin {
                //Indien nieuwe medicijn: append, else: replace
                if (buddynewMedicineController.indexMedicin == -1) {
                    medicines.append(medicine);
                    let indexPath = NSIndexPath(forRow: medicines.count-1, inSection: 0);
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    //TODO: save new medicin in db
                }else{
                    //TODO: update medicin in db
                    medicines[buddynewMedicineController.indexMedicin] = buddynewMedicineController.medicin!;
                    tableView.reloadData();
                }
            }
        }
    }
    
    

}
