//
//  PopDateViewController.swift
//  Adrian Wyss
//
//  Created by Adrian Wyss on 15/03/16.
//  Copyright © 2016 Adrian Wyss. All rights reserved.
//

import UIKit


// Delegate method of PopDateViewController must
// implement method for handling dismiss event of
// the date picker

protocol DataPickerViewControllDelegate: class {
    
    func datePickerVCDismissed(_ date: Date?)
}



class PopDateViewController: UIViewController {
    
    // Initialize DatePicker & UIView Container
    

    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var viewContainer: UIView!
    
    // Initializing the delegate variable
    weak var delegate : DataPickerViewControllDelegate?
    
    
    var currentDate : Date? {
        didSet {
            updatePickerCurrentDate()
        }
    }
    
    
     convenience init() {
        
        self.init(nibName: "PopDateViewController", bundle:nil)
        
    }
    
    fileprivate func updatePickerCurrentDate(){
        
        if let _currentDate = self.currentDate {
            if let _datePicker = self.datePicker {
                _datePicker.date = _currentDate
            }
        }
    }
    
    
    
    @IBAction func selectAction(_ sender: AnyObject) {
        
        self.dismiss(animated: true) {
            
            let nsdate = self.datePicker.date
            
            self.delegate?.datePickerVCDismissed(nsdate)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        // set the maximumDate of the DatePicker to the current one
        self.datePicker.maximumDate = Date()
        updatePickerCurrentDate()
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.delegate?.datePickerVCDismissed(nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
