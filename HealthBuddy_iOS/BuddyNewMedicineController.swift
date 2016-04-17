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
        static let medicinName = "medicinName";
        static let info = "info";
        static let addSchedule = "addSchedule";
        static let houre = "houre";
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
    var annulateBtnPressed = false;
    
    var scheduleSectionID = 0;
    var scheduleFormSections = [Int: FormSectionDescriptor]();
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.loadForm();
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Formulier opvullen indien bestaande medicijn wordt geupdate
        if medicine != nil  {
            newMedicin = false;
            self.navigationItem.title = "Wijzig medicijn";
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
        
        row = FormRowDescriptor(tag: FormTag.medicinName, rowType: .Text, title: "Naam");
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
      
        var row = FormRowDescriptor(tag: "\(FormTag.houre)_\(self.scheduleSectionID)", rowType: .Text, title: "Uur");
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionNewSchedule.addRow(row);
        
        row = FormRowDescriptor(tag: "\(FormTag.start_date)_\(self.scheduleSectionID)", rowType: .Date, title: "Start inname");
        sectionNewSchedule.addRow(row);
        
        row = FormRowDescriptor(tag: "\(FormTag.end_date)_\(self.scheduleSectionID)", rowType: .Date, title: "Stop inname");
        sectionNewSchedule.addRow(row);
        
        row = FormRowDescriptor(tag: "\(FormTag.interval)_\(self.scheduleSectionID)", rowType: .MultipleSelector, title: "Herhaal")
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
        
        sectionNewSchedule.addRow(row)
        
        row = FormRowDescriptor(tag: "\(FormTag.amount)_\(self.scheduleSectionID)", rowType: .Text, title: "Dosis");
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
        self.form.sections.insert(sectionNewSchedule, atIndex: self.form.sections.count-1);
        
        scheduleSectionID += 1;
        tableView.reloadData();
    }
    
    //TODO: remove schedule from db
    func deleteScheduleForm(sectionID:Int){
        let scheduleToRemove = scheduleFormSections[sectionID];
        let indexToRemove = self.form.sections.indexOf(scheduleToRemove!);
        self.form.sections.removeAtIndex(indexToRemove!);
    
        //update schedule titles
        for i in 1 ..< self.form.sections.count-1 {
            self.form.sections[i].headerTitle = "Inname-moment \(i)";
        }
        
        tableView.reloadData();
        
        //REMOVE FROM DB
    }
    
   
    func initForm(){
        self.form.sections[0].rows[0].value = medicine?.name;
        self.form.sections[0].rows[1].value = medicine?.info;
        
        if let numberOfSchedules = self.medicine?.schedules.count {
            for i in 0 ..< numberOfSchedules  {
                self.addScheduleForm();
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
            saveMedicine();
        }else{
            updateChanges();
        }

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMedicinePicture" {
            let buddyMedicinePictureController = segue.destinationViewController as! BuddyMedicinePictureController;
            buddyMedicinePictureController.medicine = medicine;
        }
    }
    
    func saveMedicine(){
        let group = dispatch_group_create()
        var errors = [String]();
        
        dispatch_group_enter(group)

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd";
        
        Alamofire.request(.POST, Routes.createMedicine(self.patientId!), parameters: ["api_token": Authentication.token!, "name": self.form.formValues()[FormTag.medicinName]!.description, FormTag.info: self.form.formValues()[FormTag.info]!.description], headers: ["Accept": "application/json"]) .responseJSON { response in
                if response.result.isSuccess {
                    if let JSON = response.result.value {
                        print(JSON);
                        if response.response?.statusCode == 200 {
                            let newMedicine = Mapper<Medicine>().map(JSON);
                            self.medicine?.updateMedicineInfo(newMedicine!);
                            print("Medicine toegevoegd");
                        }else if response.response?.statusCode == 422 {
                            print("No valid input given");
                            let JSONDict = JSON as! NSDictionary as NSDictionary;
                            for (_, value) in JSONDict {
                                let errorsArray = value as! NSArray;
                                for (error) in errorsArray {
                                    errors.append("\(error)");
                                    print(error);
                                }
                            }
                            errors.append("\n");
                        }
                    }else{
                        print("Ongeldige json response medicine creation");
                    }
                }else{
                    print("Ongeldige request medicine creation");
                }
                dispatch_group_leave(group)
            }
    
            dispatch_group_notify(group, dispatch_get_main_queue()) {
                print("I WAS HERE");
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

    func updateChanges(){
        
    }
}
