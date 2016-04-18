//
//  BuddyNewMedicineController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 10/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//  Gebruik gemaakt van tutorial: https://www.raywenderlich.com/113394/storyboards-tutorial-in-ios-9-part-2

import UIKit;
import Alamofire
import SwiftForms
import MRProgress
import ObjectMapper

class BuddyNewMedicineController: FormViewController {
    
    struct FormTag{
        static let name = "name";
        static let info = "info";
        static let addSchedule = "addSchedule";
        static let time = "time";
        static let interval = "interval";
        static let amount = "amount";
        static let deleteSchedule = "deleteSchedule";
        static let selectPhoto = "selectPhoto";
        static let start_date = "start_date";
        static let end_date = "end_date";
    }

    var medicine:Medicine?
    var patientId:Int?
    var newMedicin = true;
    var savedMedicin = false;
    var annulateBtnPressed = false;
    
    //Hou elk section bij met unieke ID
    var scheduleSectionID = 0;
    var scheduleFormSections = [Int: FormSectionDescriptor]();
    
    //Hou van elke section bij of deze section nieuw of alreeds bestaat
    var scheduleFormSectionsNewState = [Int: Bool]();
    
    //Hou van elke sectionID de scheduleID bij
    var sectionScheduleID = [Int:Int]();
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.loadForm();
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Formulier opvullen indien bestaande medicijn wordt geupdate
        if medicine != nil  {
            newMedicin = false;
            self.navigationItem.title = "Wijzig \((self.medicine?.name)!)";
            initForm()
        }else{
            newMedicin = true;
            medicine = Medicine();
            self.navigationItem.title = "Nieuw medicijn";
        }
    }
    
    func loadForm(){
        let form = FormDescriptor()
        var row: FormRowDescriptor!;
        
        let sectionMedicinInformation = FormSectionDescriptor();
        
        row = FormRowDescriptor(tag: FormTag.name, rowType: .Text, title: "Naam");
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionMedicinInformation.addRow(row);
        
        row = FormRowDescriptor(tag: FormTag.info, rowType: .MultilineText, title: "Info");
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionMedicinInformation.addRow(row);
        
        row = FormRowDescriptor(tag: FormTag.selectPhoto, rowType: .Button, title: "Foto")
        if medicine?.photo != nil {
            row.title = "Toon foto";
        }
        row.configuration[FormRowDescriptor.Configuration.DidSelectClosure] = {
            self.performSegueWithIdentifier("showMedicinePicture", sender: self);
            } as DidSelectClosure
        sectionMedicinInformation.addRow(row);

        
        let addNewScheduleSection = FormSectionDescriptor();
        row = FormRowDescriptor(tag: FormTag.addSchedule, rowType: .Button, title: "Voeg innamemoment toe")
        row.configuration[FormRowDescriptor.Configuration.DidSelectClosure] = {
            self.addScheduleForm();
            } as DidSelectClosure
        addNewScheduleSection.addRow(row);
        
        form.sections = [sectionMedicinInformation, addNewScheduleSection];
        self.form = form;
    }
    
    func addScheduleForm(){
        let sectionNewSchedule = FormSectionDescriptor();
        sectionNewSchedule.headerTitle = "Inname-moment \(self.form.sections.count-1)";
      
        var row = FormRowDescriptor(tag: "\(FormTag.time)_\(self.scheduleSectionID)", rowType: .Time, title: "Uur");
        row.value = NSDate();
        sectionNewSchedule.addRow(row);
        
        row = FormRowDescriptor(tag: "\(FormTag.start_date)_\(self.scheduleSectionID)", rowType: .Date, title: "Start inname");
        let today = NSDate();
        var tomorrow = today.dateByAddingTimeInterval(60*60*24);
        row.value = tomorrow;
        sectionNewSchedule.addRow(row);
        
        
        row = FormRowDescriptor(tag: "\(FormTag.end_date)_\(self.scheduleSectionID)", rowType: .Date, title: "Stop inname");
        tomorrow = tomorrow.dateByAddingTimeInterval(60*60*24)
        row.value = tomorrow;
        sectionNewSchedule.addRow(row);
        
        row = FormRowDescriptor(tag: "\(FormTag.interval)_\(self.scheduleSectionID)", rowType: .MultipleSelector, title: "Interval")
        row.configuration[FormRowDescriptor.Configuration.Options] = [1,2,3,7,14]
       // row.configuration[FormRowDescriptor.Configuration.AllowsMultipleSelection] = true
        row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] = { value in
            switch( value ) {
            case 1:
                return "Elke dag"
            case 2:
                return "Elke  twee dagen"
            case 3:
                return "Elke drie dagen"
            case 7:
                return "Elke week"
            case 14:
                return "Elke twee weken"
            default:
                return nil
            }
            } as TitleFormatterClosure
        row.value = 1;
        sectionNewSchedule.addRow(row)
        
        row = FormRowDescriptor(tag: "\(FormTag.amount)_\(self.scheduleSectionID)", rowType: .Text, title: "Hoeveelheid");
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionNewSchedule.addRow(row);
        
        
        
        row = FormRowDescriptor(tag: "\(FormTag.deleteSchedule)_\(self.scheduleSectionID)", rowType: .Button, title: "Verwijder inname-moment")
        row.configuration[FormRowDescriptor.Configuration.DidSelectClosure] = {
            
            //Create the AlertController
            let actionSheetController: UIAlertController = UIAlertController(title: "Verwijder innamemoment", message: "Bevestig", preferredStyle: .ActionSheet)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil);
            actionSheetController.addAction(cancelAction)
            
            let doAction: UIAlertAction = UIAlertAction(title: "Verwijder", style: .Destructive) { action -> Void in
                let delimiter = "_";
                var split = row.tag.componentsSeparatedByString(delimiter);
                let sectionID = Int(split[1])!;
                self.deleteScheduleForm(sectionID);
            }
            actionSheetController.addAction(doAction);
        
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
           
            } as DidSelectClosure
        sectionNewSchedule.addRow(row);

        scheduleFormSections[scheduleSectionID] = sectionNewSchedule;
        self.scheduleFormSectionsNewState[scheduleSectionID] = true;
        
        self.form.sections.insert(sectionNewSchedule, atIndex: self.form.sections.count-1);
        
        scheduleSectionID += 1;
        tableView.reloadData();
    }
    
    //TODO: remove schedule from db
    func deleteScheduleForm(sectionID:Int){
        if(self.medicine?.id != nil){
            if let scheduleID =  self.sectionScheduleID[sectionID]{
                deleteSchedule(scheduleID, medicineId: (self.medicine?.id)!);
            }
        }
        
        let scheduleToRemove = scheduleFormSections[sectionID];
        let indexToRemove = self.form.sections.indexOf(scheduleToRemove!);
        self.form.sections.removeAtIndex(indexToRemove!);
        scheduleFormSections.removeValueForKey(sectionID);
        scheduleFormSectionsNewState.removeValueForKey(sectionID);
    
        //update schedule titles
        for i in 1 ..< self.form.sections.count-1 {
            self.form.sections[i].headerTitle = "Inname-moment \(i)";
        }

        tableView.reloadData();
    }
    
   
    func initForm(){
        self.form.sections[0].rows[0].value = medicine?.name;
        self.form.sections[0].rows[1].value = medicine?.info;
        
        
        if let numberOfSchedules = self.medicine?.schedules.count {
            for i in 0 ..< numberOfSchedules  {
                self.addScheduleForm();
                self.scheduleFormSectionsNewState[(scheduleSectionID-1)] = false;
                self.sectionScheduleID[(scheduleSectionID-1)] = self.medicine?.schedules[i].id;
                self.form.sections[i+1].rows[0].value = self.medicine?.schedules[i].time;
                self.form.sections[i+1].rows[1].value = self.medicine?.schedules[i].start_date;
                self.form.sections[i+1].rows[2].value = self.medicine?.schedules[i].end_date;
                self.form.sections[i+1].rows[3].value = self.medicine?.schedules[i].interval;
                self.form.sections[i+1].rows[4].value = self.medicine?.schedules[i].amount;
            }
        }
    }
    
   
    @IBAction func clickSave(sender: AnyObject) {
        MRProgressOverlayView.showOverlayAddedTo(self.navigationController?.view, title: "Gegevens bewaren...", mode: .Indeterminate, animated: true) { response in
            self.annulateBtnPressed = true;
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true);
            Manager.sharedInstance.session.getAllTasksWithCompletionHandler { (tasks) -> Void in
                tasks.forEach({ $0.cancel() })
            }
        }
        if(newMedicin){
            if(savedMedicin){
                storeMedicin(Routes.updateMedicine(self.patientId!, medicineId: self.medicine!.id!))
            }else{
                storeMedicin(Routes.createMedicine(self.patientId!));
            }
        }else{
            storeMedicin(Routes.updateMedicine(self.patientId!, medicineId: self.medicine!.id!))
        }

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMedicinePicture" {
            let buddyMedicinePictureController = segue.destinationViewController as! BuddyMedicinePictureController;
            buddyMedicinePictureController.medicine = medicine;
        }
    }
    
    func storeMedicin(Route:String){
      //  let imageData = UIImageJPEGRepresentation((self.medicine?.photo!)!, 1);
      //   let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
      //  print(base64String);
        
        let medicineGroup = dispatch_group_create()
        var errors = [String]();
        
        dispatch_group_enter(medicineGroup)
        Alamofire.request(.POST, Route, parameters: ["api_token": Authentication.token!, FormTag.name: self.form.formValues()[FormTag.name]!.description, FormTag.info: self.form.formValues()[FormTag.info]!.description], headers: ["Accept": "application/json"]) .responseJSON { response in
            print(response.result.value);
            if response.result.isSuccess {
                if let JSON = response.result.value {
                    print(JSON);
                    if response.response?.statusCode == 200 {
                        self.medicine = Mapper<Medicine>().map(JSON);
                        print("Medicine toegevoegd");
                    }else if response.response?.statusCode == 422 {
                        print("No valid input given");
                        let JSONDict = JSON as! NSDictionary as NSDictionary;
                        for (_, value) in JSONDict {
                            let errorsArray = value as! NSArray;
                            for (error) in errorsArray {
                                errors.append("\(error)");
                            }
                        }
                        errors.append("\n");
                    }
                }else{
                    print("Ongeldige json response medicine");
                }
            }else{
                print("Ongeldige request medicine");
            }
            dispatch_group_leave(medicineGroup)
        }
    
        dispatch_group_notify(medicineGroup, dispatch_get_main_queue()) {
            if self.annulateBtnPressed {
                errors.append("Opslaan geannuleerd");
                self.annulateBtnPressed = false;
            }
            
            if errors.count <= 0 {
                self.savedMedicin = true;
                if(self.scheduleFormSections.count>0){
                    self.storeSchedules();
                }else{
                    Alert.alertStatusWithSymbol(true, message: "Medicatie opgeslaan", seconds: 1.5, view: self.navigationController!.view);
                    let delay = 1.5 * Double(NSEC_PER_SEC)
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("goToSaveNewMedicine", sender: self);
                    });
                }
            } else {
                MRProgressOverlayView.dismissOverlayForView(self.navigationController!.view, animated: true);
                Alert.alertStatusWithSymbol(false, message: "Medicatie opslaan mislukt", seconds: 1.5, view: self.navigationController!.view);
                let delay = 1.5 * Double(NSEC_PER_SEC)
                let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    Alert.alertStatus(errors.joinWithSeparator("\n"), title: "Ongeldige invoer: ", view: self);
                });
            }
        }
    }
    
    func storeSchedules(){
        var group = dispatch_group_create()
        var errors = [String]();
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd";
        
        let timeFormatter = NSDateFormatter();
        timeFormatter.dateFormat = "HH:mm:ss";

        var i = 0;
        for(sectionID, _) in self.scheduleFormSections {
            i += 1;
            let currentI = i;
            var storeScheduleRoute = "";
            if let newSchedule:Bool = self.scheduleFormSectionsNewState[sectionID]! {
                if(newSchedule){
                    storeScheduleRoute = Routes.createSchedule(self.patientId!, medicineId: (self.medicine?.id)!);
                }
                else
                {
                    storeScheduleRoute = Routes.updateScheudle(self.patientId!, medicineId: (self.medicine?.id)!, scheduleId:self.sectionScheduleID[sectionID]!);
                }
                
                var interval = self.form.formValues()["\(FormTag.interval)_\(sectionID)"]!.description;
                interval = interval.componentsSeparatedByCharactersInSet(
                    NSCharacterSet
                        .decimalDigitCharacterSet()
                        .invertedSet)
                    .joinWithSeparator("")
                dispatch_group_enter(group);
                Alamofire.request(.POST, storeScheduleRoute, parameters: ["api_token": Authentication.token!, FormTag.time : timeFormatter.stringFromDate(self.form.formValues()["\(FormTag.time)_\(sectionID)"] as! NSDate),  FormTag.amount: self.form.formValues()["\(FormTag.amount)_\(sectionID)"]!.description, FormTag.start_date: dateFormatter.stringFromDate(self.form.formValues()["\(FormTag.start_date)_\(sectionID)"] as! NSDate), FormTag.end_date: dateFormatter.stringFromDate(self.form.formValues()["\(FormTag.end_date)_\(sectionID)"] as! NSDate), FormTag.interval: Int(interval)!], headers: ["Accept": "application/json"]) .responseJSON { response in
                    dispatch_group_leave(group);
                    if response.result.isSuccess {
                        if let JSON = response.result.value {
                            print(JSON);
                            if response.response?.statusCode == 200 {
                                if(newSchedule){
                                    print("schedule toegevoegd");
                                    let newSchedule = Mapper<MedicalSchedule>().map(JSON);
                                    self.medicine?.schedules.append(newSchedule!);
                                }else{
                                    let updatedSchedule = Mapper<MedicalSchedule>().map(JSON);
                                    if let numberOfSchedules = self.medicine?.schedules.count {
                                        print("Number of schedules: \(numberOfSchedules)");
                                        //TODO: waarom 0 als result?
                                        for i in 0 ..< numberOfSchedules  {
                                            print("\(self.medicine?.schedules[i].id) == \(updatedSchedule?.id)")
                                            if(self.medicine?.schedules[i].id == updatedSchedule?.id){
                                                print("Schedule met ID \(self.medicine?.schedules[i].id) vervangen");
                                                self.medicine?.schedules[i] = updatedSchedule!;
                                            }
                                        }
                                    }
                                    print("Schedule updated");
                                }

                            }else if response.response?.statusCode == 422 {
                                print("No valid input given");
                                let JSONDict = JSON as! NSDictionary as NSDictionary;
                                for (_, value) in JSONDict {
                                    let errorsArray = value as! NSArray;
                                    
                                    errors.append("Inname-moment \(currentI): ");
                                    for (error) in errorsArray {
                                        errors.append("\(error)");
                                    }
                                }
                                errors.append("\n");
                            }
                        }else{
                            print("Ongeldige json response schedule");
                        }
                    }
                    else
                    {
                        print("Ongeldige request schedule");
                    }
                }
            }
        }

        dispatch_group_notify(group, dispatch_get_main_queue()) {
            MRProgressOverlayView.dismissOverlayForView(self.navigationController!.view, animated: true);
                
            if self.annulateBtnPressed {
                errors.append("Opslaan geannuleerd");
            }
                
            if errors.count <= 0 {
                Alert.alertStatusWithSymbol(true, message: "Medicatie opgeslaan", seconds: 1.5, view: self.navigationController!.view);
                let delay = 1.5 * Double(NSEC_PER_SEC)
                let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("goToSaveNewMedicine", sender: self);
                });
            } else {
                Alert.alertStatusWithSymbol(false, message: "Medicatie opslaan mislukt", seconds: 1.5, view: self.navigationController!.view);
                let delay = 1.5 * Double(NSEC_PER_SEC)
                let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    Alert.alertStatus(errors.joinWithSeparator("\n"), title: "Ongeldige invoer: ", view: self);
                });
            }
        }
    }
    
    func deleteSchedule(scheduleId: Int, medicineId:Int){
        Alamofire.request(.POST, Routes.deleteSchedule(self.patientId!, medicineId: medicineId, scheduleId: scheduleId), parameters: ["api_token": Authentication.token!], headers: ["Accept": "application/json"]) .responseString { response in
            print("Verwijder schedule \(scheduleId)")
            print(response);
        }
    }
    
}
