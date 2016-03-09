//
//  BuddyWeightController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 8/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit

class BuddyWeightController: UIViewController {
    
    var patient:User!
    @IBOutlet weak var lblWeight: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblWeight.text = "Gewicht"
        self.navigationItem.title="\(patient.firstName) \(patient.lastName)";
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(named:"Menu"), style:.Plain, target:self, action:"backButtonPressed:");
    }
    
    func backButtonPressed(sender:UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
