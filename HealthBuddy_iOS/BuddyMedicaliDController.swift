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
    var pressedSaved = false;
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
        lblMedicalID.text = "Medisch ID";
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(named:"Menu"), style:.Plain, target:self, action:"backButtonPressed:");
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Opslaan", style: .Plain, target: self, action: "submit:")
        self.navigationItem.title = "\(patient.firstName) \(patient.lastName)";
        
        self.initForm();
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
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.textAlignment" : NSTextAlignment.Right.rawValue]
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
        
        let endSection = FormSectionDescriptor();
        row = FormRowDescriptor(tag: formTag.stopWijzigen, rowType: .Button, title: "Stop wijzigen")
        row.configuration[FormRowDescriptor.Configuration.DidSelectClosure] = {
            self.view.endEditing(true)
            } as DidSelectClosure
        endSection.addRow(row);
        
        form.sections = [sectionPersonalInfo,sectionAddress, sectionMedicalInfo, sectionAllergics, sectionMedicalController, endSection];
        
        self.form = form
    }
    
    func initForm(){
        self.form.sections[0].rows[1].value = patient.firstName;
        self.form.sections[0].rows[2].value = patient.lastName;
    }
    
    func backButtonPressed(sender:UIButton) {
        if(pressedSaved){
            navigationController?.popViewControllerAnimated(true);
        }else{
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
                self.navigationController?.popViewControllerAnimated(true);
                self.submit(self.navigationItem.rightBarButtonItem!);
            }
            actionSheetController.addAction(doSave);
            
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
        
    }
    
    
    func submit(sender:UIBarButtonItem){
        //TODO: update database
        pressedSaved = true;
        
        if(saveForm()){
            self.navigationController?.popViewControllerAnimated(true);
        }else{
            
        }
    }
    
    func saveForm() -> Bool{
        //TODO: save each field to db (update)
        let message = self.form.formValues()[formTag.voornaam]!.description;
        print(message);
        return true;
    }
    
    
}