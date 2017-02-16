//
//  ViewController.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 25/02/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//

import UIKit
import Charts

class RecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recordsTableView: UITableView!
    
    // local arrays
    var weightRecords: [WeightRecord] = []
    var subjectiveConditionRecords: [SubjectiveCondition] = []
    var diaryComments: [DiaryRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        // make sure arrays are clean
        weightRecords.removeAll()
        subjectiveConditionRecords.removeAll()
        diaryComments.removeAll()
        self.recordsTableView.reloadData()
        
        
        // get & update records in tableview everytime the user loads the view
        RestManager.sharedInstance.getRecords("preliminary") { (json, flag) -> Void in
            
            
            // check for error flag
            
            if (flag){
                
                // get the main thread since the background  might trigger UI updates
                DispatchQueue.main.async(execute: {
                    
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let loginViewController: LoginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    
                    UIApplication.shared.keyWindow!.rootViewController = loginViewController
                    
                    UIApplication.shared.keyWindow!.window?.makeKeyAndVisible()
                    
                })

                
            }
            
            // serialize json and map into record classes
            
            for (key, subJson) in json {
                
                // only consider records with status 'preliminary'
                if(subJson["data"]["status"] == "preliminary"){
                    
                    // create and append weight object if record type weight
                    if(subJson["data"]["code"]["coding"][0]["code"] == "3141-9"){
                        
                        
                        self.weightRecords.append(WeightRecord(oid: subJson["_id"].string!, version: subJson["version"].string!, effectiveDateTime: subJson["data"]["effectiveDateTime"].string!, weightValue: subJson["data"]["valueQuantity"]["value"].double!))
                        
                    } else if(subJson["data"]["code"]["coding"][0]["code"] == "subjective-condition"){
                        
                        
                        self.subjectiveConditionRecords.append(SubjectiveCondition(oid: subJson["_id"].string!, version: subJson["version"].string!, effectiveDateTime: subJson["data"]["effectiveDateTime"].string!, value: subJson["data"]["valueQuantity"]["value"].double!))
                        
                        
                    } else if(subJson["data"]["code"]["coding"][0]["code"] == "61150-9"){
                        
                        
                        self.diaryComments.append(DiaryRecord(oid: subJson["_id"].string!, version: subJson["version"].string!, effectiveDateTime: subJson["data"]["effectiveDateTime"].string!, comment: subJson["data"]["valueString"].string!))
                        
                        
                    }
                    
                    
                }
                
            }
            
            
            // sort records
            self.sortRecords()
            
            
          // reload data
            
          DispatchQueue.main.async(execute: {
            
          self.recordsTableView.reloadData()
        })
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // remove all records from array if the user leaves the current view
        weightRecords.removeAll()
        subjectiveConditionRecords.removeAll()
        diaryComments.removeAll()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weightRecords.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RecordCell
        
        // keep integrity of the record
        cell.effectiveDate = self.weightRecords[indexPath.row].effectiveDateTime

        // set labels for the tableview cells according to the variables stored in the corresponding arrays
        
        cell.dateValue.text = convertString(self.weightRecords[indexPath.row].effectiveDateTime)
        
        if (self.weightRecords[indexPath.row].weightValue == 0){
        
        cell.noWeightIcon.isHidden = false
        cell.weightValue.isHidden = true
        cell.noWeightIcon.image = UIImage(named: "noMood")
        
        } else
        {
       
        cell.noWeightIcon.isHidden = true
        cell.weightValue.isHidden = false
        cell.weightValue.text = "\(self.weightRecords[indexPath.row].weightValue) kg"
        }
        
        if let index = diaryComments.index (where: {$0.effectiveDateTime == self.weightRecords[indexPath.row].effectiveDateTime}){
            
            cell.commentValue.text = self.diaryComments[index].comment
            
        }
        
        
        if let index = subjectiveConditionRecords.index (where: {$0.effectiveDateTime == self.weightRecords[indexPath.row].effectiveDateTime}){
            
            
            if (self.subjectiveConditionRecords[index].value == 0){
                
                cell.conditionIcon.image = UIImage(named: "noMood")
                
            } else
                
            {

            
            if self.subjectiveConditionRecords[index].value == 3{
                
                cell.conditionIcon.image = UIImage(named: "moodGood")
                
            }
            
            if self.subjectiveConditionRecords[index].value == 2{
                
                cell.conditionIcon.image = UIImage(named: "moodNeutral")
                
            }
            
            if self.subjectiveConditionRecords[index].value == 1 {
                
                cell.conditionIcon.image = UIImage(named: "moodSad")
                
            }
                
            }
         
        }
        
        // return the cell
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell : RecordCell = tableView.cellForRow(at: indexPath) as! RecordCell
        
        
        if (cell.commentValue.text!.isEmpty){
            
        return
        
        } else
        {
            
        // create the alert
        let alert = UIAlertController(title: "\(cell.dateValue.text!)", message: "\(cell.commentValue.text!)", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
        
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        return "Löschen"
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
          // update Records on Midata Server

            
            RestManager.sharedInstance.postWeight(weightRecords[indexPath.row].weightValue, dateValue: weightRecords[indexPath.row].effectiveDateTime, status: "entered-in-error", recordID: weightRecords[indexPath.row].oid, recordVersion: weightRecords[indexPath.row].version, onCompletion: { (json, flag) -> Void in
                
                print(json)
                
            })
            
            
            
            
            
            if let index = diaryComments.index (where: {$0.effectiveDateTime == self.weightRecords[indexPath.row].effectiveDateTime}){
                
            RestManager.sharedInstance.postDiary(diaryComments[index].comment, dateValue: diaryComments[index].effectiveDateTime, status: "entered-in-error", recordID: diaryComments[index].oid, recordVersion: diaryComments[index].version, onCompletion: { (json, flag) -> Void in
                
                print(json)
            })
                
            self.diaryComments.remove(at: index)
            
            }

            
            
            
            if let index = subjectiveConditionRecords.index (where: {$0.effectiveDateTime == self.weightRecords[indexPath.row].effectiveDateTime}){
                
            
                
            RestManager.sharedInstance.postCondition(subjectiveConditionRecords[index].value, dateValue: subjectiveConditionRecords[index].effectiveDateTime, status: "entered-in-error", recordID: subjectiveConditionRecords[index].oid, recordVersion: subjectiveConditionRecords[index].version, onCompletion: { (json, flag) -> Void in
                
                print(json)
                
            })
                
                
               self.subjectiveConditionRecords.remove(at: index)
                
            }
            
            
            
            
            // remove at the very end. Otherwise this would create a Array index out of bound Exception for the subsequent operations
            self.weightRecords.remove(at: indexPath.row)
            
            
            
            
            tableView.reloadData()
            
        }
    }
    
    
    // helper function. Sort the Records in all arrays
    fileprivate func sortRecords() -> Void {
        
        
        self.weightRecords.sort(by: {$0.effectiveDateTime > $1.effectiveDateTime})

        
        self.subjectiveConditionRecords.sort(by: {$0.effectiveDateTime > $1.effectiveDateTime})

        
        self.diaryComments.sort(by: {$0.effectiveDateTime > $1.effectiveDateTime})
        
    }
    
    
    // helper function. converts a string into another format for display
    fileprivate func convertString(_ stringToSplit : String) -> String {
        
        let strSplit = stringToSplit.characters.split(separator: "T")
        _ = String(strSplit.first!)
        let second = String(strSplit.last!)
        
        
        let splittedDate = String(strSplit.first!)
        
        
        let splittedDetailled = splittedDate.characters.split(separator: "-")
        
        let splittedDay = String(splittedDetailled[2])
        let splittedMonth = String(splittedDetailled[1])
        let splittedYear = String(splittedDetailled[0])
        
        
        
        let splittedTime = String(strSplit.last!)
        
        let splittedTimeDetailled = splittedTime.characters.split(separator: ":")
        
        let hh = String(splittedTimeDetailled[0])
        let mm = String(splittedTimeDetailled[1])
        
        
        return "\(splittedDay).\(splittedMonth).\(splittedYear) | \(hh):\(mm)"
        
    }
    
    
    
    
    
}
