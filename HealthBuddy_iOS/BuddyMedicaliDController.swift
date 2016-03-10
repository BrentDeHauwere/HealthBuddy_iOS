//
//  PatientMedicaliDController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 7/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import SwiftForms



class BuddyMedicaliDController: FormViewController {
    var patient:User!;
    
    @IBOutlet weak var lblMedicalID: UILabel!
    
  
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.loadForm();
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        lblMedicalID.text = "Medisch ID";
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(named:"Menu"), style:.Plain, target:self, action:"backButtonPressed:");
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Opslaan", style: .Plain, target: self, action: "submit:")
        self.navigationItem.title = "\(patient.firstName) \(patient.lastName)";
    }
    
    func backButtonPressed(sender:UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func submit(sender:UIButton){
        //TODO: update database
        print("Pushed save button");
    }
    
    func loadForm(){
        // Create form instace
        let form = FormDescriptor()
        var row: FormRowDescriptor!;
        
        // Define section with personal info
        let sectionPersonalInfo = FormSectionDescriptor();
        sectionPersonalInfo.headerTitle = "Persoonlijke gegevens";
        
        row = FormRowDescriptor(tag: "Geslacht", rowType: .Picker, title: "Geslacht")
 
        row.configuration[FormRowDescriptor.Configuration.Options] = ["M", "V"]
        row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] = { value in
            switch( value ) {
            case "M":
                return "Man"
            case "V":
                return "Vrouw"
            default:
                return nil
            }
            } as TitleFormatterClosure
        
        row.value = "M"
        
        sectionPersonalInfo.addRow(row)

        
        row = FormRowDescriptor(tag: "Voornaam", rowType: .Text, title: "Voornaam");
        sectionPersonalInfo.addRow(row);
        
        row = FormRowDescriptor(tag: "Achternaam", rowType: .Text, title: "Achternaam");
        sectionPersonalInfo.addRow(row);
        
        row = FormRowDescriptor(tag: "Geboortedatum", rowType: .Date, title: "Geboortedatum")
        sectionPersonalInfo.addRow(row);
        
        
        //Define address

        let sectionAddress = FormSectionDescriptor();
        sectionAddress.headerTitle = "Adres";
        
        row = FormRowDescriptor(tag: "Straat", rowType: .Text, title: "Straat");
        sectionAddress.addRow(row);
        
        row = FormRowDescriptor(tag: "Huisnummer", rowType: .Number, title: "Huisnummer");
        sectionAddress.addRow(row);
        
        row = FormRowDescriptor(tag: "Postcode", rowType: .Text, title: "Postcode");
        sectionAddress.addRow(row);
        
        row = FormRowDescriptor(tag: "Gemeente", rowType: .Text, title: "Gemeente");
        sectionAddress.addRow(row);
        
        row = FormRowDescriptor(tag: "Land", rowType: .Text, title: "Land");
        sectionAddress.addRow(row);
        
        
        //Define medical info
        let sectionMedicalInfo = FormSectionDescriptor();
        sectionMedicalInfo.headerTitle = "Medische info";
        
        row = FormRowDescriptor(tag: "Lengte", rowType: .Number, title: "Lengte");
        sectionMedicalInfo.addRow(row);
        
        row = FormRowDescriptor(tag: "Gewicht", rowType: .Number, title: "Gewicht");
        sectionMedicalInfo.addRow(row);
        
        row = FormRowDescriptor(tag: "Bloedgroep", rowType: .Picker, title: "Bloedgroep")
        row.configuration[FormRowDescriptor.Configuration.Options] = ["","A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
        sectionMedicalInfo.addRow(row);

        
        let sectionAllergics = FormSectionDescriptor();
        sectionAllergics.headerTitle = "Allergieën en reacties";
        row = FormRowDescriptor(tag: "Allergieën en reacties", rowType: .MultilineText, title: "");
        sectionAllergics.addRow(row);
        
        let sectionMedicalController = FormSectionDescriptor();
        sectionMedicalController.headerTitle = "Medische aandoeningen";
        row = FormRowDescriptor(tag: "Medische aandoeningen", rowType: .MultilineText, title: "");
        sectionMedicalController.addRow(row);
        
        form.sections = [sectionPersonalInfo,sectionAddress, sectionMedicalInfo, sectionAllergics, sectionMedicalController];
        
        self.form = form
    }
    
    
}