//
//  PatientMedicineController.swift
//  HealthBuddy_iOS
//
//  Created by Eli on 11/04/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit;
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
        medicinesToday = [Medicine]();
        medicinesVm = [MedicalSchedule]();
        medicinesM = [MedicalSchedule]();
        medicinesNm = [MedicalSchedule]();
        medicinesA = [MedicalSchedule]();
        sections = [String]();
        //add medicines of today to arraylist
        for medicine in (patient?.medicines)! {
            var added = false
            for schedule in medicine.schedules {
                if NSDate().isBetweeen(date: schedule.start_date!, andDate: schedule.end_date!)
                    &&  (NSDate().daysSince1970() - schedule.start_date!.daysSince1970()) % schedule.interval! == 0 {
                    
                    let calendar = NSCalendar.currentCalendar();
                    let comp = calendar.components([.Hour], fromDate: schedule.time!);
                    let hour = comp.hour;
                    
                    if(hour > 3 && hour <= 10){
                        medicinesVm.append(schedule);
                        if(added == false){
                            medicinesToday.append(medicine);
                            print(medicine.name);
                            added = true;
                        }
                    }
                    else if(hour > 10 && hour <= 14){
                        medicinesM.append(schedule);
                        if(added == false){
                            medicinesToday.append(medicine);
                            print(medicine.name);
                            added = true;
                        }
                    }
                    else if(hour > 14 && hour <= 17){
                        medicinesNm.append(schedule);
                        if(added == false){
                            medicinesToday.append(medicine);
                            print(medicine.name);
                            added = true;
                        }
                    }
                    else if(hour > 18 && hour <= 3){
                        medicinesA.append(schedule);
                        if(added == false){
                            medicinesToday.append(medicine);
                            print(medicine.name);
                            added = true;
                        }
                    }
                }
                
            }
        }
        
        sections.append("Voormiddag");
        sections.append("Middag");
        sections.append("Namiddag");
        sections.append("Avond");
        
        for medicine in medicinesToday {
             print((medicine.name)!);
        }
        
        
    }
    func getMedicine(schedule:MedicalSchedule) -> Medicine! {
        var medicine : Medicine!;
        for medi in medicinesToday{
            print("\(schedule.medicineId) == \(medi.id)");
            if(medi.id == schedule.medicineId){
                
                medicine = medi;
            }
        }
        print((medicine.name)!);
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
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("MedicineCell", forIndexPath: indexPath) as UITableViewCell;
        let section = indexPath.section;
        if(section == 0){
            cell.textLabel?.text = (self.getMedicine(self.medicinesVm[indexPath.row]).name)!;
            cell.detailTextLabel?.text =  self.medicinesVm[indexPath.row].time_s;
        }
        if(section == 1){
            cell.textLabel?.text = (self.getMedicine(self.medicinesM[indexPath.row]).name)!;
            cell.detailTextLabel?.text =  self.medicinesM[indexPath.row].time_s;
        }
        if(section == 2){
            cell.textLabel?.text =  (self.getMedicine(self.medicinesNm[indexPath.row]).name)!;
            cell.detailTextLabel?.text =  self.medicinesNm[indexPath.row].time_s;
        }
        if(section == 3){
            cell.textLabel?.text =  (self.getMedicine(self.medicinesA[indexPath.row]).name)!;
            cell.detailTextLabel?.text =  self.medicinesA[indexPath.row].time_s;
        }
        return cell;
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMedicinePatient" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let Controller = segue.destinationViewController as? PatientShowMedicineController {
                    let section = indexPath.section;
                    if(section == 0){
                        
                        Controller.medicine = self.getMedicine(self.medicinesVm[indexPath.row]);
                        Controller.schedule = self.medicinesVm[indexPath.row];
                    }
                    if(section == 1){
                        print("\(self.getMedicine(self.medicinesVm[indexPath.row]))");
                        Controller.medicine =  self.getMedicine(self.medicinesM[indexPath.row]);
                        Controller.schedule = self.medicinesM[indexPath.row];
                    }
                    if(section == 2){
                        print("\(self.getMedicine(self.medicinesVm[indexPath.row]))");
                        Controller.medicine =  self.getMedicine(self.medicinesNm[indexPath.row]);
                        Controller.schedule = self.medicinesNm[indexPath.row];
                    }
                    if(section == 3){
                        print("\(self.getMedicine(self.medicinesVm[indexPath.row]))");
                        Controller.medicine =  self.getMedicine(self.medicinesA[indexPath.row]);
                        Controller.schedule = self.medicinesA[indexPath.row];
                    }
                    Controller.patientID = self.patient.userId;
                }
            }
        }
        
    }
    
    
}
