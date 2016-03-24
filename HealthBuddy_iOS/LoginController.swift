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
        txtEmail.text = "brentdehauwere@gmail.com";
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
        MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true);
        Alamofire.request(.POST, Routes.login, parameters: ["email": txtEmail.text!, "password":txtPassword.text!])
            .responseJSON { response in
                 MRProgressOverlayView.dismissOverlayForView(self.view, animated: true);
                if(response.result.isSuccess){
                    Alert.alertStatusWithSymbol(true,message: "Aanmelden geslaagd", seconds: 1.5, view: self.view);
                    
                    
                    if let JSON = response.result.value {
                        let JSONDict = JSON as! NSDictionary as NSDictionary;
                        let api_token = JSONDict["api_token"];
                        Authentication.token = api_token! as? String;
                        print(Authentication.token!);
                    }
                    
                    self.loadMedicineData();
                
                    let delay = 1.5 * Double(NSEC_PER_SEC)
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        if self.loggedInUser?.role ==  Roles.Zorgmantel {
                            self.performSegueWithIdentifier("showPatientsList", sender: self);
                        }else if self.loggedInUser?.role == Roles.zorgBehoevende {
                            self.performSegueWithIdentifier("Zorg", sender: self);
                        }else{
                            print("No valid role");
                        }
                    })
                    
                }else{
                    Alert.alertStatusWithSymbol(false,message: "Aanmelden mislukt", seconds: 1.5, view: self.view);
                }
        }
       
    }
    
    func loadMedicineData() {
        for var i = 0; i < self.loggedInUser?.patients?.count;i++ {
            let route = "http://10.3.50.33/api/schedule/\(self.loggedInUser!.patients![i].userId!)";
            print(route);
            Alamofire.request(.POST, route, parameters: ["api_token": (self.loggedInUser?.apiToken)!]).responseJSON{
                response in
                if(response.result.isSuccess) {
                    if let JSON = response.result.value {
                        print(JSON);
                    }
                }else{
                    print("Medicine request failed");
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showBuddyView" {
            let destinationTabbar = segue.destinationViewController as! UITabBarController;
            let destinationNavigationController = destinationTabbar.viewControllers![0] as! UINavigationController;
            let patientDashboard = destinationNavigationController.viewControllers[0] as! PatientDashboardController;
            patientDashboard.patient = loggedInUser;
        }else if segue.identifier == "showPatientsList" {
            let destNavController = segue.destinationViewController as! UINavigationController;
            let patientListView = destNavController.viewControllers[0] as! BuddyListControler;
            patientListView.patients = (loggedInUser?.patients)!;
        }
    }
    

    @IBAction func backgroundTap(sender: AnyObject) {
        self.view.endEditing(true);
    }
}

