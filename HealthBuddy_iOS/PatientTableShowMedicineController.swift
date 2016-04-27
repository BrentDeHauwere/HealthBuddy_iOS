//
//  PatientTableShowMedicineController.swift
//  HealthBuddy_iOS
//
//  Created by Eli on 26/04/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import Alamofire;
import MRProgress;
import ObjectMapper;

class PatientTableShowMedicineController: UITableViewController {
    var medicine:Medicine!;
    var patientID:Int!;
    var schedule:MedicalSchedule!;
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var InfoLabel: UILabel!
    //@IBOutlet weak var TakeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = medicine.name;
        if(schedule.updated_at != nil){
            if(schedule.updated_at!.sameDay(NSDate())){
                self.navigationItem.rightBarButtonItem?.enabled = false;
            }
        }
        
        
        if(self.medicine.photo != nil){
            self.ImageView.image = self.medicine.photo;
        }
        else{
            self.ImageView.image = UIImage(named: "selectImage");
        }
        
        MRProgressOverlayView.showOverlayAddedTo(self.navigationController?.view, title: "Foto zoeken...", mode: .Indeterminate, animated: true) { response in
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true);
            Manager.sharedInstance.session.getAllTasksWithCompletionHandler { (tasks) -> Void in
                tasks.forEach({ $0.cancel() })
            }
        }
        
        print(Routes.showMedicine(patientID!, medicineId: self.medicine!.id!));
        Alamofire.request(.POST, Routes.showMedicine(patientID!, medicineId: self.medicine!.id!), parameters: ["api_token": Authentication.token!], headers: ["Accept": "application/json"]) .responseJSON { response in
            MRProgressOverlayView.dismissOverlayForView(self.navigationController!.view, animated: true);
            if response.result.isSuccess {
                if let JSON = response.result.value {
                    if response.response?.statusCode == 200 {
                        //print(JSON);
                        let newMedicine = Mapper<Medicine>().map(JSON);
                        self.medicine.updateMedicineInfo(newMedicine!);
                        self.medicine.photo = newMedicine?.photo;
                        if(self.medicine.photo != nil){
                            self.ImageView.image = self.medicine.photo;
                        }
                        else{
                            self.ImageView.image = UIImage(named: "selectImage");
                        }
                        
                        print("Medicine updated");
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
        
        NameLabel.text = schedule.amount;
        InfoLabel.text = medicine.info;
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
            return 1;
        }else if(section == 1){
            return 2;
        }
        else{
            return 1;
        }
    }
    
    
    @IBAction func Pushed(sender: AnyObject) {
        PushedAction();
    }
    
    func PushedAction() {
        print("Pressed");
        MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Innemen...", mode: .Indeterminate, animated: true) { response in
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true);
            Manager.sharedInstance.session.getAllTasksWithCompletionHandler { (tasks) -> Void in
                tasks.forEach({ $0.cancel() })
            }
            
        }
        
        
        
        Alamofire.request(.POST, Routes.createIntake(self.patientID!, scheduleId:self.schedule.id!), parameters: ["api_token": Authentication.token!], headers: ["Accept": "application/json"])
            .responseJSON {
                response in
                if response.result.isSuccess {
                    if let JSON = response.result.value {
                        print(JSON);
                        if response.response?.statusCode == 200 {
                            
                            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true);
                            Alert.alertStatusWithSymbol(true,message:  "Innemen geslaagd!", seconds: 1.5,    view: self.view);
                            
                            self.navigationController?.popViewControllerAnimated(true);
 
                        }else if response.response?.statusCode == 422 {
                            print("Ongeldig");
                            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true);
                            Alert.alertStatusWithSymbol(false,message:  "Mislukt", seconds: 1.5,    view: self.view);
                        }
                    }else{
                        print("Ongeldige json response intake");
                        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true);
                        Alert.alertStatusWithSymbol(false,message:  "Mislukt", seconds: 1.5, view:  self.view);
                    }
                }
                else
                {
                    print("Ongeldige request intake");
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true);
                    Alert.alertStatusWithSymbol(false,message:  "Mislukt", seconds: 1.5, view: self.view);
                }
        }
    }
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let Controller = segue.destinationViewController as? PatientShowImageController
        Controller!.image = ImageView.image;
 
 
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
