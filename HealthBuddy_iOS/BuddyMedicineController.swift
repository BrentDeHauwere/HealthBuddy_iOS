//
//  BuddyMedicineController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 8/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit
import Alamofire
import MRProgress
import ObjectMapper

class BuddyMedicineController: UITableViewController {
    @IBOutlet weak var lblMedicine: UILabel!
    
    var patient:User!


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMedicine.text = "Medicatie";
       
        self.navigationController?.navigationBar.translucent = false;
   
        self.extendedLayoutIncludesOpaqueBars = false;
        self.automaticallyAdjustsScrollViewInsets = false;

        
        self.tabBarController!.title="\(patient.firstName!) \(patient.lastName!)";
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(named:"Menu"), style:.Plain, target:self, action:#selector(BuddyMedicineController.backButtonPressed(_:)));

        self.patient.medicines!.sortInPlace { $0.name < $1.name }
        let refreshControl = UIRefreshControl();
        refreshControl.addTarget(self, action: #selector(BuddyMedicineController.refreshData), forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        let addMedicineBarBtn = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(BuddyMedicineController.addMedicineBtn));
        self.tabBarController!.navigationItem.rightBarButtonItem = addMedicineBarBtn;
    }
    
    func addMedicineBtn(){
        self.performSegueWithIdentifier("loadNewMedicine", sender: self);
    }
    
    func refreshData(refreshControl: UIRefreshControl){
        Alamofire.request(.POST, Routes.showPatient(patient.userId!), parameters: ["api_token": Authentication.token!])
            .responseJSON { response in
                if response.result.isSuccess {
                    if let JSON = response.result.value {
                        self.patient = Mapper<User>().map(JSON);
                        self.tableView.reloadData();
                        refreshControl.endRefreshing();
                    }
                }else{
                    refreshControl.endRefreshing();
                    Alert.alertStatusWithSymbol(false,message: "Refresh mislukt", seconds: 1.5, view: self.view);
                    print("FAILED TO GET PATIENT PROFILE");
                }
        }
    }
    
    func backButtonPressed(sender:UIButton){
        navigationController?.popViewControllerAnimated(true);
    }
    

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.patient.medicines!.count;
    }
    
    //Maakt de cell op in de table
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("MedicineCell", forIndexPath: indexPath) as UITableViewCell;
        let medicine:Medicine = self.patient.medicines![indexPath.row];
        cell.textLabel?.text = medicine.name;
        return cell;
    }

    
    //Delete a medicin
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let alert = UIAlertController(title: "Verwijder \(self.patient.medicines![indexPath.row].name!)", message: "Bent u zeker?", preferredStyle: .ActionSheet)
            
            let DeleteAction = UIAlertAction(title: "Akkoord", style: .Destructive) { action -> Void in
                let group = dispatch_group_create();
                self.deleteMedicine(self.patient.medicines![indexPath.row].id!, dispatchGroup: group);
                dispatch_group_notify(group, dispatch_get_main_queue()) {
                    tableView.beginUpdates()
                    self.patient.medicines!.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    tableView.endUpdates()
                }
            }
            
            let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {action -> Void in
                tableView.setEditing(false, animated: true);
            }
            
            alert.addAction(DeleteAction)
            alert.addAction(CancelAction)
            
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //Perform the segue bij klikken op een cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("loadMedicine", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loadMedicine" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let navController = segue.destinationViewController as? UINavigationController {
                    let buddyNewMedicine = navController.viewControllers[0] as! BuddyNewMedicineController;
                    buddyNewMedicine.medicine =  self.patient.medicines![indexPath.row];
                    buddyNewMedicine.patientId = self.patient.userId;
                }
            }
        }
        if segue.identifier == "loadNewMedicine"{
            if let navController = segue.destinationViewController as? UINavigationController {
                let buddyNewMedicine = navController.viewControllers[0] as! BuddyNewMedicineController;
                buddyNewMedicine.patientId = self.patient.userId;
            }
        }
 
    }

    
    @IBAction func saveNewMedicine(segue:UIStoryboardSegue) {
        if let buddynewMedicineController = segue.sourceViewController as? BuddyNewMedicineController{
            if let medicine = buddynewMedicineController.medicine {
                //Indien nieuwe medicijn: append, else: replace
                if(buddynewMedicineController.newMedicin){
                    self.patient.medicines?.append(medicine);
                    self.patient.medicines!.sortInPlace { $0.name < $1.name }
                    let indexPath = NSIndexPath(forRow: self.patient.medicines!.count-1, inSection: 0);
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                    tableView.reloadData();
                }else{
                    tableView.reloadData();
                }
            }
        }
    }
 
    
    
    @IBAction func cancelToPlayersViewController(segue:UIStoryboardSegue) {
        
    }
    
    func deleteMedicine(medicineId:Int, dispatchGroup:dispatch_group_t){
        dispatch_group_enter(dispatchGroup)
        Alamofire.request(.POST, Routes.deleteMedicine(patient.userId!, medicineId: medicineId ), parameters: ["api_token": Authentication.token!], headers: ["Accept": "application/json"])   .responseString { response in
            if response.result.isSuccess {
                if let string = response.result.value {
                    print(string);
                }else{
                    print("Ongeldige json response medicalinfo update");
                    Alert.alertStatusWithSymbol(false,message: "Verwijderen mislukt", seconds: 1.5, view: self.view);
                }
            }else{
                print("Ongeldige request medicalinfo update");
                Alert.alertStatusWithSymbol(false,message: "Verwijderen mislukt", seconds: 1.5, view: self.view);
            }
            dispatch_group_leave(dispatchGroup);
        }
    }
}



