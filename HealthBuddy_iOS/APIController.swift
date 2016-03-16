//
//  APIController.swift
//  HealthBuddy_iOS
//
//  Created by Kamiel Klumpers on 10/03/16.
//  Copyright © 2016 Yen Jacobs. All rights reserved.
//

import Foundation

class APIController{
    private let address: String = "https://10.3.50.33"
    
    // src: https://medium.com/swift-programming/http-in-swift-693b3a7bf086#.4dbgcuhxu
    // Parses a string (json) to a Dictionary(key, value)
    private func JSONParseDict(jsonString:String) -> Dictionary<String, AnyObject> {
        
        if let data: NSData = jsonString.dataUsingEncoding(
            NSUTF8StringEncoding){
                do{
                    if let jsonObj = try NSJSONSerialization.JSONObjectWithData(
                        data,
                        options: NSJSONReadingOptions(rawValue: 0)) as? Dictionary<String, AnyObject>{
                            return jsonObj
                    }
                }catch{
                    print("Error")
                }
        }
        return [String: AnyObject]()
    }
    
    // src: http://stackoverflow.com/questions/30739149/how-do-i-accept-a-self-signed-ssl-certificate-using-ios-7s-nsurlsession
    // WIP
//    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
//        completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential, NSURLCredential(forTrust: challenge.protectionSpace.serverTrust))
//    }
    
    // Sends a HTTP request
    private func HTTPsendRequest(request: NSMutableURLRequest,
        callback: (String, String?) -> Void) {
            let task = NSURLSession.sharedSession().dataTaskWithRequest(
                request, completionHandler :
                {
                    data, response, error in
                    if error != nil {
                        callback("", (error!.localizedDescription) as String)
                    } else {
                        callback(
                            NSString(data: data!, encoding: NSUTF8StringEncoding) as! String,
                            nil
                        )
                    }
            })
            task.resume()
    }
    
    // combines HTTPsendRequest and JSONParseDict to get a Dictionary from a GET request
    private func HTTPGetJSON(
        url: String,
        callback: (Dictionary<String, AnyObject>, String?) -> Void) {
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            HTTPsendRequest(request) {
                (data: String, error: String?) -> Void in
                if error != nil {
                    callback(Dictionary<String, AnyObject>(), error)
                } else {
                    let jsonObj = self.JSONParseDict(data)
                    callback(jsonObj, nil)
                }
            }
    }
    
    func getUser(id: Int) -> Void{
        self.HTTPGetJSON(self.address+"/user/"+String(id)) {
            (data: Dictionary<String, AnyObject>, error: String?) -> Void in
            
            if error != nil {
                print(error)
            } else {
                if let json = data as? NSDictionary {
                    
                    let lastName: String = String(json["lastName"])
                    let firstName: String  = String(json["firstName"])
                    let buddy_id = json["buddy_id"]
                    let email: String  = String(json["email"])
                    let dateOfBirth = json["dateOfBirth"]
                    let address = json["address"]
                    let gender = json["gender"]
                    let role = json["role"]
                    let address_id = json["address_id"]
                    let id = json["id"]
                    let medical_info = json["medical_info"]
                    
//                    User(lastName,firstName,buddy_id,email,dateOfBirth,address,gender,role,address_id,id,medical_info)
                    
                    
                    print(buddy_id,firstName,lastName,dateOfBirth,email,role,address,gender,address_id,id,medical_info, terminator:"")
                }
            }
        }
    }
    
}