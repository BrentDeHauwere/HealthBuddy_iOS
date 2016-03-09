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
            alertStatus("Vul uw email en wachtwoord in alstublieft", title: "Aanmelden mislukt");
        }else{
            //TODO: Connect to back-end and verify account
            
            /*
            //set up the base64-encoded credentials
            let post = "username=\(txtEmail.text) &password=\(txtPassword.text)";
            print("POST Request: \(post)");
            let loginData: NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!;
            let base64LoginString = loginData.base64EncodedStringWithOptions([]);
            
            //Create the request
            let url = NSURL(string: "http://route");
            let request = NSMutableURLRequest(URL: url!);
            request.HTTPMethod = "POST";
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization");
            
            //fire off the request
            //let urlConnection = NSURLConnection(request: request, delegate: self);
            //TODO: check response
            */
            
            let success = true;
            if success
            {
                //if role == zorgmantel{
                self.performSegueWithIdentifier("login_success", sender: self);
            }
        }
    }
    
    func alertStatus(message:String, title: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
        self.presentViewController(alert, animated: true, completion: nil);
    }

    @IBAction func backgroundTap(sender: AnyObject) {
        self.view.endEditing(true);
    }
}

