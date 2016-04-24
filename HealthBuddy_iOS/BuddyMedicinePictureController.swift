//
//  BuddyMedicinePictureController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 16/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//  Gebruik gemaakt van tutorial: https://www.youtube.com/watch?v=PW6u55a5gZg

import UIKit
import Alamofire
import ObjectMapper
import MRProgress

class BuddyMedicinePictureController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    @IBOutlet var ScrollView: UIScrollView!
    @IBOutlet weak var MedicineImageView: UIImageView!
   
    var medicine:Medicine?
    var patientId:Int?
    
    override func viewDidLoad() {
        MedicineImageView.image = UIImage(named: "selectImage")
        
        
        if medicine != nil {
            print("FOTO: \(medicine?.photo)");
            if(medicine?.photo == nil){
                initForm();
            }
            else{
                MedicineImageView.image = medicine?.photo;
            }
        }else{
            if(medicine!.photo != nil){
                self.MedicineImageView.image = medicine!.photo;
            }
        }
        
        if(self.medicine?.name != nil){
            self.title = "\((self.medicine?.name)!) foto"
        }else{
            self.title = "Medicatie foto"
        }
        
        self.ScrollView.minimumZoomScale = 1;
        self.ScrollView.maximumZoomScale = 6;
        
        
       
    }
    
    func initForm(){
        MRProgressOverlayView.showOverlayAddedTo(self.navigationController?.view, title: "Foto zoeken...", mode: .Indeterminate, animated: true) { response in
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true);
            Manager.sharedInstance.session.getAllTasksWithCompletionHandler { (tasks) -> Void in
                tasks.forEach({ $0.cancel() })
            }
        }
        
        Alamofire.request(.POST, Routes.showMedicine(patientId!, medicineId: self.medicine!.id!), parameters: ["api_token": Authentication.token!], headers: ["Accept": "application/json"]) .responseJSON { response in
            MRProgressOverlayView.dismissOverlayForView(self.navigationController!.view, animated: true);
            if response.result.isSuccess {
                if let JSON = response.result.value {
                    if response.response?.statusCode == 200 {
                        let newMedicine = Mapper<Medicine>().map(JSON);
                        self.medicine?.updateMedicineInfo(newMedicine!);
                        if(self.medicine!.photo != nil){
                            print("Foto toegevoegd");
                            self.MedicineImageView.image = self.medicine?.photo;
                        }
                       
                    }else if response.response?.statusCode == 422 {
                        print("Medicine show failed");
                    }
                }else{
                    print("Ongeldige json response medicine show");
                }
            }else{
                print("Ongeldige request medicine show ");
            }
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
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.MedicineImageView;
    }
    
}
