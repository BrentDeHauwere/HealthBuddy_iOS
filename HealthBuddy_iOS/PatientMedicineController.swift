//
//  PatientMedicineController.swift
//  HealthBuddy_iOS
//
//  Created by Eli on 11/04/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit;
import Alamofire;
import ObjectMapper;

class PatientMedicineController: UITableViewController {
    var patient:User!;
    var medicinesToday:[Medicine]!;
    var medicinesVm:[MedicalSchedule]!;
    var medicinesM:[MedicalSchedule]!;
    var medicinesNm:[MedicalSchedule]!;
    var medicinesA:[MedicalSchedule]!;
    var sections:[String]!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.title = "Medicatie";
        
        sections = [String]();
        
        sections.append("Voormiddag");
        sections.append("Middag");
        sections.append("Namiddag");
        sections.append("Avond");
        
        
        //add medicines of today to arraylist
        self.medicines();
        let refreshControl = UIRefreshControl();
        refreshControl.addTarget(self, action: #selector(PatientMedicineController.refreshData), forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl);
    }
    
    override func viewDidAppear(animated: Bool){
        self.medicines();
        self.scheduleRefreshData();
        super.viewDidAppear(true);
    }
    
    func medicines(){
        medicinesToday = [Medicine]();
        medicinesVm = [MedicalSchedule]();
        medicinesM = [MedicalSchedule]();
        medicinesNm = [MedicalSchedule]();
        medicinesA = [MedicalSchedule]();
        var medicinesToTake = 0;
        print("called")
        for medicine in (patient?.medicines)! {
            var added = false
            for schedule in medicine.schedules {
                if NSDate().isBetweeen(date: schedule.start_date!, andDate: schedule.end_date!)
                    &&  (NSDate().daysSince1970() - schedule.start_date!.daysSince1970()) % schedule.interval! == 0 {
                    medicinesToTake += 1;
                    let calendar = NSCalendar.currentCalendar();
                    let comp = calendar.components([.Hour], fromDate: schedule.time!);
                    let hour = comp.hour;
                    
                    if(hour > 3 && hour <= 10){
                        medicinesVm.append(schedule);
                        if(added == false){
                            medicinesToday.append(medicine);
                            added = true;
                        }
                    }
                    else if(hour > 10 && hour <= 14){
                        medicinesM.append(schedule);
                        if(added == false){
                            medicinesToday.append(medicine);
                            added = true;
                        }
                    }
                    else if(hour > 14 && hour <= 17){
                        medicinesNm.append(schedule);
                        if(added == false){
                            medicinesToday.append(medicine);
                            added = true;
                        }
                    }
                    else if(hour > 17 || hour <= 3){
                        medicinesA.append(schedule);
                        if(added == false){
                            medicinesToday.append(medicine);
                            added = true;
                        }
                    }
                }
                
            }
        }
        
        medicinesVm.sortInPlace({$0.time!.compare($1.time!) == NSComparisonResult.OrderedAscending } );
        
        
        
        medicinesM.sortInPlace({$0.time!.compare($1.time!) == NSComparisonResult.OrderedAscending } );
        
        
        
        medicinesNm.sortInPlace({$0.time!.compare($1.time!) == NSComparisonResult.OrderedAscending } );
        
        
        
        
        medicinesA.sortInPlace({$0.time!.compare($1.time!) == NSComparisonResult.OrderedAscending } );
    }
    
    func scheduleRefreshData(){
        Alamofire.request(.POST, Routes.buddyProfile, parameters: ["api_token": Authentication.token!])
            .responseJSON { response in
                if response.result.isSuccess {
                    if let JSON = response.result.value {
                        let updatedUser = Mapper<User>().map(JSON);
                        self.patient.updateUserInfo(updatedUser!);
                        self.patient.medicines = updatedUser?.medicines;
                        self.medicines();
                        self.tableView.reloadData();
                        print("Data refreshed");
                    }
                }
        }
    }
    
    func refreshData(refreshControl : UIRefreshControl){
        Alamofire.request(.POST, Routes.buddyProfile, parameters: ["api_token": Authentication.token!])
            .responseJSON { response in
                if response.result.isSuccess {
                    if let JSON = response.result.value {
                        let updatedUser = Mapper<User>().map(JSON);
                        self.patient.updateUserInfo(updatedUser!);
                        self.patient.medicines = updatedUser?.medicines;
                        self.medicines();
                        self.tableView.reloadData();
                        refreshControl.endRefreshing();
                        print("Data refreshed");
                        
                        // refresh notifications
                        ToDoListController.updateMedicines(self.patient)
                    }
                }
                else{
                    refreshControl.endRefreshing();
                    Alert.alertStatusWithSymbol(false,message:  "Refreshen mislukt", seconds: 1.5,    view: self.view);
                    print("Data not refreshed");
                }
        }
    }
    
    func getMedicine(schedule:MedicalSchedule) -> Medicine! {
        var medicine : Medicine!;
        for medi in medicinesToday{
            if(medi.id == schedule.medicineId){
                medicine = medi;
            }
        }
        return medicine;
    }
    func backButtonPressed(sender:UIButton){
        navigationController?.popViewControllerAnimated(true);
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0;
        if(section == 0){
            count = self.medicinesVm.count;
        }
        if(section == 1){
            count =  self.medicinesM.count;
        }
        if(section == 2){
            count =  self.medicinesNm.count;
        }
        if(section == 3){
            count =  self.medicinesA.count;
        }
        return count;
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
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //GreenMedicineCell
        let cell = self.tableView.dequeueReusableCellWithIdentifier("MedicineCell", forIndexPath: indexPath) as UITableViewCell;
        
        let section = indexPath.section;
        if(section == 0){
            if(self.medicinesVm[indexPath.row].updated_at != nil){
                if(self.medicinesVm[indexPath.row].updated_at!.sameDay(NSDate())){
                    cell.backgroundColor = UIColor(red: 147/255, green: 203/255, blue: 80/255, alpha: 1);
                }
                else if(dateCheck(self.medicinesVm[indexPath.row].time!)){
                    cell.backgroundColor = UIColor(red: 214/255, green: 227/255, blue: 175/255, alpha: 1);
                    
                }
            }
            
            cell.textLabel?.text = (self.getMedicine(self.medicinesVm[indexPath.row]).name)!;
            cell.detailTextLabel?.text =  self.medicinesVm[indexPath.row].time_s;
        }
        if(section == 1){
            if(self.medicinesM[indexPath.row].updated_at != nil){
                if(self.medicinesM[indexPath.row].updated_at!.sameDay(NSDate())){
                    cell.backgroundColor = UIColor(red: 147/255, green: 203/255, blue: 80/255, alpha: 1);
                }
                else if(dateCheck(self.medicinesM[indexPath.row].time!)){
                    cell.backgroundColor = UIColor(red: 214/255, green: 227/255, blue: 175/255, alpha: 1);
                    
                }
            }
            
            cell.textLabel?.text = (self.getMedicine(self.medicinesM[indexPath.row]).name)!;
            cell.detailTextLabel?.text =  self.medicinesM[indexPath.row].time_s;
        }
        if(section == 2){
            if(self.medicinesNm[indexPath.row].updated_at != nil){
                if(self.medicinesNm[indexPath.row].updated_at!.sameDay(NSDate())){
                    cell.backgroundColor = UIColor(red: 147/255, green: 203/255, blue: 80/255, alpha: 1);
                }
                else if(dateCheck(self.medicinesNm[indexPath.row].time!)){
                    cell.backgroundColor = UIColor(red: 214/255, green: 227/255, blue: 175/255, alpha: 1);
                    
                }
            }
            
            cell.textLabel?.text =  (self.getMedicine(self.medicinesNm[indexPath.row]).name)!;
            cell.detailTextLabel?.text =  self.medicinesNm[indexPath.row].time_s;
        }
        if(section == 3){
            if(self.medicinesA[indexPath.row].updated_at != nil){
                if(self.medicinesA[indexPath.row].updated_at!.sameDay(NSDate())){
                    cell.backgroundColor = UIColor(red: 147/255, green: 203/255, blue: 80/255, alpha: 1);
                }
                else if(dateCheck(self.medicinesA[indexPath.row].time!)){
                    cell.backgroundColor = UIColor(red: 214/255, green: 227/255, blue: 175/255, alpha: 1);
                    
                }
            }
            
            cell.textLabel?.text =  (self.getMedicine(self.medicinesA[indexPath.row]).name)!;
            cell.detailTextLabel?.text =  self.medicinesA[indexPath.row].time_s;
        }
        return cell;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "notificationToMedicine" {
            if let Controller = segue.destinationViewController as? PatientTableShowMedicineController {
                
                if  let medicineID = NSUserDefaults.standardUserDefaults().objectForKey("firedMedicineID") as? String,
                    let scheduleID = NSUserDefaults.standardUserDefaults().objectForKey("firedScheduleID") as? String {
                    
                    if let patientJSON = NSUserDefaults.standardUserDefaults().objectForKey("loggedInUser") as? String {
                        print(patientJSON)
                        
                        patient = Mapper<User>().map(patientJSON)
                        
                        print(patient.description)
                        
                        // medicine
                        for medicine in patient.medicines! {
                            if(medicine.id == Int(medicineID)){
                                Controller.medicine = medicine
                                break
                            }
                        }
                        
                        // medicalSchedule
                        for schedule in Controller.medicine.schedules {
                            if(schedule.id == Int(scheduleID)){
                                Controller.schedule = schedule
                                break
                            }
                        }
                    }
                    
                }
                
                
                print("\(Controller.medicine.name) \(Controller.schedule.time_s)")
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "firedMedicineID")
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "firedScheduleID")
                
                Controller.patientID = self.patient.userId;
            }
        }
        
        if segue.identifier == "showMedicinePatient" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let Controller = segue.destinationViewController as? PatientTableShowMedicineController {
                    let section = indexPath.section;
                    if(section == 0){
                        Controller.medicine = self.getMedicine(self.medicinesVm[indexPath.row]);
                        Controller.schedule = self.medicinesVm[indexPath.row];
                    }
                    if(section == 1){
                        Controller.medicine =  self.getMedicine(self.medicinesM[indexPath.row]);
                        Controller.schedule = self.medicinesM[indexPath.row];
                    }
                    if(section == 2){
                        Controller.medicine =  self.getMedicine(self.medicinesNm[indexPath.row]);
                        Controller.schedule = self.medicinesNm[indexPath.row];
                    }
                    if(section == 3){
                        Controller.medicine =  self.getMedicine(self.medicinesA[indexPath.row]);
                        Controller.schedule = self.medicinesA[indexPath.row];
                    }
                    Controller.patientID = self.patient.userId;
                }
            }
        }
        
        
        
    }
}
