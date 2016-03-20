//
//  ViewController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 6/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import SwiftHTTP
import MRProgress


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
        if txtEmail.text == "" || txtPassword.text == ""
        {
            Alert.alertStatus("Vul uw email en wachtwoord in alstublieft", title: "Aanmelden mislukt", view: self);
        }else{
            self.logIn();
  
        /*
            if self.loggedInUser != nil {
                self.performSegueWithIdentifier("showPatientsList", sender: self);
            }else{
                Alert.alertStatus("Oeps, er ging iets mis. Probeer opnieuw", title: "Aanmelden mislukt", view: self);
            }
        */

        }
    }
    
    func logIn(){
        do {
            MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true);
            let opt = try HTTP.POST(Routes.login, parameters: ["email": self.txtEmail.text!, "password": self.txtPassword.text!])
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    MRProgressOverlayView.dismissAllOverlaysForView(self.view, animated: true);
           
                    Alert.alertStatus("Oeps er liep iets mis, controleer uw internetverbinding of probeer later opnieuw", title: "Aanmelden mislukt", view: self);
                    
                    return
                }
  
                print("opt finished: \(response.description)")
                
                
                
                //TODO: parse response to object
                

                 MRProgressOverlayView.dismissAllOverlaysForView(self.view, animated: true);
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            MRProgressOverlayView.dismissAllOverlaysForView(self.view, animated: true);
        }
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

