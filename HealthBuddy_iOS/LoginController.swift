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
    var loggedInUser:User?;
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnLogin.layer.cornerRadius = 10;
        btnLogin.clipsToBounds = true;
        
        //Temporary auto login
        txtEmail.text = "brentdehauwere@gmail.com";
        txtPassword.text = "secret";
        
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
     //   if txtEmail.text == "" || txtPassword.text == ""
     //   {
     //       Alert.alertStatus("Vul uw email en wachtwoord in alstublieft", title: "Aanmelden mislukt", view: self);
     //   }else{
        
        
         do {
            _ = try DatabaseController.postRequest(Routes.login, parameters: ["email": txtEmail.text!, "password": txtPassword.text!]);
         } catch let error {
            print("got an error creating the request: \(error)")
            Alert.alertStatus("Oeps, er ging iets mis. Probeer opnieuw", title: "Aanmelden mislukt", view: self);
            return;
         }
        
        
            
            
            /*
            if self.loggedInUser != nil {
                self.performSegueWithIdentifier("showPatientsList", sender: self);
            }else{
                Alert.alertStatus("Oeps, er ging iets mis. Probeer opnieuw", title: "Aanmelden mislukt", view: self);
            }
*/
        //}
    }
    
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showBuddyView" {
            let destinationTabbar = segue.destinationViewController as! UITabBarController;
            let destinationNavigationController = destinationTabbar.viewControllers![0] as! UINavigationController;
            let patientDashboard = destinationNavigationController.viewControllers[0] as! PatientDashboardController;
            patientDashboard.patient = loggedInUser;
        }
    }
    

    @IBAction func backgroundTap(sender: AnyObject) {
        self.view.endEditing(true);
    }
}

