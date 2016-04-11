//
//  Alert.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 12/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit;
import MRProgress

class Alert: NSObject {
    static func alertStatus(message:String, title: String, view: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert);
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil));
        view.presentViewController(alert, animated: true, completion: nil);
    }
    
    
    static func alertStatusWithSymbol(succeeded: Bool, message:String, seconds: Double, view: UIView){
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))

        if succeeded{
            MRProgressOverlayView.showOverlayAddedTo(view, title: message, mode:.Checkmark, animated: true)
        }else{
            MRProgressOverlayView.showOverlayAddedTo(view, title: message, mode:.Cross, animated: true)
        }
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            MRProgressOverlayView.dismissOverlayForView(view, animated: true);
        })
    }
    

}
