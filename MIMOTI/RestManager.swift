//
//  RestManager.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 24/03/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//

import Foundation
import SwiftyJSON


// Fassade Pattern

typealias ServiceResponse = (JSON, NSError?, Bool) -> Void

class RestManager: NSObject {
    
    
    // Get the shared UserDefaults object
    let defaults = UserDefaults.standard
    
    // static instance for external use
    static let sharedInstance = RestManager()
    
    // define final variables for appname & appsecret
    private let appname = "MIMOTI"
    private let secret = "MIMOTImimoti"
    
    
    
    // Basic getter function. Returns the static appname for MIMOTI
    func getAppname() -> String {
        return appname
    }
    
    // Basic getter function. Returns the static appsecret for MIMOTI
    func getSecret() -> String {
        return secret
    }
    
    
    func authenticate(_ username : String, password : String, onCompletion: @escaping (JSON, Bool) -> Void) {
        
        // define the authentication URL
        let authURL = (self.defaults.value(forKey: "MIDATAADDRESS") as? String)! + "v1/auth"
        
        
        // get record details for authentication. On completion: Send HTTP POST request with defined authparams
        JSONFactory.sharedInstance.getAuthRecord(username, password: password) { (authParams) -> Void in
            
            // send POST request to authentication URL with authParams. On completion: Call onCompletion function of authenticate
            self.makeHTTPPostRequest(authURL, params: authParams) { (json, error, flag) -> Void in
                onCompletion(json, flag)
            }
            
        }
        
    }
    
    
    
 
    func  getRecordsWithFilter(_ status : String, filter : String, onCompletion: @escaping (JSON, Bool) -> Void) {
        
        
        // define the absolute URL
        let searchURL = (self.defaults.value(forKey: "MIDATAADDRESS") as? String)! + "v1/records/search"
        
        // get record details for search. On completion: Send HTTP POST request with defined searchParams
        JSONFactory.sharedInstance.getQueryRecordWithFilter(status, filter: filter) { (searchParams) -> Void in
            
            // send POST request to search URL with searchParams. On completion: Call onCompletion function of getRecords
            self.makeHTTPPostRequest(searchURL, params: searchParams, onCompletion: { (json, error, flag) -> Void in
                onCompletion(json, flag)
            })
            
        }
    }
    
    
    
    func  getRecords(_ status : String, onCompletion: @escaping (JSON, Bool) -> Void) {
        
     
        // define the absolute URL
        let searchURL = (self.defaults.value(forKey: "MIDATAADDRESS") as? String)! + "v1/records/search"
        
        // get record details for search. On completion: Send HTTP POST request with defined searchParams
        JSONFactory.sharedInstance.getQueryRecord(status) { (searchParams) -> Void in
            
            // send POST request to search URL with searchParams. On completion: Call onCompletion function of getRecords
            self.makeHTTPPostRequest(searchURL, params: searchParams, onCompletion: { (json, error, flag) -> Void in
                onCompletion(json, flag)
            })
            
        }
    }
    
    
    func  checkForEqualTimestamp(_ status : String, timeStamp : String, onCompletion: @escaping (JSON, Bool) -> Void) {
        
        
        // define the absolute URL
        let searchURL = (self.defaults.value(forKey: "MIDATAADDRESS") as? String)! + "v1/records/search"
        
        // get record details for search. On completion: Send HTTP POST request with defined searchParams
        JSONFactory.sharedInstance.getTimeStampQuery(status, timeStamp: timeStamp) { (searchParams) -> Void in
            
            // send POST request to search URL with searchParams. On completion: Call onCompletion function of getRecords
            self.makeHTTPPostRequest(searchURL, params: searchParams, onCompletion: { (json, error, flag) -> Void in
                onCompletion(json, flag)
            })
            
        }
    }

    
    // post weight to Midata (OVERLOADED METHOD HEADER, CREATE & UPDATE)
    
    func postWeight(_ weightValue : Double, dateValue : String, status : String, recordID : String, recordVersion : String, onCompletion: @escaping (JSON, Bool) -> Void) {
        
        
     
        // define the absolute URL
        let updateURL = (self.defaults.value(forKey: "MIDATAADDRESS") as? String)! + "v1/records/update"
        
        // get record details for creation of weightEntry. On completion: Send HTTP Post request with defined record data
        JSONFactory.sharedInstance.getWeightRecord(weightValue, dateValue: dateValue, status: status, recordID : recordID, recordVersion : recordVersion) { (weightParams) -> Void in
            
            self.makeHTTPPostRequest(updateURL, params: weightParams) { (json, error, flag) -> Void in
                onCompletion(json, flag)
            }
        }
        
    }
    
    
    
    func postWeight(_ weightValue : Double, dateValue : String, status : String, onCompletion: @escaping (JSON, Bool) -> Void) {
        
        // define the absolute URL
        let createURL = (self.defaults.value(forKey: "MIDATAADDRESS") as? String)! + "v1/records/create"
        
        // get record details for creation of weightEntry. On completion: Send HTTP Post request with defined record data
        JSONFactory.sharedInstance.getWeightRecord(weightValue, dateValue: dateValue, status: status) { (weightParams) -> Void in
            
            self.makeHTTPPostRequest(createURL, params: weightParams) { (json, error, flag) -> Void in
                onCompletion(json, flag)
            }
        }
        
    }
    
    // post subjective condition to Midata (OVERLOADED METHOD HEADER, CREATE & UPDATE)
    
    func postCondition(_ conditionValue : Double, dateValue : String, status : String, recordID : String, recordVersion : String, onCompletion: @escaping (JSON, Bool) -> Void) {
        
       
        
        // define the absolute URL
        let updateURL = (self.defaults.value(forKey: "MIDATAADDRESS") as? String)! + "v1/records/update"
        
        // get record details for creation of weightEntry. On completion: Send HTTP Post request with defined record data
        JSONFactory.sharedInstance.getConditionRecord(conditionValue, dateValue: dateValue, status: status, recordID : recordID, recordVersion : recordVersion) { (conditionParams) -> Void in
            
            self.makeHTTPPostRequest(updateURL, params: conditionParams) { (json, error, flag) -> Void in
                onCompletion(json, flag)
            }
        }
        
    }
    
    
    
    func postCondition(_ conditionValue : Double, dateValue : String, status : String, onCompletion: @escaping (JSON, Bool) -> Void) {
        
        // define the absolute URL
        let createURL = (self.defaults.value(forKey: "MIDATAADDRESS") as? String)! + "v1/records/create"
        
        // get record details for creation of conditionEntry. On completion: Send HTTP Post request with defined record data
        JSONFactory.sharedInstance.getConditionRecord(conditionValue, dateValue: dateValue, status: status) { (conditionParams) -> Void in
            self.makeHTTPPostRequest(createURL, params: conditionParams) { (json, error, flag) -> Void in
                onCompletion(json, flag)
            }
            
        }
        
    }
    
    
    // post diary record to Midata (OVERLOADED METHOD HEADER, CREATE & UPDATE)
    
    func postDiary(_ diaryEntry : String, dateValue : String, status : String, recordID : String, recordVersion : String, onCompletion: @escaping (JSON, Bool) -> Void) {
        
        
        
        // define the absolute URL
        let updateURL = (self.defaults.value(forKey: "MIDATAADDRESS") as? String)! + "v1/records/update"
        
        // get record details for creation of weightEntry. On completion: Send HTTP Post request with defined record data
        JSONFactory.sharedInstance.getDiaryRecord(diaryEntry, dateValue: dateValue, status: status, recordID : recordID, recordVersion : recordVersion) { (diaryParams) -> Void in
            
            self.makeHTTPPostRequest(updateURL, params: diaryParams) { (json, error, flag) -> Void in
                onCompletion(json, flag)
            }
        }
        
    }
    
    
    
    
    func postDiary(_ diaryEntry : String, dateValue : String, status : String, onCompletion: @escaping (JSON, Bool) -> Void) {
        
        // define the absolute URL
        let createURL = (self.defaults.value(forKey: "MIDATAADDRESS") as? String)! + "v1/records/create"
        
        // get record details for creation of diaryEntry. On completion: Send HTTP Post request with defined record data
        JSONFactory.sharedInstance.getDiaryRecord(diaryEntry, dateValue: dateValue, status: status) { (diaryParams) -> Void in
            self.makeHTTPPostRequest(createURL, params: diaryParams) { (json, error, flag) -> Void in
                onCompletion(json,flag)
            
            }
        
        }
        
    }
    
    
    // perform http post request
    
    
    fileprivate func makeHTTPPostRequest(_ path : String, params : [String: AnyObject]?, onCompletion : @escaping ServiceResponse) {
        
        // invalid token flag
        var flag = false
        
        // prepare the request
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        // open the session
        let session = URLSession.shared
        
        
        // fill params in HTTPBody as needed for the POST Request
        
        do
        {
            
            
            if(JSONSerialization.isValidJSONObject(params!)){
            
                let data : NSData = try JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions()) as NSData
                let datastring = NSString(data: data as Data, encoding:String.Encoding.utf8.rawValue)
                
                // uncomment for troubleshooting
                // print(datastring)
                
            }
            // serialize HTTPBody of request with body params. Print error if operation fails
            request.httpBody = try JSONSerialization.data(withJSONObject: params!, options: JSONSerialization.WritingOptions())
            
        }
        catch
        {
            print("Error: bad file format!")
        }
        
        
        
        // open the session and send the request on completion
        session.dataTask(with: request, completionHandler:
            { (data: Data?, response: URLResponse?, error: Error?) in
                
                // check if server responded with 200 := OK. Proceed if so. If not print error and return.
                guard let okResponse = response as? HTTPURLResponse,
                    okResponse.statusCode == 200
                    
                    else
                    {
                        print ("Not a 200 response")
                        
                        
                        if(response == nil){
                            return
                        }
                        
                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                                                
                        if(responseString == "Invalid authToken."){
                            
                            print("Token ungültig!")
                            flag = true
                            
                            // uncomment for troubleshooting
                            // print(data)
                            
                            onCompletion(nil,error as NSError?,flag)
                        }
                    flag = true
                    onCompletion(nil,error as NSError?,flag)
                    return
                }
                
                // Read in the SwiftyJSON JSON Object. Call the onCompletion function of makeHTTPPostRequest
                let json: JSON = JSON(data : data!)
                    onCompletion(json, error as NSError?, flag)
             
          // Resume asynchronous task
        }).resume()
        
    }

}
