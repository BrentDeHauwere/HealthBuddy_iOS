//
//  ViewController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 6/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import SwiftHTTP


class LoginController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnLogin.layer.cornerRadius = 10;
        btnLogin.clipsToBounds = true;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textfield: UITextField)->Bool{
        textfield.resignFirstResponder();
        return true;
    }

    @IBAction func ClickSignIn(sender: UIButton) {

        if txtEmail.text == "" || txtPassword.text == ""
        {
            Alert.alertStatus("Vul uw email en wachtwoord in alstublieft", title: "Aanmelden mislukt", view: self);
        }else{
            //TODO: Connect to back-end and verify account
            let success = true;
            if success
            {
                //if role == zorgmantel{
               self.performSegueWithIdentifier("showPatientsList", sender: self);
                //if role == zorgbehoevende
              //  self.performSegueWithIdentifier("showBuddyView", sender: self);
            }
        }
    }
    
 

    @IBAction func backgroundTap(sender: AnyObject) {
        self.view.endEditing(true);
    }
}

