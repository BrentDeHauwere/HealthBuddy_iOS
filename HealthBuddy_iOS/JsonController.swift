//
//  JsonController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 21/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import Foundation

class JsonController {
    static func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
}