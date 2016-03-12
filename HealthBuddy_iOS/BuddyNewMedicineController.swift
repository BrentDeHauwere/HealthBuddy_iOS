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
    }

    var medicin:Medicine?
    var newMedicin = true;

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.loadForm();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //Formulier opvullen indien bestaande medicijn wordt geupdate
        if medicin != nil  {
            newMedicin = false;
            initForm()
        }else{
            newMedicin = true;
        }
    }
    
    func loadForm(){
        let form = FormDescriptor()
        var row: FormRowDescriptor!;
        
        let sectionMedicinInformation = FormSectionDescriptor();
        
        row = FormRowDescriptor(tag: FormTag.medicinName, rowType: .Text, title: "Naam");
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
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
        
        
        let row = FormRowDescriptor(tag: FormTag.medicinName, rowType: .Text, title: "Naam");
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        
        self.form.sections[0].addRow(row);
    }
    
   
    func initForm(){
        self.form.sections[0].rows[0].value = medicin?.name;
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveNewMedicine" {
            saveChanges();
        }
    }
    
    func saveChanges(){
        //TODO: update db
        if(newMedicin){
            medicin = Medicine();
        }
        medicin?.name = self.form.formValues()[FormTag.medicinName]!.description;
    }
}
