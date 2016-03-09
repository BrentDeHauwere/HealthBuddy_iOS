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
        print("constructor");
        
        print("\(patient.firstName) \(patient.lastName)")
        super.init(coder: aDecoder);
        self.loadForm();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        lblMedicalID.text = "Medisch ID";
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(named:"Menu"), style:.Plain, target:self, action:"backButtonPressed:");
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Opslaan", style: .Plain, target: self, action: "submit:")
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
       // form.title = "\(patient.firstName) \(patient.lastName)";
        
        // Define first section
        let section1 = FormSectionDescriptor()
        
        var row: FormRowDescriptor! = FormRowDescriptor(tag: "name", rowType: .Email, title: "Email")
        section1.addRow(row)
        
        row = FormRowDescriptor(tag: "pass", rowType: .Password, title: "Password")
        section1.addRow(row)
        
        // Define second section
        let section2 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: "button", rowType: .Button, title: "Submit")
        section2.addRow(row)
        
        form.sections = [section1, section2]
        
        self.form = form
    }

    
}