//
//  PopDateViewController.swift
//  Adrian Wyss
//
//  Created by Adrian Wyss on 15/03/16.
//  Copyright © 2016 Adrian Wyss. All rights reserved.
//

import UIKit

class PopDatePicker: NSObject, UIPopoverPresentationControllerDelegate, DataPickerViewControllDelegate {
    
    
    public typealias PopDatePickerCallback = (_ newDate : Date, _ forTextField : UITextField) ->()
    
    
    var datePickerViewController : PopDateViewController
    var popover : UIPopoverPresentationController?
    var textField : UITextField!
    var dataChanged : PopDatePickerCallback?
    var presented = false
    var offset : CGFloat = 8.0
    
    
    
    // initialize the PopDatePicker
    
    public init(forTextField : UITextField){
        
        datePickerViewController = PopDateViewController()
        self.textField = forTextField
        super.init()
    }
    
    
    open func pick(_ inViewController: UIViewController, initDate : Date?, dataChanged: @escaping PopDatePickerCallback) {
        
        if presented {
            return
        }
        
        
        // prepare the PopDateViewController
        datePickerViewController.delegate = self
        datePickerViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        datePickerViewController.preferredContentSize = CGSize(width: 500,height: 250)
        datePickerViewController.currentDate = initDate
        
        // present the PopDateViewController in a "Popover"-View
        popover = datePickerViewController.popoverPresentationController
        
        if let _popover = popover {
            
            // source for the popover
            _popover.sourceView = textField
            _popover.sourceRect = CGRect(x: self.offset, y: textField.bounds.size.height,width: 0,height: 0)
            _popover.delegate = self
            self.dataChanged = dataChanged
            
            // present the PopDatePickerViewController in the submitted View
            inViewController.present(datePickerViewController, animated: true, completion: nil)
            presented = true
            
        }
        
    }
    
    
    open func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .none
        
    }
    
    
    func datePickerVCDismissed(_ date: Date?) {
        if let _dataChanged = dataChanged {
            
            if let _date = date {
                _dataChanged(_date, textField)
            }
            
        }
        presented = false
    }
    
    

}
