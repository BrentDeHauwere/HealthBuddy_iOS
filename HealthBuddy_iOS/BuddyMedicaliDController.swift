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
    var editPatient:User!;
    
    var addressUpdated = false;
    var medicalInfoUpdated = false;
    
    @IBOutlet weak var lblMedicalID: UILabel!
    
    struct formTag{
        static let geslacht = "geslacht";
        static let voornaam = "voornaam";
        static let naam = "naam";
        static let geboortedatum = "geboortedatum";
        static let phone = "phone";
        static let straat = "straat";
        static let huisnummer = "huisnummer";
        static let postcode = "postcode";
        static let gemeeente = "gemeente";
        static let land = "land";
        static let lengte = "lengte";
        static let gewicht = "gewicht";
        static let bloedgroep = "bloedgroep";
        static let allergieën = "allergieën";
        static let medischeAandoeningen = "medischeAandoeningen";
        static let stopWijzigen = "stopWijzigen";
    }
  
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.loadForm();
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad();
        hideKeyboardOnHeaderTab();
        
        lblMedicalID.text = "Medisch ID";
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(named:"Menu"), style:.Plain, target:self, action:"backButtonPressed:");
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Opslaan", style: .Plain, target: self, action: "submit:")
        self.navigationItem.title = "\(patient.firstName!) \(patient.lastName!)";
        
        self.initForm();
        
    }
    
    func hideKeyboardOnHeaderTab(){
        self.navigationController!.navigationBar.userInteractionEnabled = true;
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "click:");
        tapGestureRecognizer.numberOfTapsRequired=1;
        self.navigationController!.navigationBar.addGestureRecognizer(tapGestureRecognizer);
    }
    
    func click(sender: UILabel){
        self.view.endEditing(true);
    }

    
    func loadForm(){
        // Create form instace
        let form = FormDescriptor()
        var row: FormRowDescriptor!;
        
        // Define section with personal info
        let sectionPersonalInfo = FormSectionDescriptor();
        sectionPersonalInfo.headerTitle="Persoonlijke informatie"
        row = FormRowDescriptor(tag: formTag.geslacht, rowType: .Picker, title: "Geslacht")
 
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

        
        row = FormRowDescriptor(tag: formTag.voornaam, rowType: .Text, title: "Voornaam");
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue];

        
        sectionPersonalInfo.addRow(row);
        
        row = FormRowDescriptor(tag: formTag.naam, rowType: .Text, title: "Naam");
         row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionPersonalInfo.addRow(row);
        
        
        row = FormRowDescriptor(tag: formTag.geboortedatum, rowType: .Date, title: "Geboortedatum")
        sectionPersonalInfo.addRow(row);
        
        row = FormRowDescriptor(tag: formTag.phone, rowType: .Phone, title: "Telefoonnummer")
         row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionPersonalInfo.addRow(row)
        
        //Define address

        let sectionAddress = FormSectionDescriptor();
        sectionAddress.headerTitle = "Adres";
        
        row = FormRowDescriptor(tag: formTag.straat, rowType: .Text, title: "Straat");
         row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionAddress.addRow(row);
        
        row = FormRowDescriptor(tag: formTag.huisnummer, rowType: .Number, title: "Huisnummer");
         row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionAddress.addRow(row);
        
        row = FormRowDescriptor(tag: formTag.postcode, rowType: .Text, title: "Postcode");
         row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionAddress.addRow(row);
        
        row = FormRowDescriptor(tag: formTag.gemeeente, rowType: .Text, title: "Gemeente");
         row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionAddress.addRow(row);
        
        row = FormRowDescriptor(tag: formTag.land, rowType: .Text, title: "Land");
         row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionAddress.addRow(row);
        
        
        //Define medical info
        let sectionMedicalInfo = FormSectionDescriptor();
        sectionMedicalInfo.headerTitle = "Medische info";
        
        row = FormRowDescriptor(tag: formTag.lengte, rowType: .Number, title: "Lengte");
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionMedicalInfo.addRow(row);
        
        row = FormRowDescriptor(tag: formTag.gewicht, rowType: .Number, title: "Gewicht");
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionMedicalInfo.addRow(row);
        
        row = FormRowDescriptor(tag: formTag.bloedgroep, rowType: .Picker, title: "Bloedgroep")
        row.configuration[FormRowDescriptor.Configuration.Options] = ["","A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
        row.value="";
       
        sectionMedicalInfo.addRow(row);

        
        let sectionAllergics = FormSectionDescriptor();
        sectionAllergics.headerTitle = "Allergieën en reacties";
        row = FormRowDescriptor(tag: formTag.allergieën, rowType: .MultilineText, title: "");
        sectionAllergics.addRow(row);
        
        let sectionMedicalController = FormSectionDescriptor();
        sectionMedicalController.headerTitle = "Medische aandoeningen";
        row = FormRowDescriptor(tag: formTag.medischeAandoeningen, rowType: .MultilineText, title: "");
        sectionMedicalController.addRow(row);
        
        
        form.sections = [sectionPersonalInfo,sectionAddress, sectionMedicalInfo, sectionAllergics, sectionMedicalController];
        
        self.form = form
    }
    
    //Initiating the form values with the patient object
    func initForm(){
        self.form.sections[0].rows[0].value = patient.gender;
        self.form.sections[0].rows[1].value = patient.firstName;
        self.form.sections[0].rows[2].value = patient.lastName;
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(patient.dateOfBirth!);
        self.form.sections[0].rows[3].value = date;

        self.form.sections[1].rows[0].value = patient.address?.street;
        self.form.sections[1].rows[1].value = patient.address?.streetNumber;
        self.form.sections[1].rows[2].value = patient.address?.zipCode;
        self.form.sections[1].rows[3].value = patient.address?.city;
        self.form.sections[1].rows[4].value = patient.address?.country;
        
        if(patient.medicalInfo?.length != nil){
            self.form.sections[2].rows[0].value = String(patient.medicalInfo!.length!);
        }
        self.form.sections[2].rows[1].value = patient.medicalInfo?.weight;
        self.form.sections[2].rows[2].value = patient.medicalInfo?.bloodType;
       
        self.form.sections[3].rows[0].value = patient.medicalInfo?.allergies;
        self.form.sections[4].rows[0].value = patient.medicalInfo?.medicalCondition;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func backButtonPressed(sender:UIButton) {
        
        if(patientUpdated()){
            //Create the AlertController
            let actionSheetController: UIAlertController = UIAlertController(title: "Opgelet", message: "U wenst te sluiten zonder de wijzigingen op te slaan", preferredStyle: .ActionSheet)
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil);
            actionSheetController.addAction(cancelAction)
            
            //Create and add first option action
            let noSave: UIAlertAction = UIAlertAction(title: "Wijzigingen niet opslaan", style: .Default) { action -> Void in
            self.navigationController?.popViewControllerAnimated(true);
            }
            actionSheetController.addAction(noSave);
            
            //Create and add a second option action
            let doSave: UIAlertAction = UIAlertAction(title: "Wijzingen opslaan", style: .Default) { action -> Void in
                self.updateEntity()
                self.updateDatabase()
                self.navigationController?.popViewControllerAnimated(true);
            }
            actionSheetController.addAction(doSave);
            
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }else{
             navigationController?.popViewControllerAnimated(true);
        }
        
    }
    
    func patientUpdated() -> Bool{
        
        //Address updated? 
        /*
        if self.form.formValues()[formTag.straat]?.description != patient.address!.street || self.form.formValues()[formTag.huisnummer]?.description != patient.address!.streetNumber || self.form.formValues()[formTag.postcode]?.description != patient.address!.zipCode || self.form.formValues()[formTag.gemeeente]?.description != patient.address!.city || self.form.formValues()[formTag.land]?.description != patient.address!.country
        {
            addressUpdated = true;
        }
        */
        
        print(self.form.formValues()[formTag.lengte]?.description != patient.medicalInfo?.length?.description)
        print(self.form.formValues()[formTag.gewicht]?.description != patient.medicalInfo?.weight);
         print(self.form.formValues()[formTag.bloedgroep]?.description != patient.medicalInfo?.bloodType);
       

     
        
        if self.form.formValues()[formTag.lengte]?.description != patient.medicalInfo?.length?.description || self.form.formValues()[formTag.gewicht]?.description != patient.medicalInfo?.weight || self.form.formValues()[formTag.bloedgroep]?.description != patient.medicalInfo?.bloodType
        {
            medicalInfoUpdated = true;
        }
        
        
        return medicalInfoUpdated;
    }
    
    func submit(sender:UIBarButtonItem){
        //TODO: update database
        
        
        if patientUpdated()
        {
            updateEntity();
            updateDatabase()
        }
        
       
       
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    func updateEntity(){
        //Address
        /*
        patient.address!.street = self.form.formValues()[formTag.straat]!.description;
        patient.address!.streetNumber = self.form.formValues()[formTag.huisnummer]!.description;
        patient.address!.zipCode = self.form.formValues()[formTag.postcode]!.description;
        patient.address!.city = self.form.formValues()[formTag.gemeeente]!.description;
        patient.address!.country = self.form.formValues()[formTag.land]!.description;
        */
        
        //Medical condition
        if medicalInfoUpdated {
            patient.medicalInfo!.length = Int(self.form.formValues()[formTag.lengte]!.description);
            patient.medicalInfo!.weight = self.form.formValues()[formTag.gewicht]!.description;
            patient.medicalInfo!.bloodType = self.form.formValues()[formTag.bloedgroep]!.description;
            patient.medicalInfo!.allergies = self.form.formValues()[formTag.allergieën]!.description;
            patient.medicalInfo!.medicalCondition = self.form.formValues()[formTag.medischeAandoeningen]!.description;
        }
    }
    func updateDatabase(){
        if addressUpdated {
            
        }
        if medicalInfoUpdated {
            
        }
    }
    
  
    
}