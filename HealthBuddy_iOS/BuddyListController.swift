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

class BuddyListControler: UITableViewController, UISearchResultsUpdating {
    var patients = [User]();
    var filteredData = [User]();
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad();
        self.navigationItem.hidesBackButton = true;
        loadPatientsList();
        setupSearchBar();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadPatientsList(){
        //TODO: haal alle patienten af met als buddy_id = user_id ingelogde user
        
        //mock:
        //self.patients = [User(firstName:"Yen", lastName: "Jacobs"),User(firstName:"Elvin", lastName: "Jacobs"),User(firstName:"Gunther", lastName: "Jacobs"),User(firstName:"Sabine", lastName: "Baeyens"),User(firstName:"Dieter", lastName: "Roels")];
    }
    
    func setupSearchBar(){
        tableView.dataSource = self;
        filteredData = patients;
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
                filteredData = patients;
            }else{
                for var i = 0; i < patients.count; i++ {
                    let fullName = "\(patients[i].firstName) \(patients[i].lastName)";
                    if(fullName.lowercaseString.rangeOfString(searchText.lowercaseString) != nil){
                        filteredData.append(patients[i]);
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
        cell.textLabel?.text = patient.firstName + " " + patient.lastName;
        return cell;
    }
    
    //Perform the segue bij klikken op een cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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