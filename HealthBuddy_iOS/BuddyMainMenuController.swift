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
        self.tableView.tableFooterView = UIView(frame: CGRectZero);
        self.navigationItem.title = "\(patient.firstName) \(patient.lastName)";
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil);

        //setupBackButtonToPatientsList();
    }

    
    func setupBackButtonToPatientsList(){
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "ContactenLogo");
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ContactenLogo");
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count;
    }

    //Make up menu items
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuItem", forIndexPath: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row];
        cell.detailTextLabel?.text = descriptions[indexPath.row];
        cell.imageView?.image = logos[indexPath.row];
        return cell
    }
    //Select menuItem, fire of segue
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row);
        switch indexPath.row{
            case 0:
                self.performSegueWithIdentifier("gotoMedicaliD", sender: self);
            case 1:
                self.performSegueWithIdentifier("showMedicine", sender: self);
            case 2:
                self.performSegueWithIdentifier("gotoWeight", sender: self);
            default:
                print("Ongeldig menu-item, error from BuddyMainMenuController @tableView didSelectRowAtIndexpath");
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoMedicaliD"{
            let medicalIdBoard = segue.destinationViewController as! BudyMedicaliDController;
            medicalIdBoard.patient = patient;
        }else if segue.identifier == "showMedicine" {
            let medicineBoard = segue.destinationViewController as! BuddyMedicineController;
            medicineBoard.patient = patient;
        }else if segue.identifier == "gotoWeight" {
            let weightBoard = segue.destinationViewController as! BuddyWeightController;
            weightBoard.patient = patient;
        }
    }
    

}
