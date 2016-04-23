//
//  BuddyMedicineDashboardHistoryController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 23/04/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import RSDayFlow

class BuddyMedicineDashboardHistoryController: UIViewController,RSDFDatePickerViewDelegate,RSDFDatePickerViewDataSource {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.tabBarController!.navigationItem.rightBarButtonItem = nil;
        
        let datePicker = RSDFDatePickerView(frame: self.view.bounds);
        datePicker.dataSource = self;
        datePicker.delegate = self;
        self.view.addSubview(datePicker);
        
    }
    
    
}
