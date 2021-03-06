//
//  BuddyMainMenuController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 8/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import UIKit

class BuddyMainMenuController: UITableViewController {
    var patient:User!;
    var menuItems = ["Medisch ID","Medicatie"];
    var descriptions = ["Persoonlijke gegevens","Monitoring"];
    var logos = [UIImage(named: "MedischID"),UIImage(named: "Medicatie")];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero);
        self.tableView.backgroundColor = UIColor(red: 156.0/255, green: 207.0/255, blue: 88.0/255, alpha: 1);
        self.navigationItem.title = "\(patient.firstName!) \(patient.lastName!)";
     
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:UIImage(named:"ContactenLogo"), style:.Plain, target:self, action:#selector(BuddyMainMenuController.backButtonPressed(_:)));
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate;
        self.navigationController?.interactivePopGestureRecognizer?.enabled = true;
    }
    
    override func viewDidAppear(animated: Bool) {
        if(self.navigationItem.title != "\(patient.firstName!) \(patient.lastName!)"){
            self.navigationItem.title = "\(patient.firstName!) \(patient.lastName!)";
        }
         super.viewDidAppear(true);
    }
    
    override func viewWillAppear(animated: Bool) {
        if tableView.indexPathForSelectedRow != nil {
            tableView.deselectRowAtIndexPath((tableView.indexPathForSelectedRow)!, animated: animated);
        }
        super.viewWillAppear(animated);
    }
    
    
    func backButtonPressed(sender:UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count;
    }

    //Make up menu items
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuItem", forIndexPath: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row];
        cell.detailTextLabel?.text = descriptions[indexPath.row];
        cell.imageView?.image = logos[indexPath.row];
        return cell
    }
    //Select menuItem, fire of segue
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.row{
            case 0:
                self.performSegueWithIdentifier("showMedicaliD", sender: self);
            case 1:
                self.performSegueWithIdentifier("showMedicine", sender: self);
            default:
                print("Ongeldig menu-item, error from BuddyMainMenuController @tableView didSelectRowAtIndexpath");
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       if segue.identifier == "showMedicaliD" {
            let medicalIdBoard = segue.destinationViewController as! BuddyMedicaliDController;
            medicalIdBoard.patient = self.patient;
        }else if segue.identifier == "showMedicine" {
            let tabbar = segue.destinationViewController as! BuddyMedicineTabBarController;
            tabbar.patient = self.patient;
        }else{
            print("No segue preparation");
        }
    }
    

}
