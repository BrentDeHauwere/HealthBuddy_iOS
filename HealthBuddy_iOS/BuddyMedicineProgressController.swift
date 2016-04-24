//
//  BuddyMedicineProgressController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 23/04/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit;
import CircleProgressView

class BuddyMedicineProgressController: UIViewController {
    @IBOutlet weak var circleProgressView: CircleProgressView!
    var patient:User?
    
    override func viewDidLoad() {
         self.navigationItem.title = "\(patient!.firstName!) \(patient!.lastName!)";
         self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Overzicht", style: .Plain, target: self, action: nil);
    }
    override func viewDidAppear(animated: Bool) {
        circleProgressView.setProgress(getProgress(), animated: true);
    }
    
    func getProgress()->Double{
        return 10/10;
    }
    
}
