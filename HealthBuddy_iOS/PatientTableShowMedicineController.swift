//
//  PatientTableShowMedicineController.swift
//  HealthBuddy_iOS
//
//  Created by Eli on 26/04/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import Alamofire;
import MRProgress;
import ObjectMapper;

class PatientTableShowMedicineController: UITableViewController {
    var medicine:Medicine!;
    var patientID:Int!;
    var schedule:MedicalSchedule!;
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var InfoLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    //@IBOutlet weak var TakeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check if notification fired
        if  let medicineID = NSUserDefaults.standardUserDefaults().objectForKey("firedMedicineID") as? String,
            let scheduleID = NSUserDefaults.standardUserDefaults().objectForKey("firedScheduleID") as? String {
            
            if let patientJSON = NSUserDefaults.standardUserDefaults().objectForKey("loggedInUser") as? String {                
                let patient = Mapper<User>().map(patientJSON)
                self.patientID = patient?.userId
                
                // medicine
                for medicine in patient!.medicines! {
                    if(medicine.id == Int(medicineID)){
                        self.medicine = medicine
                        break
                    }
                }
                
                // medicalSchedule
                for schedule in medicine.schedules {
                    if(schedule.id == Int(scheduleID)){
                        self.schedule = schedule
                        break
                    }
                }
            }
            
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "firedMedicineID")
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "firedScheduleID")
        }
        
        self.title = medicine.name;
        self.TimeLabel.text = schedule.time_s;
        if(schedule.updated_at != nil){
            if(schedule.updated_at!.sameDay(NSDate())){
                self.navigationItem.rightBarButtonItem?.enabled = false;
            }
        }
        
        if(!dateCheck(self.schedule.time!)){
            self.navigationItem.rightBarButtonItem?.enabled = false;
            
        }
        
        if(self.medicine.photo != nil){
            self.ImageView.image = self.medicine.photo;
        }
        else{
            self.ImageView.image = UIImage(named: "selectImage");
        }
        
        MRProgressOverlayView.showOverlayAddedTo(self.navigationController?.view, title: "Foto zoeken...", mode: .Indeterminate, animated: true) { response in
            MRProgressOverlayView.dismissOverlayForView(self.navigationController?.view, animated: true);
            Manager.sharedInstance.session.getAllTasksWithCompletionHandler { (tasks) -> Void in
                tasks.forEach({ $0.cancel() })
            }
        }
        
        if(self.navigationController==nil){
            print("woepsie")
            
        }
        
        print(Routes.showMedicine(patientID!, medicineId: self.medicine!.id!));
        Alamofire.request(.POST, Routes.showMedicine(patientID!, medicineId: self.medicine!.id!), parameters: ["api_token": Authentication.token!], headers: ["Accept": "application/json"]) .responseJSON { response in
            if(self.navigationController != nil){
                MRProgressOverlayView.dismissOverlayForView(self.navigationController!.view, animated: true);
            }
            if response.result.isSuccess {
                if let JSON = response.result.value {
                    if response.response?.statusCode == 200 {
                        //print(JSON);
                        let newMedicine = Mapper<Medicine>().map(JSON);
                        self.medicine.updateMedicineInfo(newMedicine!);
                        self.medicine.photo = newMedicine?.photo;
                        if(self.medicine.photo != nil){
                            self.ImageView.image = self.medicine.photo;
                        }
                        else{
                            self.ImageView.image = UIImage(named: "selectImage");
                        }
                        
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
        
        NameLabel.text = schedule.amount;
        InfoLabel.text = medicine.info;
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func dateCheck(date:NSDate)->Bool{
        let calendar = NSCalendar.currentCalendar()
        let hour = NSCalendar.currentCalendar().components([.Hour], fromDate: date).hour;
        let minutes = NSCalendar.currentCalendar().components([.Minute], fromDate: date).minute;
        let date1 = NSDate();
        let newDate = calendar.dateBySettingHour(hour, minute: minutes, second: 0, ofDate: date1, options: NSCalendarOptions())!
        let seconds = calendar.components([.Second], fromDate: newDate, toDate: NSDate(), options: []).second;
        if(seconds >= -3600 && seconds <= 3600){
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
            return 1;
        }else if(section == 1){
            return 3;
        }
        else{
            return 1;
        }
    }
    
    
    @IBAction func Pushed(sender: AnyObject) {
        PushedAction();
    }
    
    func PushedAction() {
        print("Pressed");
        MRProgressOverlayView.showOverlayAddedTo(self.navigationController?.view, title: "Innemen...", mode: .Indeterminate, animated: true) { response in
            MRProgressOverlayView.dismissOverlayForView(self.navigationController?.view, animated: true);
            Manager.sharedInstance.session.getAllTasksWithCompletionHandler { (tasks) -> Void in
                tasks.forEach({ $0.cancel() })
            }
            
        }
        
        Alamofire.request(.POST, Routes.createIntake(self.patientID!, scheduleId:self.schedule.id!), parameters: ["api_token": Authentication.token!], headers: ["Accept": "application/json"])
            .responseJSON {
                response in
                if response.result.isSuccess {
                    if let JSON = response.result.value {
                        print(JSON);
                        if response.response?.statusCode == 200 {
                            
                            MRProgressOverlayView.dismissOverlayForView(self.navigationController?.view, animated: true);
                            Alert.alertStatusWithSymbol(true,message:  "Innemen geslaagd!", seconds: 1.5,    view: self.view);
                            
                            self.navigationController?.popViewControllerAnimated(true);
                            
                        }else if response.response?.statusCode == 422 {
                            print("Ongeldig");
                            MRProgressOverlayView.dismissOverlayForView(self.navigationController?.view, animated: true);
                            Alert.alertStatusWithSymbol(false,message:  "Mislukt", seconds: 1.5,    view: self.view);
                        }
                    }else{
                        print("Ongeldige json response intake");
                        MRProgressOverlayView.dismissOverlayForView(self.navigationController?.view, animated: true);
                        Alert.alertStatusWithSymbol(false,message:  "Mislukt", seconds: 1.5, view:  self.view);
                    }
                }
                else
                {
                    print("Ongeldige request intake");
                    MRProgressOverlayView.dismissOverlayForView(self.navigationController?.view, animated: true);
                    Alert.alertStatusWithSymbol(false,message:  "Mislukt", seconds: 1.5, view: self.view);
                }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let Controller = segue.destinationViewController as? PatientShowImageController
        Controller!.image = ImageView.image;
        
        
    }    
}
