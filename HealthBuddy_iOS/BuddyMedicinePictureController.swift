//
//  BuddyMedicinePictureController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 16/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//  Gebruik gemaakt van tutorial: https://www.youtube.com/watch?v=PW6u55a5gZg

import UIKit

class BuddyMedicinePictureController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var MedicineImageView: UIImageView!
    var medicine:Medicine?
    
    override func viewDidLoad() {
        self.title = "Medicatie foto"
        if(self.medicine?.photo != nil){
            MedicineImageView.image = medicine?.photo;
        }else{
            MedicineImageView.image = UIImage(named: "selectImage")
        }
    }
    
    @IBAction func selectImage(sender: AnyObject) {
        let picker = UIImagePickerController();
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Selecteer foto", message: "", preferredStyle: .ActionSheet)
        
        let action1: UIAlertAction = UIAlertAction(title: "Cameraroll", style: .Default) { action -> Void in
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            picker.delegate = self;
            self.presentViewController(picker, animated: true, completion: nil);
        }
        actionSheetController.addAction(action1);
        
        let action2: UIAlertAction = UIAlertAction(title: "Camera", style: .Default) { action -> Void in
            picker.sourceType = UIImagePickerControllerSourceType.Camera;
            picker.delegate = self;
            self.presentViewController(picker, animated: true, completion: nil);
        }
        actionSheetController.addAction(action2);
        
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil);
        actionSheetController.addAction(cancel);
    
    
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage;
        MedicineImageView.image = image;
        medicine?.photo = image;
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
  
    
   
    
    
}
