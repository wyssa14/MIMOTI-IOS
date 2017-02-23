//
//  ReminderViewController.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 09/04/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//

import UIKit
import Locksmith

class InfoViewController: UITableViewController, UITextFieldDelegate {
    
    // initialize the timeDatePicker
    var timeDatePicker : PopTimePicker?
    
    
    // Get the shared UserDefaults object
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var notificationTimeTextfield: UITextField!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    
    override func viewDidLoad() {
    
        // enable the reminder save button
        saveButton.isEnabled = true
        

        
        
        // if the default object contains a value for key 'username' assign it to the userNameTextField text representation
        if let defaultsUsername = defaults.value(forKey: "USERNAME"){
            userNameTextField.text = defaultsUsername as? String
            userNameTextField.isUserInteractionEnabled = false
            
            
        }
        
        // Asign timeDatePicker to dateTextField
        timeDatePicker = PopTimePicker(forTextField: notificationTimeTextfield)
        notificationTimeTextfield.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // enable the reminder save button
         saveButton.isEnabled = true
        
        // check if the user has already set a notification and set hour and minute of the pickerview to the corresponding values
        
        if(UserDefaults.standard.string(forKey: "notificationHour") != nil && UserDefaults.standard.string(forKey: "notificationMinute") != nil){
            
            let calendar : Calendar = Calendar.current
            var components = (calendar as NSCalendar).components([.hour, .minute], from: Date())
            
            let hourValue : Int = UserDefaults.standard.integer(forKey: "notificationHour")
            let minuteValue : Int = UserDefaults.standard.integer(forKey: "notificationMinute")
            
            components.hour = hourValue
            components.minute = minuteValue
            
         
            // set the values of the notificationTextField
            
            notificationTimeTextfield.text = (calendar.date(from: components)?.toTimeMediumString() ?? "?") as String
            
        } else {
            
            // if no value has been set, set the default value to 09:00 am
            notificationTimeTextfield.text = "09:00"
            
            
        }
        
        // enable / disable notificationTextField based on state of the UISwitch
        
        if(UserDefaults.standard.bool(forKey: "switchState")){
            
            reminderSwitch.isOn = true
            
            notificationTimeTextfield.isEnabled = true
            notificationTimeTextfield.isUserInteractionEnabled = true
            
            if(UserDefaults.standard.string(forKey: "notificationHour") != nil && UserDefaults.standard.string(forKey: "notificationMinute") != nil){
                
                let calendar : Calendar = Calendar.current
                var components = (calendar as NSCalendar).components([.hour, .minute], from: Date())
                
                let hourValue : Int = UserDefaults.standard.integer(forKey: "notificationHour")
                let minuteValue : Int = UserDefaults.standard.integer(forKey: "notificationMinute")
                
                components.hour = hourValue
                components.minute = minuteValue
                
                // set the values of the notificationTextField
                notificationTimeTextfield.text = (calendar.date(from: components)?.toTimeMediumString() ?? "?") as String
            }
            
            // enable the saveButton if the user has already set notifications
            saveButton.isEnabled = true
            
        } else {
            
            // disable icons & textfields if the switchState flag is not set in the NSUserDefaults
            reminderSwitch.isOn = false
            saveButton.isEnabled = false
            
            
            notificationTimeTextfield.isEnabled = false
            notificationTimeTextfield.isUserInteractionEnabled = false
            
        }
    }
    
    
    // update the timePickerView
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if (textField === notificationTimeTextfield){
            resign()
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            let initDate : Date? = formatter.date(from: notificationTimeTextfield.text!)
            
            let dataChangedCallback : PopTimePicker.PopTimePickerCallback = { (newDate : Date, forTextField : UITextField) -> () in
                forTextField.text = (newDate.toTimeMediumString() ?? "?") as String
            }
            
            // call callback function when the date value has changed
            timeDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
            
            return false
            
        } else {
            return true
        }
    }
    
    
    // dismiss textfield when user presses the return button
    func resign(){
        notificationTimeTextfield.resignFirstResponder()
    }
    
    

    @IBAction func logoutTapped(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Logout bestätigen", message: "Möchten Sie sich wirklich ausloggen?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
           
            do {
                
                try Locksmith.deleteDataForUserAccount(userAccount: "USER")
                
                
                // get the main thread since the background  might trigger UI updates
                DispatchQueue.main.async(execute: {
                    
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let loginViewController: LoginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    
                    UIApplication.shared.keyWindow!.rootViewController = loginViewController
                    
                    UIApplication.shared.keyWindow!.window?.makeKeyAndVisible()
                    
                })
                
            } catch {
                
                print("Internal error while accessing Locksmith")
                
            }
        }))

        alert.addAction(UIAlertAction(title: "Abbrechen", style: .default, handler: {[weak alert] (_) in
            
            return false
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
        }
    
   
     // if the user taps the UISwitch perform actions
    
    
    // if UISwitch is on enable save button, unhide pickerView and save state to keep configuration when the user will re enter the view
    @IBAction func switchStateChanged(_ sender: AnyObject) {
    
        
        if self.reminderSwitch.isOn {
            
            notificationTimeTextfield.isEnabled = true
            notificationTimeTextfield.isUserInteractionEnabled = true
            
            saveButton.isEnabled = true
            UserDefaults.standard.set(reminderSwitch.isOn, forKey: "switchState")
            UserDefaults.standard.synchronize()
            
            
            
            
            
            if(UserDefaults.standard.string(forKey: "notificationHour") != nil && UserDefaults.standard.string(forKey: "notificationMinute") != nil){
                
                let calendar : Calendar = Calendar.current
                var components = (calendar as NSCalendar).components([.hour, .minute], from: Date())
                
                let hourValue : Int = UserDefaults.standard.integer(forKey: "notificationHour")
                let minuteValue : Int = UserDefaults.standard.integer(forKey: "notificationMinute")
                
                components.hour = hourValue
                components.minute = minuteValue
                
                // set the values of the notificationTextField
                notificationTimeTextfield.text = (calendar.date(from: components)?.toTimeMediumString() ?? "?") as String
            } else {
                
                // default values if no values have been set by the user
                
                notificationTimeTextfield.text = "09:00"
                 saveButton.isEnabled = true
            }

            
            // if UISwitch is off disable the save button, hide the pickerView and remove params from settings. Keep integrity when user will re enter the view
            
        } else {
            
            notificationTimeTextfield.isEnabled = false
            notificationTimeTextfield.isUserInteractionEnabled = false
            notificationTimeTextfield.text = ""

            saveButton.isEnabled = false
            UIApplication.shared.cancelAllLocalNotifications()
            UserDefaults.standard.removeObject(forKey: "switchState")
            UserDefaults.standard.removeObject(forKey: "notificationHour")
            UserDefaults.standard.removeObject(forKey: "notificationMinute")
            UserDefaults.standard.synchronize()
            
            
            
        }
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if (section == 0) {
        return 1
        } else if (section == 1){
            return 3
        }
        
        return 4
    
    }
    
    @IBAction func saveTapped(_ sender: AnyObject) {
  
        // set the notification settings and create the notification schedule
        
        guard let settings = UIApplication.shared.currentUserNotificationSettings else { return }
        
        if settings.types == UIUserNotificationType() {
            let ac = UIAlertController(title: "Fehler beim Erstellen der Erinnerung", message: "MIMOTI hat keine Berechtigungen zum Erstellen von Erinnerungen. Erteilen Sie MIMOTI die benötigten Berechtigungen und versuchen Sie es bitte erneut.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            return
        }
        
        
        if (notificationTimeTextfield.text!.isEmpty){
            
            print("Textfield is empty - return")
            return
        }
        
        // extract date components from notification textfield
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        var myDate = formatter.date(from: notificationTimeTextfield.text!)
        
        
        
        let notification = UILocalNotification()
        let calendar = Calendar.current
        
        let dateComponents = (Calendar.current as NSCalendar).components([.hour, .minute], from: myDate!)
        
        
        // first remove previous set notifications (notifications fire daily by default).
        UIApplication.shared.cancelAllLocalNotifications()
        
        // create the local notification object and set its fire date and attributes
        
        let notiDate = (calendar as NSCalendar).date(bySettingHour: dateComponents.hour!, minute: dateComponents.minute!, second: 0, of: Date(), options: .wrapComponents)
        
        notification.fireDate = notiDate
        
        notification.timeZone = Calendar.current.timeZone
        notification.repeatInterval = NSCalendar.Unit.day
        notification.alertBody = "Bitte nehmen Sie sich kurz Zeit für einen neuen Eintrag in der MIMOTI-App!"
        notification.alertAction = ""
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["Information": "MIMOTI Entry"]
        UIApplication.shared.scheduleLocalNotification(notification)
        
        // add the notification time to the NSUserDefaults so that MIMOTI keeps track when it gets closed and reopened
        
        UserDefaults.standard.set(dateComponents.hour, forKey: "notificationHour")
        UserDefaults.standard.set(dateComponents.minute, forKey: "notificationMinute")
        
        UserDefaults.standard.set(reminderSwitch.isOn, forKey: "switchState")
        UserDefaults.standard.synchronize()
        
        let okController = UIAlertController(title: "Eingabe übernommen", message: "Ihr gewünschter Erinnerungszeitpunkt wurde gesetzt.", preferredStyle: .alert)
        okController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(okController, animated: true, completion: nil)

        // uncomment for troubleshooting
        // print("Notification Created on a daily basis: Hours: \(dateComponents.hour) Minutes: \(dateComponents.minute)")
    }
    
}


