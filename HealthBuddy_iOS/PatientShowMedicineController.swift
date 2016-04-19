//
//  PatientShowMedicineController.swift
//  HealthBuddy_iOS
//
//  Created by Eli on 19/04/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import Alamofire;

class PatientShowMedicineController: UIViewController {
    var medicine:Medicine!;
    var patientID:Int!;
    var schedule:MedicalSchedule!;
    
    @IBOutlet weak var MedicineTitle: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var DateTitle: UILabel!
    @IBOutlet weak var Amount: UILabel!
    @IBOutlet weak var takeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Routes.showMedicine(patientID!, medicineId: self.medicine!.id!));
        Alamofire.request(.POST, Routes.showMedicine(patientID!, medicineId: self.medicine!.id!), parameters: ["api_token": Authentication.token!], headers: ["Accept": "application/json"]) .responseJSON { response in
            if response.result.isSuccess {
                if let JSON = response.result.value {
                    if response.response?.statusCode == 200 {
                        let newMedicine = Mapper<Medicine>().map(JSON);
                        self.medicine?.updateMedicineInfo(newMedicine!);
                        print("Medicine updated");
                    }else if response.response?.statusCode == 422 {
                        print("Medicine show failed");
                    }
                }else{
                    print("Ongeldige json response medicine show");
                }
            }else{
                print("Ongeldige request medicine show ");
            }
        }
        ImageView.image = medicine.photo;
        MedicineTitle.text = self.medicine.name;
        DateTitle.text = self.schedule.start_date_s;
        Amount.text = self.schedule.amount;
        print(self.schedule.updated_at);
        /*if(self.schedule.updated_at!.equalToDate(NSDate())){
            takeButton.setTitle("Je hebt deze medicatie al ingenomen", forState: UIControlState.Normal)
            takeButton.enabled = false;
        }*/
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func touched(sender: AnyObject) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NSDate {
    func isBetweeen(date date1: NSDate, andDate date2: NSDate) -> Bool {
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }
    
    func daysSince1970() -> Int {
        return (Int)(self.timeIntervalSince1970 / (60*60*24));
    }
    func equalToDate(dateToCompare: NSDate) -> Bool {
        var isEqualTo = false
        
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        return isEqualTo
    }
}
