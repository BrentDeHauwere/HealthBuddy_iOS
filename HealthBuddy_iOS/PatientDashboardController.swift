//
//  PatientDashboardController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 17/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import CircleProgressView

class PatientDashboardController: UIViewController {
    @IBOutlet weak var circleProgressView: CircleProgressView!
    
    var patient:User?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.title = "\(patient!.firstName!) \(patient!.lastName!)";
    }
    
    override func viewDidAppear(animated: Bool) {
        circleProgressView.setProgress(calculateProgress(), animated: true);
    }
    
    func calculateProgress() -> Double {
        return 0.8;
    }
}
