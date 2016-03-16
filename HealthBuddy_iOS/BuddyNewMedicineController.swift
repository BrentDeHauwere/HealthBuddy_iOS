//
//  BuddyNewMedicineController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 10/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//  Gebruik gemaakt van tutorial: https://www.raywenderlich.com/113394/storyboards-tutorial-in-ios-9-part-2

import UIKit;
import SwiftForms

class BuddyNewMedicineController: FormViewController {
    
    struct FormTag{
        static let medicinName = "medicinName";
        static let addSchedule = "addSchedule";
        static let houre = "houre";
        static let dayOfWeek = "dayOfWeek";
        static let amount = "amount";
        static let deleteSchedule = "deleteSchedule";
        static let selectPhoto = "selectPhoto";
    }

    var medicine:Medicine?
    var newMedicin = true;
    
    var scheduleSectionID = 0;
    var scheduleFormSections = [Int: FormSectionDescriptor]();
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.loadForm();
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addScheduleForm();

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
      
        var row = FormRowDescriptor(tag: "\(FormTag.houre)_\(self.scheduleSectionID)", rowType: .Time, title: "Uur");
        sectionNewSchedule.addRow(row);
        
        row = FormRowDescriptor(tag: "\(FormTag.dayOfWeek)_\(self.scheduleSectionID)", rowType: .MultipleSelector, title: "Herhaal")
        row.configuration[FormRowDescriptor.Configuration.Options] = [1, 2, 3, 4, 5,6,7]
        row.configuration[FormRowDescriptor.Configuration.AllowsMultipleSelection] = true
        row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] = { value in
            switch( value ) {
            case 1:
                return "Elke maandag"
            case 2:
                return "Elke dinsdag"
            case 3:
                return "Elke woensdag"
            case 4:
                return "Elke donderdag"
            case 5:
                return "Elke vrijdag"
            case 6:
                return "Elke zaterdag"
            case 7:
                return "Elke zondag"
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
        
        scheduleSectionID++;
        tableView.reloadData();
    }
    
    //TODO: remove schedule from db
    func deleteScheduleForm(sectionID:Int){
        let scheduleToRemove = scheduleFormSections[sectionID];
        let indexToRemove = self.form.sections.indexOf(scheduleToRemove!);
        self.form.sections.removeAtIndex(indexToRemove!);
    
        //update schedule titles
        for var i = 1; i < self.form.sections.count-1;i++ {
            self.form.sections[i].headerTitle = "Inname-moment \(i)";
        }
        
        tableView.reloadData();
        
        //REMOVE FROM DB
    }
    
   
    func initForm(){
        self.form.sections[0].rows[0].value = medicine?.name;
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveNewMedicine" {
            saveChanges();
        }else if segue.identifier == "showMedicinePicture" {
            let buddyMedicinePictureController = segue.destinationViewController as! BuddyMedicinePictureController;
            buddyMedicinePictureController.medicine = medicine;
        }
    }
    
    func saveChanges(){
        //TODO: update db

        medicine?.name = self.form.formValues()[FormTag.medicinName]!.description;
    }
}
