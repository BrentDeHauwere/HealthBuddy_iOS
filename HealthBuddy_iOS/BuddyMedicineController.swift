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
    
    
    //Delete a medicin
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let alert = UIAlertController(title: "Verwijder \(medicines[indexPath.row].name)", message: "Bent u zeker?", preferredStyle: .ActionSheet)
            
            let DeleteAction = UIAlertAction(title: "Akkoord", style: .Destructive) { action -> Void in
                tableView.beginUpdates()
                self.medicines.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                //TODO: delete record in db
                tableView.endUpdates()
            }
            
            let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {action -> Void in
                tableView.setEditing(false, animated: true);
            }
            
            alert.addAction(DeleteAction)
            alert.addAction(CancelAction)
            
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    

   
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loadNewMedicine" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let navController = segue.destinationViewController as? UINavigationController {
                    if let buddyNewMedicine = navController.viewControllers[0] as? BuddyNewMedicineController {
                        buddyNewMedicine.medicin =  medicines[indexPath.row];
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
                if(buddynewMedicineController.newMedicin){
                    print("NIEUW MEDICIJN");
                    medicines.append(medicine);
                    let indexPath = NSIndexPath(forRow: medicines.count-1, inSection: 0);
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }else{
                    print("UDPATE MEDICIJ");
                    tableView.reloadData();
                }
            }
        }
    }
    
    

}
