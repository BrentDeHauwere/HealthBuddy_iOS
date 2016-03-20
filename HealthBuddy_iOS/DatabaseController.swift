//
//  DatabaseController.swift
//  HealthBuddy_iOS
//
//  Created by Yen Jacobs on 20/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import Foundation;
import SwiftHTTP;

class DatabaseController: NSObject {

    internal static func postRequest(URI: String, parameters: [String:String]) throws -> Response?  {
        var postResponse:Response?;
        let opt = try HTTP.POST(URI, parameters: parameters)
        opt.start { response in
            if let err = response.error {
                print("error: \(err.localizedDescription)")
                return;
            }
            print("POST Request finished: \(response.description)")
            postResponse = response;
        }
        return postResponse;
    }
}
