//
//  PatientMedicaliDController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 7/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import SwiftForms
import Alamofire
import MRProgress

class BuddyMedicaliDController: FormViewController {
    var patient:User!;
    
    var addressUpdate = false;
    var medicalInfoUpdate = false;
    var userUpdate = false;
    
    var goBack = false;
    
    @IBOutlet weak var lblMedicalID: UILabel!
    
    struct formTag{
        static let gender = "gender";
        static let firstName = "firstName";
        static let lastName = "lastName";
        static let dateOfBirth = "dateOfBirth";
        static let phone = "phone";
        static let street = "street";
        static let streetNumber = "streetNumber"
        static let bus = "bus";
        static let zipCode = "zipCode";
        static let city = "city";
        static let country = "country";
        static let length = "length";
        static let weight = "weight";
        static let bloodType = "bloodType";
        static let allergies = "allergies";
        static let medicalCondition = "medicalCondition";

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
        row = FormRowDescriptor(tag: formTag.gender, rowType: .Picker, title: "Geslacht")
 
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

        
        row = FormRowDescriptor(tag: formTag.firstName, rowType: .Text, title: "Voornaam");
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue];

        
        sectionPersonalInfo.addRow(row);
        
        row = FormRowDescriptor(tag: formTag.lastName, rowType: .Text, title: "Naam");
         row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionPersonalInfo.addRow(row);
        
        
        row = FormRowDescriptor(tag: formTag.dateOfBirth, rowType: .Date, title: "Geboortedatum")
        sectionPersonalInfo.addRow(row);
        
        row = FormRowDescriptor(tag: formTag.phone, rowType: .Phone, title: "Telefoonnummer")
         row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionPersonalInfo.addRow(row)
        
        //Define address

        let sectionAddress = FormSectionDescriptor();
        sectionAddress.headerTitle = "Adres";
        
        row = FormRowDescriptor(tag: formTag.street, rowType: .Text, title: "Straat");
         row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionAddress.addRow(row);
        
        row = FormRowDescriptor(tag: formTag.streetNumber, rowType: .Number, title: "Huisnummer");
         row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionAddress.addRow(row);
        
        row = FormRowDescriptor(tag: formTag.bus, rowType: .Text, title: "Bus");
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionAddress.addRow(row);
        
        row = FormRowDescriptor(tag: formTag.zipCode, rowType: .Text, title: "Postcode");
         row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionAddress.addRow(row);
        
        row = FormRowDescriptor(tag: formTag.city, rowType: .Text, title: "Gemeente");
         row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionAddress.addRow(row);
        
        row = FormRowDescriptor(tag: formTag.country, rowType: .Text, title: "Land");
         row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionAddress.addRow(row);
        
        
        //Define medical info
        let sectionMedicalInfo = FormSectionDescriptor();
        sectionMedicalInfo.headerTitle = "Medische info";
        
        row = FormRowDescriptor(tag: formTag.length, rowType: .Number, title: "Lengte");
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionMedicalInfo.addRow(row);
        
        row = FormRowDescriptor(tag: formTag.weight, rowType: .Number, title: "Gewicht");
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
        sectionMedicalInfo.addRow(row);
        
        row = FormRowDescriptor(tag: formTag.bloodType, rowType: .Picker, title: "Bloedgroep")
        row.configuration[FormRowDescriptor.Configuration.Options] = ["","A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
        row.value="";
       
        sectionMedicalInfo.addRow(row);

        
        let sectionAllergics = FormSectionDescriptor();
        sectionAllergics.headerTitle = "Allergieën en reacties";
        row = FormRowDescriptor(tag: formTag.allergies, rowType: .MultilineText, title: "");
        sectionAllergics.addRow(row);
        
        let sectionMedicalController = FormSectionDescriptor();
        sectionMedicalController.headerTitle = "Medische aandoeningen";
        row = FormRowDescriptor(tag: formTag.medicalCondition, rowType: .MultilineText, title: "");
        sectionMedicalController.addRow(row);
        
        
        form.sections = [sectionPersonalInfo,sectionAddress, sectionMedicalInfo, sectionAllergics, sectionMedicalController];
        
        self.form = form
    }
    
    //Initiating the form values with the patient object
    func initForm(){
        self.form.sections[0].rows[0].value = patient.gender;
        self.form.sections[0].rows[1].value = patient.firstName;
        self.form.sections[0].rows[2].value = patient.lastName;

        self.form.sections[0].rows[3].value = patient.dateOfBirth;
        self.form.sections[0].rows[4].value = patient.phone;

        self.form.sections[1].rows[0].value = patient.address?.street;
        self.form.sections[1].rows[1].value = patient.address?.streetNumber;
        self.form.sections[1].rows[2].value = patient.address?.bus;
        self.form.sections[1].rows[3].value = patient.address?.zipCode;
        self.form.sections[1].rows[4].value = patient.address?.city;
        self.form.sections[1].rows[5].value = patient.address?.country;
        
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
            let noSave: UIAlertAction = UIAlertAction(title: "Wijzigingen niet opslaan", style: .Destructive) { action -> Void in
            self.navigationController?.popViewControllerAnimated(true);
            }
            actionSheetController.addAction(noSave);
            
            //Create and add a second option action
            let doSave: UIAlertAction = UIAlertAction(title: "Wijzingen opslaan", style: .Default) { action -> Void in
                MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true);
                self.updateEntity()
                self.updateDatabase()
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



        if self.form.formValues()[formTag.gender]?.description != patient.gender || self.form.formValues()[formTag.firstName]?.description != patient.firstName || self.form.formValues()[formTag.lastName]?.description != patient.lastName || self.form.formValues()[formTag.dateOfBirth]?.description != patient.dateOfBirth?.description  || self.form.sections[0].rows[4].value != patient.phone
        {
            userUpdate = true;
        }


        if self.form.formValues()[formTag.length]?.description != patient.medicalInfo?.length?.description || self.form.formValues()[formTag.weight]?.description != patient.medicalInfo?.weight || self.form.formValues()[formTag.bloodType]?.description != patient.medicalInfo?.bloodType || self.form.sections[3].rows[0].value != patient.medicalInfo?.allergies || self.form.sections[4].rows[0].value != patient.medicalInfo?.medicalCondition
        {
            medicalInfoUpdate = true;
        }
        
        
        return userUpdate || medicalInfoUpdate;
    }
    
    func submit(sender:UIBarButtonItem){
        //TODO: update database
        if patientUpdated()
        {
            MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true);
            updateEntity();
            updateDatabase()
        }else{
            Alert.alertStatusWithSymbol(true,message: "Gegevens opgeslaan", seconds: 1.5, view: self.view);
        }
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
        if medicalInfoUpdate {
            patient.medicalInfo!.length = Int(self.form.formValues()[formTag.length]!.description);
            patient.medicalInfo!.weight = self.form.formValues()[formTag.weight]!.description;
            patient.medicalInfo!.bloodType = self.form.formValues()[formTag.bloodType]!.description;
            patient.medicalInfo!.allergies = self.form.formValues()[formTag.allergies]!.description;
            patient.medicalInfo!.medicalCondition = self.form.formValues()[formTag.medicalCondition]!.description;
        }
        if userUpdate {
            patient.gender = self.form.formValues()[formTag.gender]!.description;
            patient.firstName = self.form.formValues()[formTag.firstName]!.description;
            patient.lastName = self.form.formValues()[formTag.lastName]!.description;
            patient.dateOfBirth = self.form.formValues()[formTag.dateOfBirth] as? NSDate;
            patient.phone = self.form.formValues()[formTag.phone]!.description;
        }
    }
    
    func updateDatabase(){
        let group = dispatch_group_create()
        var errors = [String]();
        
        if medicalInfoUpdate{
            dispatch_group_enter(group)
            Alamofire.request(.POST, Routes.updateMedicalInfo(patient.userId!), parameters: ["api_token": Authentication.token!, formTag.length: (patient.medicalInfo?.length)!, formTag.weight: (patient.medicalInfo?.weight)!, formTag.bloodType: (patient.medicalInfo?.bloodType)!, formTag.allergies: (patient.medicalInfo?.allergies)!, formTag.medicalCondition: (patient.medicalInfo?.medicalCondition)!])   .responseJSON { response in
                if response.result.isSuccess {
                    print("Update medical info succeeded");
                    if let JSON = response.result.value {
                        print(JSON);
                    }
                }else{
                    print("Update medical info failed");
                    //TODO: fill in errors array
                }
                dispatch_group_leave(group)
            }
        }
        
        if userUpdate {
            dispatch_group_enter(group)
            print( patient.dateOfBirth!);
            Alamofire.request(.POST, Routes.updateUserInfo(patient.userId!), parameters: ["api_token": Authentication.token!, formTag.gender: patient.gender!, formTag.firstName: patient.firstName!, formTag.lastName : patient.lastName!, formTag.dateOfBirth: patient.dateOfBirth!, formTag.phone: patient.phone!]) .responseJSON { response in
               

                if response.result.isSuccess {
                    print("Update user succeeded")
                    if let JSON = response.result.value {
                        print(JSON);
                    }
                }else{
                    print("update user failed");
                    errors.append("Telefoonnr mag niet null zijn");
                    //TODO: fill in errors array
                }
                 dispatch_group_leave(group)
            }
        }

        dispatch_group_notify(group, dispatch_get_main_queue()) {
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true);
            print(errors.count);
            if errors.count <= 0 {
                Alert.alertStatusWithSymbol(true, message: "Wijzigingen opgeslaan", seconds: 1.5, view: self.view);
            } else {
                Alert.alertStatusWithSymbol(false, message: "Wijzigingen opslaan mislukt", seconds: 1.5, view: self.view);
                let delay = 1.5 * Double(NSEC_PER_SEC)
                let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    Alert.alertStatus(errors.joinWithSeparator("\n"), title: "Wijzigingen niet doorgevoerd", view: self);
                });
            }
        }
    }
    

    
  
    
}