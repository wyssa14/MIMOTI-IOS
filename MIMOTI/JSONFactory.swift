//
//  JSONFactory.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 24/03/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//

import Foundation
import SwiftyJSON
import Locksmith

class JSONFactory: NSObject {

    // static instance for external use
    static let sharedInstance = JSONFactory()

    
    // get the current authentication Token from the Keychain. Return nil if token not available.
    func getAuthToken() -> String {
        
        // get authToken from Keychain if present
        var dictionary = Locksmith.loadDataForUserAccount(userAccount: "USER")
        
        // cast & return value for key "authToken" in dictionary variable

        if let authToken = dictionary!["authToken"]{
        
           
        return authToken as! String
            
        }
        
        return "-1"
        
    }
    
    
    // get weight record string (OVERLOADED METHOD HEADER CREATE & UPDATE)
    
    func getWeightRecord(_ weightValue : Double, dateValue : String, status : String, recordID : String, recordVersion : String, onCompletion : ([String : AnyObject]) -> Void) {
     
         var weightRecord : [String : AnyObject] = [:]
        
        
        
        // get updateHeader
        getUpdateHeader(recordID, recordVersion: recordVersion) { (updateHeader) -> Void in
            
            // set reference of weightRecord to the received baseRecord
            weightRecord = updateHeader!
            
        }
        
        // define the detailled weight string. set the weightValue from the call
        
        weightRecord["data"] = "{\"resourceType\" : \"Observation\", \"status\" : \"\(status)\", \"category\" : {\"coding\" : [{\"system\" : \"http://hl7.org/fhir/observation-category\", \"code\" : \"vital-signs\", \"display\" : \"Vital Signs\"}]}, \"code\" : {\"coding\" : [{\"system\" : \"http://loinc.org\", \"code\" : \"3141-9\", \"display\" : \"Body weight Measured\"}]}, \"effectiveDateTime\" : \"\(dateValue)\", \"valueQuantity\" : {\"value\" : \(weightValue), \"unit\" : \"kg\", \"system\" : \"http://unitsofmeasure.org\", \"code\" : \"kg\"}}\"" as AnyObject?
        
        // send the weightRecord back to the calling function
        onCompletion(weightRecord)

        
    }
    
    
    
    
    func getWeightRecord(_ weightValue : Double, dateValue : String, status : String, onCompletion : ([String : AnyObject]) -> Void) {
        
        var weightRecord : [String : AnyObject] = [:]
        
        //get baseString
       getBaseRecord("WEIGHT") { (baseRecord) -> Void in
        
        // set reference of weightRecord to the received baseRecord
        weightRecord = baseRecord!
        
        }
        
        // define the detailled weight string. set the weightValue from the call
        
        weightRecord["data"] = "{\"resourceType\" : \"Observation\", \"status\" : \"\(status)\", \"category\" : {\"coding\" : [{\"system\" : \"http://hl7.org/fhir/observation-category\", \"code\" : \"vital-signs\", \"display\" : \"Vital Signs\"}]}, \"code\" : {\"coding\" : [{\"system\" : \"http://loinc.org\", \"code\" : \"3141-9\", \"display\" : \"Body weight Measured\"}]}, \"effectiveDateTime\" : \"\(dateValue)\", \"valueQuantity\" : {\"value\" : \(weightValue), \"unit\" : \"kg\", \"system\" : \"http://unitsofmeasure.org\", \"code\" : \"kg\"}}\"" as AnyObject?
        
        // send the weightRecord back to the calling function
        onCompletion(weightRecord)
        
        
    }
    
    // get condition record string (OVERLOADED METHOD HEADER CREATE & UPDATE)
    
    func getConditionRecord(_ conditionValue : Double, dateValue : String, status : String, recordID : String, recordVersion : String, onCompletion : ([String : AnyObject]) -> Void) {
        
        var conditionRecord : [String : AnyObject] = [:]
        
        
        
        // get updateHeader
        getUpdateHeader(recordID, recordVersion: recordVersion) { (updateHeader) -> Void in
            
            // set reference of weightRecord to the received baseRecord
            conditionRecord = updateHeader!
            
        }
        
        // define the detailled weight string. set the weightValue from the call
        
        conditionRecord["data"] = "{\"resourceType\" : \"Observation\", \"status\" : \"\(status)\", \"category\" : {\"coding\" : [{\"system\" : \"http://hl7.org/fhir/observation-category\", \"code\" : \"survey\", \"display\" : \"Survey\"}]}, \"code\" : {\"coding\" : [{\"system\" : \"http://midata.coop\", \"code\" : \"subjective-condition\", \"display\" : \"Subjective Condition\"}]}, \"effectiveDateTime\" : \"\(dateValue)\", \"valueQuantity\" : {\"value\" : \(conditionValue)}}\"" as AnyObject?
        
        // send the weightRecord back to the calling function
        onCompletion(conditionRecord)
        
        
    }

    
    
    
    func getConditionRecord(_ conditionValue : Double, dateValue : String, status : String, onCompletion : ([String : AnyObject]) -> Void) {
        
        var conditionRecord : [String : AnyObject] = [:]
        
        
        // get baseString
        
        getBaseRecord("SUBJECTIVECONDITION") { (baseRecord) -> Void in
            
            // set reference of weightRecord to the received baseRecord
            conditionRecord = baseRecord!
            
        }
        
        // define the detailled condition string. set the conditionValue from the call
        
        conditionRecord["data"] = "{\"resourceType\" : \"Observation\", \"status\" : \"\(status)\", \"category\" : {\"coding\" : [{\"system\" : \"http://hl7.org/fhir/observation-category\", \"code\" : \"survey\", \"display\" : \"Survey\"}]}, \"code\" : {\"coding\" : [{\"system\" : \"http://midata.coop\", \"code\" : \"subjective-condition\", \"display\" : \"Subjective Condition\"}]}, \"effectiveDateTime\" : \"\(dateValue)\", \"valueQuantity\" : {\"value\" : \(conditionValue)}}\"" as AnyObject?
        
        
        // send the weightRecord back to the calling function
        onCompletion(conditionRecord)

        
    }
    
    // get diary record string (OVERLOADED METHOD HEADER CREATE & UPDATE)
    
    func getDiaryRecord(_ diaryEntry : String, dateValue : String, status : String, recordID : String, recordVersion : String, onCompletion : ([String : AnyObject]) -> Void) {
        
        var diaryRecord : [String : AnyObject] = [:]
        
       
        
        // get updateHeader
        getUpdateHeader(recordID, recordVersion: recordVersion) { (updateHeader) -> Void in
            
            // set reference of weightRecord to the received baseRecord
            diaryRecord = updateHeader!
            
        }
        
        // define the detailled weight string. set the weightValue from the call
        
        diaryRecord["data"] = "{\"resourceType\" : \"Observation\", \"status\" : \"\(status)\", \"category\" : {\"coding\" : [{\"system\" : \"http://hl7.org/fhir/observation-category\", \"code\" : \"survey\", \"display\" : \"Survey\"}]}, \"code\" : {\"coding\" : [{\"system\" : \"http://loinc.org\", \"code\" : \"61150-9\", \"display\" : \"Subjective Narrative\"}]}, \"effectiveDateTime\" : \"\(dateValue)\", \"valueString\" : \"\(diaryEntry)\"}\"" as AnyObject?
        
        // send the weightRecord back to the calling function
        onCompletion(diaryRecord)
        
        
    }
    
    
    
    
    func getDiaryRecord(_ diaryEntry : String, dateValue : String, status : String, onCompletion : ([String : AnyObject]) -> Void) {
        
        
        var diaryRecord : [String : AnyObject] = [:]
        
        
        // get baseString
        
        getBaseRecord("DIARY") { (baseRecord) -> Void in
            
            // set reference of weightRecord to the received baseRecord
            diaryRecord = baseRecord!
            
        }

        // get diary record
        
        diaryRecord["data"] = "{\"resourceType\" : \"Observation\", \"status\" : \"\(status)\", \"category\" : {\"coding\" : [{\"system\" : \"http://hl7.org/fhir/observation-category\", \"code\" : \"survey\", \"display\" : \"Survey\"}]}, \"code\" : {\"coding\" : [{\"system\" : \"http://loinc.org\", \"code\" : \"61150-9\", \"display\" : \"Subjective Narrative\"}]}, \"effectiveDateTime\" : \"\(dateValue)\", \"valueString\" : \"\(diaryEntry)\"}\"" as AnyObject?
        
        // send the weightRecord back to the calling function
        onCompletion(diaryRecord)
        
    }
    
    // get auth record string
    
    func getAuthRecord(_ username : String, password : String, onCompletion : ([String : AnyObject]) -> Void){
    
        
        // create authentication body. Call RestManager to get static appname and secret. set username & password equal to call params
        
        let authParams : [String: AnyObject] = ["appname" : "\(RestManager.sharedInstance.getAppname())" as AnyObject,
            "secret" : "\(RestManager.sharedInstance.getSecret())" as AnyObject,
            "username" : "\(username)" as AnyObject,
            "password" : "\(password)" as AnyObject ]
        
    
        // call onCompletion function of getAuthRecord
        onCompletion(authParams)
        
    }
    
    
    // get query record string
    
    func getQueryRecordWithFilter(_ status : String, filter : String, onCompletion : ([String : AnyObject]) -> Void) {
        
        // create search body. Get authToken from Keychain
        
        let status = ["status" : "\(status)"] // define data status attribute
        let greaterThanIndicator = ["$ge" : "\(filter)"] // set greater than value
        let indexFilter : [String : AnyObject] = ["effectiveDateTime" : greaterThanIndicator as AnyObject] // set filter
        let propertiesMap : [String : AnyObject] = ["owner" : "self" as AnyObject, "format": "fhir/Observation" as AnyObject, "content" : "activities/steps" as AnyObject, "data" : status as AnyObject, "index" : indexFilter as AnyObject] // set the key value map pairs for the properties attribute
        
        
        let searchParams : [String: Any] = ["authToken" : "\(getAuthToken())" as Any,  "fields" : ["data", "version", "content", "format", "owner"], "properties" : propertiesMap]
        
        onCompletion(searchParams as [String : AnyObject])
        
    }
    
    
    
    func getTimeStampQuery(_ status : String, timeStamp : String, onCompletion : ([String : AnyObject]) -> Void) {
        
        // create search body. Get authToken from Keychain
        
        let dataBody = ["status" : "\(status)", "effectiveDateTime" : timeStamp] // define data status attribute
        let propertiesMap : [String : AnyObject] = ["owner" : "self" as AnyObject, "format": "fhir/Observation" as AnyObject,"data" : dataBody as AnyObject] // set the key value map pairs for the properties attribute
        
        
        let searchParams : [String: Any] = ["authToken" : "\(getAuthToken())" as Any,  "fields" : ["data", "version", "content", "format", "owner"], "properties" : propertiesMap]
        
        onCompletion(searchParams as [String : AnyObject])
        
    }

    
    // get query record string
    
    func getQueryRecord(_ status : String, onCompletion : ([String : AnyObject]) -> Void) {
        
        // create search body. Get authToken from Keychain
        
        let status = ["status" : "\(status)"] // define data status attribute
        let greaterThanIndicator = ["$ge" : "2016-04-01"] // set greater than value
        let indexFilter : [String : AnyObject] = ["effectiveDateTime" : greaterThanIndicator as AnyObject] // set filter
        let propertiesMap : [String : AnyObject] = ["owner" : "self" as AnyObject, "format": "fhir/Observation" as AnyObject, "data" : status as AnyObject, "index" : indexFilter as AnyObject] // set the key value map pairs for the properties attribute
        
        let searchParams : [String: Any] = ["authToken" : "\(getAuthToken())" as Any,  "fields" : ["data", "version", "content", "owner"], "properties" : propertiesMap]

        onCompletion(searchParams as [String : AnyObject])
        
    }
    
    // get base record for api call
    
    fileprivate func getBaseRecord(_ entryType : String, onCompletion : ([String : AnyObject]?) -> Void) {
        
        // define the base String
        var baseString : [String : AnyObject]
        
        // define variables for params in baseString
        var baseStringName = ""
        var baseStringSubformat = ""
        var baseStringFormat = ""
        var baseStringContent = ""
        
        
        switch entryType {
            
        case "WEIGHT" :
            
            baseStringName = "Gewicht"
            baseStringSubformat = "Quantity"
            baseStringFormat = "fhir/Observation"
            baseStringContent = "http://loinc.org 3141-9"
            
        case "SUBJECTIVECONDITION" :
            
            baseStringName = "Subjektives Befinden"
            baseStringSubformat = "Quantity"
            baseStringFormat = "fhir/Observation"
            baseStringContent = "http://midata.coop subjective-condition"
            
            
        case "DIARY" :
            
            baseStringName = "Tagebuchkommentar"
            baseStringSubformat = "String"
            baseStringFormat = "fhir/Observation"
            baseStringContent = "http://loinc.org 61150-9"
            
        default :
            
            // if entryType variable does not match switch statement return nil
            onCompletion(nil)
            
        }
        
        
            // define the baseString and return to calling function
        
        baseString = ["authToken" : "\(getAuthToken())" as AnyObject,
        "name" : "\(baseStringName)" as AnyObject,
        "format" : "\(baseStringFormat)" as AnyObject,
        "subformat" : "\(baseStringSubformat)" as AnyObject,
        "content" : "\(baseStringContent)" as AnyObject,
        "data" : "" as AnyObject]
        
        onCompletion(baseString)
        
    }
    
    // get update header for update record
    
    fileprivate func getUpdateHeader(_ recordID : String, recordVersion : String, onCompletion : ([String : AnyObject]?) -> Void){
        
        
        
        // define the base String
        var updateString : [String : AnyObject]
        
        updateString = ["authToken" : "\(getAuthToken())" as AnyObject,
            "_id" : "\(recordID)" as AnyObject,
            "version" : "\(recordVersion)" as AnyObject,
            "data" : "" as AnyObject]
        
        onCompletion(updateString)
    }
    
    

}
