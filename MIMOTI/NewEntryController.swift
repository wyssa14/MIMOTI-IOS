//
//  ViewController.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 25/02/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//

import UIKit

class NewEntryController: UIViewController, UITextFieldDelegate {
    
    
    // initialize the popDatePicker
    var popDatePicker : PopDatePicker?
    
    // initialize views and form fields
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var commentTextView: UITextView!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var conditionSegmentedControl: UISegmentedControl!
    
    
    // Toolbar for keyboard of weightTextField
    //let numberToolbar : UIToolbar = UIToolbar()
    
    var timeStamps : [String] = []
    var equalsFound = false
    
    // variable for current date & time in datefield
    var currentDateValueInTextfield: String = ""
    var locked : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        
        // set keyboard for weightTextField
        self.weightTextField.delegate = self
        self.weightTextField.keyboardType = UIKeyboardType.decimalPad
        
        
        
        // enable conditionSegmentedControl fragments
        self.conditionSegmentedControl.setEnabled(true, forSegmentAt: 0)
        self.conditionSegmentedControl.setEnabled(true, forSegmentAt: 1)
        self.conditionSegmentedControl.setEnabled(true, forSegmentAt: 2)
        
        
        
        // set scrolling pane of scrollView
        scrollView.contentSize.height = 400
        
        // set style of commentTextView
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = (UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)).cgColor
        commentTextView.layer.cornerRadius = 5
        
        // Asign PopDatePicker to dateTextField
        popDatePicker = PopDatePicker(forTextField: dateTextField)
        dateTextField.delegate = self
        
        
        // set dateField to current time
        let currentDateTime = Date()
        dateTextField.text = (currentDateTime.toDateMediumString() ?? "?") as String
        self.currentDateValueInTextfield = currentDateTime.extractTimeStamp() as String
        
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView){
        animateViewMoving(true, moveValue: 190)
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView){
        animateViewMoving(false, moveValue: 190)
    }
    
    
    // helper function. sliding the textfields when keyboard appears
    func animateViewMoving (_ up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
    
    
    // dismiss textfield when user presses the return button
    func resign(){
        dateTextField.resignFirstResponder()
    }
    
    // update the datePickerView
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if (textField === dateTextField){
            resign()
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            let initDate : Date? = formatter.date(from: dateTextField.text!)
            
            let dataChangedCallback : PopDatePicker.PopDatePickerCallback = { (newDate : Date, forTextField : UITextField) -> () in
                
                forTextField.text = (newDate.toDateMediumString() ?? "?") as String
                self.currentDateValueInTextfield = newDate.extractTimeStamp() as String
                
            }
            
            // call callback function when the date value has changed
            popDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
            return false
            
        }
            
        else if (textField == weightTextField) {
            
            // open alertview where the user can enter his current weight
            
            let alert = UIAlertController(title: "Gewichtseingabe", message: "Bitte geben Sie Ihr aktuelles Gewicht in Kilogramm ein.", preferredStyle: .alert)
            
            
            alert.addTextField(configurationHandler: { (textField) -> Void in
                textField.text = self.weightTextField.text
                textField.keyboardType = UIKeyboardType.decimalPad
            })
            
            // grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "Fertig", style: .default, handler: { (action) -> Void in
                let textField = alert.textFields![0] as UITextField
                
                self.weightTextField.text = textField.text
                
                
            }))
            
            // present the alert.
            self.present(alert, animated: true, completion: nil)
            
            return true
        } else {
            
            return true
        }
    }

    
    
    // dismiss custom numberPad keyboard on return ('Wert übernehmen')
    func numberPadCancel() {
        weightTextField.resignFirstResponder()
    }
    
    
    // dismiss keyboard for comment field on return
    func textView(_ textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // return on 'done' - dismiss keyboard
        textField.resignFirstResponder();
        return true;
    }
    
    
    
    // Action when "Speichern" button is tapped
    
    
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        
    
        if(!checkValidDouble()){
            
            
            // create the alert
            let alert = UIAlertController(title: "Falsches Zahlenformat", message: "Bitte geben Sie eine gültige Kommazahl zwischen 10 und 999 Kilogramm ein. Bsp. 95 oder 95.3", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else
            
        {
            
            // query and check for equal timestamps. present alert if true
            if(checkEqualTimestamps()) {
                
                
                // create the alert
                let alert = UIAlertController(title: "Eintrag bereits vorhanden", message: "Unter dieser Datumsangabe existiert bereits ein Eintrag. Bitte wählen Sie ein anderes Datum.", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                
                // check whether the strucutre of the inputs are ok for submission
                
            } else
            {
                
                if(okForGeneration()){
                    
                    // send proper weight Values to MIDATA
                    
                    var weightDouble : Double
                    
                    if((weightTextField.text!.isEmpty)){
                        
                        weightDouble = 0
                        
                    } else {
                        
                        weightDouble = Double(weightTextField.text!)!
                    }
                    
                    
                    RestManager.sharedInstance.postWeight(weightDouble, dateValue: self.currentDateValueInTextfield, status: "preliminary") { (json) -> Void in
                        print(json)
                    }
                    
                    
                    // Transfer arrayIndex to corresponding MIMOTI Code
                    let conditionValueString : String = String(conditionSegmentedControl.selectedSegmentIndex)
                    
                    var toTransmitCondition : Double = 0
                    
                    
                    if(conditionValueString == "0"){
                        
                        toTransmitCondition = 1
                        
                    } else if(conditionValueString == "1"){
                        
                        toTransmitCondition = 2
                        
                    } else if (conditionValueString == "2"){
                        
                        toTransmitCondition = 3
                        
                    }
                    
                    // send records to Midata
                    
                    RestManager.sharedInstance.postCondition(toTransmitCondition, dateValue: self.currentDateValueInTextfield, status: "preliminary") { (json) -> Void in
                        print(json)
                    }
                    
                    RestManager.sharedInstance.postDiary(commentTextView.text, dateValue: self.currentDateValueInTextfield, status: "preliminary") { (json) -> Void in
                        print(json)
                    }
                    
                    
                    // go back to previous view
                    self.dismiss(animated: true, completion: nil)
                    
                }
                    
                    // present error when no value has been set by the user
                    
                else {
                    
                    // create the alert
                    let alert = UIAlertController(title: "Fehler beim Ausfüllen", message: "Bitte erfassen Sie mindestens einen Wert.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
        }
    }
    
    
    
    
    // check whether records are ok for submission
    
    fileprivate func okForGeneration() -> Bool {
        
        
        if (self.weightTextField.text == nil || self.weightTextField.text! == ""){
            
            if (self.commentTextView.text == nil || self.commentTextView.text! == ""){
                
                if (self.conditionSegmentedControl.selectedSegmentIndex == -1) {
                    
                    return false
                    
                }
                
            }
        }
        
        
        // round weightValue (eg 34.58 --> 34.6)
        
        if let weightValue = Double(weightTextField.text!){
            
            let rounded = String(format: "%.1f", weightValue)
            self.weightTextField.text = rounded
            
        }
        
        
        // regex for commentView
        
        if commentTextView.text != nil {
            
            let cleanedString = removeSpecialCharsFromComment(commentTextView.text)
            
            self.commentTextView.text = cleanedString
        }
        
        
        return true
        
    }
    
    
    // function check for equal timestamps
    fileprivate func checkEqualTimestamps() -> Bool {
        
         //lock the main thread since data from the completion handler is needed
         self.locked = true
        
        
        RestManager.sharedInstance.checkForEqualTimestamp("preliminary", timeStamp: self.currentDateValueInTextfield) { (json, flag) -> Void in
            
            // check for error flag
            
            if (flag){
                
                DispatchQueue.main.async {
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    var loginViewController: LoginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    
                    UIApplication.shared.keyWindow!.rootViewController = loginViewController
                    
                    UIApplication.shared.keyWindow!.window?.makeKeyAndVisible()
                    
                    
                }
                
                
            }
            
            
            print(json.count)
            
            // serialize json from api call
            
            for (key, subJson) in json {
                
                // only consider records with status 'preliminary'
                if(subJson["data"]["status"] == "preliminary"){
                    
                    self.timeStamps.append(subJson["data"]["effectiveDateTime"].string!)
                    
                }
            }
         
            
            // iterate through timestamps array. When there's a match (equal timestamps) display alert view
            
            
            for timestampValues in self.timeStamps {
                
                print(timestampValues)
                
                print("compared \(self.currentDateValueInTextfield) with \(timestampValues)")
                
                if(self.currentDateValueInTextfield == timestampValues){
                    
                    self.equalsFound = true
                    
                    
                } else {
                    self.equalsFound = false
                }
                
                
                
            }
            
            // unlock main thread since operation has finished
            self.locked = false

            
        }
        
        
        // stop main thread while locked = true
        while(locked){wait()}
        
        
        // no equal timeStamps have been found. Return false
        return equalsFound
    }
    
    
    // check whether user input is valid (range & format)
    
    fileprivate func checkValidDouble() -> Bool {
        
        if(weightTextField.text!.isEmpty){
            
            return true
            
            
        }
        
        if let number = NumberFormatter().number(from: weightTextField.text!) {
            
            if (number.doubleValue >= 10 && number.doubleValue <= 999){
                
                print("Valid Double")
                return true
            }
            
            else {
             return false
            }
            
        } else {
            
            print("Invalid Double")
            return false
        }
        
    }
    
    
    // dismiss view, when the user taps 'Abbrechen' button
    
    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        // go back to previous view
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // remove "-characters from comment string
    
    func removeSpecialCharsFromComment(_ commentString : String) -> String {
        
        
    return commentString.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil)
        
    }
    
    // stop main thread while locked = true
    
    func wait()
    {
        RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 1))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
