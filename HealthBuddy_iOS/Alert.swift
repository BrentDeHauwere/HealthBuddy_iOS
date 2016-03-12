//
//  Alert.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 12/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit;

class Alert: NSObject {
    static func alertStatus(message:String, title: String, view: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
        view.presentViewController(alert, animated: true, completion: nil);
    }
    

}
