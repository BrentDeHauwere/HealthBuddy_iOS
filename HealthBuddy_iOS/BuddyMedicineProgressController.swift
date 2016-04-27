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
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var circleProgressView: CircleProgressView!
    @IBOutlet weak var lblProgress: UILabel!
    var patient:User?
    var progress:Progress?
    var dateFormatter:NSDateFormatter = NSDateFormatter();
    
    override func viewDidLoad() {
         self.navigationItem.title = "\(patient!.firstName!) \(patient!.lastName!)";
       // self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Overzicht", style: .Plain, target: self, action:#selector(BuddyMedicineProgressController.popView));
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backBtn"), style: .Plain, target: self, action: #selector(BuddyMedicineProgressController.popView));
        
    }
    
    func popView(){
        self.navigationController?.popViewControllerAnimated(true);
    }
    override func viewDidAppear(animated: Bool) {
        circleProgressView.setProgress(getProgress(), animated: true);
        if(self.progress?.taken == self.progress?.toTake){
            self.lblProgress.text = "Alle medicijnen ingenomen";
        }else{
            self.lblProgress.text = "\((self.progress?.taken!)!) van de \((self.progress?.toTake!)!) medicijnen ingenomen";
        }
        self.dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT+0:00");
        self.dateFormatter.dateFormat = "E d MMM yyyy"
        self.lblDate.text = dateFormatter.stringFromDate((self.progress?.day)!);
    }
    
    func getProgress()->Double{
        if(progress?.toTake != nil && progress?.taken != nil){
            let calculatedProgress =  Double((progress?.taken)!) / Double((progress?.toTake)!);
            return calculatedProgress;
        }
        return 0;
    }
    
}
