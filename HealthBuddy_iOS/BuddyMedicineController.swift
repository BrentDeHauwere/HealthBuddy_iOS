//
//  BuddyMedicineController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 8/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit

class BuddyMedicineController: UIViewController {
    var patient:User!
    
    @IBOutlet weak var lblMedicine: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMedicine.text = "Medicijnen";
        self.navigationItem.title="\(patient.firstName) \(patient.lastName)";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
