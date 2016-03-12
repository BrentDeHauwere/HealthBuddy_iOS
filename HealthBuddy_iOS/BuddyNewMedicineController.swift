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

        form.sections = [sectionMedicinInformation];
        
        self.form = form;
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
