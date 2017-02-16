//
//  TimePickerViewControllDelegate.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 25/04/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//


import UIKit


// Delegate method of PopTimeViewController must
// implement method for handling dismiss event of
// the date picker

protocol TimePickerViewControllDelegate: class {
    
    func timePickerVCDismissed(_ date: Date?)
}



class PopTimeViewController: UIViewController {
    
    // Initialize DatePicker & UIView Container
    
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var viewContainer: UIView!
    
    // Initializing the delegate variable
    weak var delegate : TimePickerViewControllDelegate?
    
    
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
            
            self.delegate?.timePickerVCDismissed(nsdate)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // operate in Time and Hours
        self.datePicker.datePickerMode = UIDatePickerMode.time
        
        updatePickerCurrentDate()
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.delegate?.timePickerVCDismissed(nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
