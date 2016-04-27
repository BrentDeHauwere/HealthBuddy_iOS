//
//  ViewController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 6/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import Alamofire
import MRProgress
import ObjectMapper

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
        txtEmail.text = "eddi_wallie@gmail.com";
        txtPassword.text = "secret";
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        }
    }
    
    func logIn(){
        MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Aanmelden...", mode: .Indeterminate, animated: true) { response in
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true);
            Manager.sharedInstance.session.getAllTasksWithCompletionHandler { (tasks) -> Void in
                tasks.forEach({ $0.cancel() })
            }
        }

        Alamofire.request(.POST, Routes.login, parameters: ["email": txtEmail.text!, "password":txtPassword.text!])
            .responseJSON { response in
                if(response.result.isSuccess){
                    if let JSON = response.result.value {
                        let JSONDict = JSON as! NSDictionary as NSDictionary;
                        let api_token = JSONDict["api_token"];
                        Authentication.token = api_token! as? String;
                        print("api_token: \(Authentication.token)");
                        self.getProfile();
                    }
                }else{
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true);
                    Alert.alertStatusWithSymbol(false,message: "Aanmelden mislukt", seconds: 1.5, view: self.view);
                }
        }
    }
    
        
    func getProfile(){
        Alamofire.request(.POST, Routes.buddyProfile, parameters: ["api_token": Authentication.token!])
            .responseJSON { response in
                if response.result.isSuccess {
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true);
                    Alert.alertStatusWithSymbol(true,message: "Aanmelden geslaagd", seconds: 1.5, view: self.view);
                    
                    if let JSON = response.result.value {
                        self.loggedInUser = Mapper<User>().map(JSON);
                        print(JSON);
                        
                        // schedules inladen in achtergrond
                        NotificationController.updateMedicines(self.loggedInUser!)
                    }
                    
                    
                    let delay = 1.5 * Double(NSEC_PER_SEC)
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        if self.loggedInUser?.role ==  Roles.Zorgmantel {
                            self.performSegueWithIdentifier("showPatientsList", sender: self);
                        }else if self.loggedInUser?.role == Roles.zorgBehoevende {
                            self.performSegueWithIdentifier("showBuddyView", sender: self);
                        }else{
                            print("No valid role");
                        }
                    })
                }else{
                    print("FAILED TO GET PROFILES");
                    Alert.alertStatusWithSymbol(true,message: "Aanmelden mislukt, profiel niet gevonden", seconds: 1.5, view: self.view);
                }
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showBuddyView" {
            let destinationTabbar = segue.destinationViewController as! PatientTabBarController;
            destinationTabbar.patient = loggedInUser;
        }else if segue.identifier == "showPatientsList" {
            let destNavController = segue.destinationViewController as! UINavigationController;
            let patientListView = destNavController.viewControllers[0] as! BuddyListControler;
            patientListView.loggedInUser = self.loggedInUser;
        }
    }
    

    @IBAction func backgroundTap(sender: AnyObject) {
        self.view.endEditing(true);
    }
}

