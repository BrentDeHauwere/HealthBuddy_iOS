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
        medicines = [Medicine(id:1, name: "Buscopan",photoUrl: "link"),Medicine(id:1, name: "Sinutab",photoUrl: "link"),Medicine(id:1, name: "Motilium",photoUrl: "link")];
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


}
