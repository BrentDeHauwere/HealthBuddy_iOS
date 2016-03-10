//
//  BuddyNewMedicineController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 10/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//  Gebruik gemaakt van tutorial: https://www.raywenderlich.com/113394/storyboards-tutorial-in-ios-9-part-2

import UIKit;

class BuddyNewMedicineController: UITableViewController {
    
    @IBOutlet weak var lblNameMedicin: UITextField!
    var medicin:Medicine?
    var indexMedicin = -1;

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //Formulier opvullen indien bestaande medicijn wordt geupdate
        if indexMedicin != -1 {
            lblNameMedicin.text = medicin?.name;
        }
    }
    
    func initForm(){
        lblNameMedicin.text = medicin?.name;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            lblNameMedicin.becomeFirstResponder()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveNewMedicine" {
            medicin = Medicine(id:-1, name: lblNameMedicin.text!, photo: nil);
        }
    }
}
