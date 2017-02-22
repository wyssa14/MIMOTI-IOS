//
//  AppDelegate.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 16/03/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//

import UIKit
import ReachabilitySwift
import Locksmith


// Reachability object
 private var reachability:Reachability!

// Get the shared UserDefaults object
let defaults = UserDefaults.standard


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // Get the shared UserDefaults object
    let defaults = UserDefaults.standard
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        // Set Server URL
   
        if let specifiedMidataAddress = self.defaults.value(forKey: "MIDATAADDRESS") as! String! {
            
        } else {
            
            self.defaults.setValue("https://test.midata.coop:9000/", forKey: "MIDATAADDRESS")
            
        }

        
        
        // request permission to send local notifications
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        
        
        // check whether app did launch before. If not send user to login view
        if(!didFinishLaunchingOnce()){
            
            
            // get the main thread since the background  might trigger UI updates
            DispatchQueue.main.async(execute: {
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let loginViewController: LoginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                
                self.window?.rootViewController = loginViewController
                
                self.window?.makeKeyAndVisible()
                
            })
        }
        
        
        // allocate Reachability Object
        
        do {
            
            reachability = Reachability.init()
            
        } catch {
            print("unable to create Reachability!")
        }
        
        // set up the notification center to detect and inform about changing connection states
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
        
        // start notification observer
        do{
            
            try reachability?.startNotifier()
            
        }catch{
            print("could not start reachability notifier")
        }
        
        
        
        // if user defaults values have been previously set, recreate local notifications
        if(UserDefaults.standard.bool(forKey: "switchState") && UserDefaults.standard.string(forKey: "notificationHour") != nil && UserDefaults.standard.string(forKey: "notificationMinute") != nil){
            
            print("settings set")
            
            createLocalNotification()
            
        }
        
        
        return true
    }
    
    
    // create the local notification object and set its fire date and attributes
    func createLocalNotification(){
        
        // first remove previous set notifications (notifications fire daily by default).
        UIApplication.shared.cancelAllLocalNotifications()
        
        let notification = UILocalNotification()
        let calendar = Calendar.current
        
        
        let hourValue = UserDefaults.standard.integer(forKey: "notificationHour")
        let minuteValue = UserDefaults.standard.integer(forKey: "notificationMinute")
        
        let notiDate = (calendar as NSCalendar).date(bySettingHour: hourValue, minute: minuteValue, second: 0, of: Date(), options: .wrapComponents)
        
        notification.fireDate = notiDate
        
        notification.timeZone = Calendar.current.timeZone
        notification.repeatInterval = .day
        notification.alertBody = "Bitte nehmen Sie sich kurz Zeit für einen neuen Eintrag in der MIMOTI-App!"
        notification.alertAction = ""
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["Information": "MIMOTI Entry"]
        UIApplication.shared.scheduleLocalNotification(notification)
        
        // uncomment for troubleshooting
        // print("Notification Created on a daily basis: Hours: \(hourValue) Minutes: \(minuteValue)")
        
    }
    
    
    // method gets called from within the notification center. Verfifies changes of network connectivity
    func reachabilityChanged(_ note: Notification) {
        
        let reachability = note.object as! Reachability
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if reachability.isReachable {
           
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            
            // check again, whether the app has been used before since this will trigger a different view
            if (didFinishLaunchingOnce()){
                
                // get the main thread since the background  might trigger UI updates
                DispatchQueue.main.async(execute: {
                    
                    var backViewController: UIViewController
                    
                    backViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    UIApplication.shared.keyWindow?.rootViewController = backViewController
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                    
                })
                
            } else {
                
                // get the main thread since the background  might trigger UI updates
                DispatchQueue.main.async(execute: {
                    
                    var backViewController: UIViewController
                    
                    backViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    UIApplication.shared.keyWindow?.rootViewController = backViewController
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                    
                })
            }
            
        } else {
            print("Network not reachable")
            
            // get the main thread since the background  might trigger UI updates
            DispatchQueue.main.async(execute: {
                
                let offlineViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "OfflineViewController") as! OfflineViewController
                
                self.window?.rootViewController = offlineViewController
                self.window?.makeKeyAndVisible()
                
            })
        }
    }
    
    
    // helper method. Returns true or false based on existence of defaults value for defined key
    func didFinishLaunchingOnce() -> Bool
    {
        
        if let hasBeenLaunchedBefore = defaults.string(forKey: "launchedBefore")
        {
            print("application has launched already")
            return true
        }
        else
        {
            
            print("application launched for the first time")
            
            
            do {
                // set authToken in Locksmith Keychain wrapper to 'noToken'
                try Locksmith.updateData(data: ["authToken" : "noToken"], forUserAccount: "USER")
            }
            catch {
                print("data could not be stored in locksmith")
                
            }
            return false
        }
    }
    
    
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let backViewController : UIViewController
        
        backViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        UIApplication.shared.keyWindow?.rootViewController = backViewController
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

