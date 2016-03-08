//
//  DropdownMenuController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 7/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import Foundation
import BTNavigationDropdownMenu

class DropdownMenuController {
    
    let navigationController: UINavigationController
    let viewController: UIViewController
    
    init(navigationController: UINavigationController, viewController: UIViewController){
        self.navigationController = navigationController;
        self.viewController = viewController;
        
    }
    
    //Setup the dropdownmenu for viewController parameter
    func setupDropdownMenu(){
        let items = ["Medisch ID", "Medicatie", "Gewicht"];
        let menuView: BTNavigationDropdownMenu = BTNavigationDropdownMenu(navigationController:
            navigationController.navigationController, title: items.first!, items: items)
        viewController.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            
        }
    }
}