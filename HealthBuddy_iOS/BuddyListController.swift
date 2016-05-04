//
//  PatientListController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 7/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//  Gebruik gemaakt van tutorial: https://www.raywenderlich.com/113772/uisearchcontroller-tutorial
// en https://github.com/codepath/ios_guides/wiki/Search-Bar-Guide
//

import UIKit
import Alamofire
import ObjectMapper

class BuddyListControler: UITableViewController, UISearchResultsUpdating {
    var loggedInUser:User?
    var filteredData = [User]();
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.navigationItem.hidesBackButton = true;
        setupSearchBar();
        
        //Setup refresh gesture
        let refreshControl = UIRefreshControl();
        refreshControl.addTarget(self, action: #selector(BuddyListControler.refreshDataOnDemand), forControlEvents: .ValueChanged)
        self.tableView.addSubview(refreshControl);
        
        //Returing task sync app with back-end
        NSTimer.scheduledTimerWithTimeInterval(600, target: self, selector:  #selector(BuddyListControler.scheduleRefreshData), userInfo: nil, repeats: true);
    }
    
    
    func scheduleRefreshData(){
        Alamofire.request(.POST, Routes.buddyProfile, parameters: ["api_token": Authentication.token!])
            .responseJSON { response in
                if response.result.isSuccess {
                    if let JSON = response.result.value {
                        self.loggedInUser = Mapper<User>().map(JSON);
                        self.filteredData = (self.loggedInUser?.patients)!;
                        self.filteredData.sortInPlace{$0.firstName < $1.firstName};
                        self.tableView.reloadData();
                        print("Data refreshed");
                    }
                }
        }
    }
    
    func refreshDataOnDemand(refreshControl: UIRefreshControl){
        Alamofire.request(.POST, Routes.buddyProfile, parameters: ["api_token": Authentication.token!])
            .responseJSON { response in
                if response.result.isSuccess {
                    if let JSON = response.result.value {
                        self.loggedInUser = Mapper<User>().map(JSON);
                        self.filteredData = (self.loggedInUser?.patients)!;
                        self.tableView.reloadData();
                        self.filteredData.sortInPlace{$0.firstName < $1.firstName};
                        refreshControl.endRefreshing();
                        
                        // refresh patientJSON
                        NSUserDefaults.standardUserDefaults().setObject(self.loggedInUser!.toJSONString(), forKey: "loggedInUser")
                        print("Data refreshed");
                    }
                }else{
                    refreshControl.endRefreshing();
                    Alert.alertStatusWithSymbol(false,message: "Refresh mislukt", seconds: 1.5, view: self.view);
                    print("FAILED TO GET PROFILES");
                }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if tableView.indexPathForSelectedRow != nil {
            tableView.deselectRowAtIndexPath((tableView.indexPathForSelectedRow)!, animated: animated);
        }
        tableView.reloadData();
        super.viewWillAppear(animated);
    }
    
    
    func setupSearchBar(){
        tableView.dataSource = self;
        filteredData = (loggedInUser?.patients)!;
        self.filteredData.sortInPlace{$0.firstName < $1.firstName};
        searchController = UISearchController(searchResultsController: nil);
        searchController.searchResultsUpdater = self;
        searchController.dimsBackgroundDuringPresentation = false;
        searchController.searchBar.sizeToFit();
        tableView.tableHeaderView = searchController.searchBar;
        definesPresentationContext = true;
    }
    
    //update the list when searching
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredData.removeAll();
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty{
                filteredData = (loggedInUser?.patients)!;
            }else{
                for (patient) in (self.loggedInUser?.patients!)! {
                    let fullnname = "\(patient.firstName) \(patient.lastName)";
                    if(fullnname.lowercaseString.rangeOfString(searchText.lowercaseString) != nil ){
                        filteredData.append(patient);
                    }
                }
            }
            
            tableView.reloadData();
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredData.count;
    }
    
    //Maakt de cell op in de table
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("patient", forIndexPath: indexPath) as UITableViewCell;
        let patient: User = filteredData[indexPath.row];
        cell.textLabel?.text = patient.firstName! + " " + patient.lastName!;
        return cell;
    }
    
    //Perform the segue bij klikken op een cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
        self.performSegueWithIdentifier("gotoBuddyMenu", sender: self)
    }
    
    
    //Event dat uitgevoerd wordt bij klikken op een cel, voordat segue wordt afgevoerd
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoBuddyMenu" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let budyMainMenu = segue.destinationViewController as! BuddyMainMenuController ;
                budyMainMenu.patient = filteredData[indexPath.row];
            }
        }
    }
    
}