//
//  PopTimePicker.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 25/04/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//


import UIKit

class PopTimePicker: NSObject, UIPopoverPresentationControllerDelegate, TimePickerViewControllDelegate {
    
    
    public typealias PopTimePickerCallback = (_ newDate : Date, _ forTextField : UITextField) ->()
    
    
    var timePickerViewController : PopTimeViewController
    var popover : UIPopoverPresentationController?
    var textField : UITextField!
    var dataChanged : PopTimePickerCallback?
    var presented = false
    var offset : CGFloat = 8.0
    
    
    
    // initialize the PopTimePicker
    
    public init(forTextField : UITextField){
        
        timePickerViewController = PopTimeViewController()
        self.textField = forTextField
        super.init()
    }
    
    
    open func pick(_ inViewController: UIViewController, initDate : Date?, dataChanged: @escaping PopTimePickerCallback) {
        
        if presented {
            return
        }
        
        
        // prepare the PopTimeViewController
        timePickerViewController.delegate = self
        timePickerViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        timePickerViewController.preferredContentSize = CGSize(width: 500,height: 250)
        timePickerViewController.currentDate = initDate
        
        // present the PopTimeViewController in a "Popover"-View
        popover = timePickerViewController.popoverPresentationController
        
        if let _popover = popover {
            
            // source for the popover
            _popover.sourceView = textField
            _popover.sourceRect = CGRect(x: self.offset, y: textField.bounds.size.height,width: 0,height: 0)
            _popover.delegate = self
            self.dataChanged = dataChanged
            
            // present the PopTimeViewController in the submitted View
            inViewController.present(timePickerViewController, animated: true, completion: nil)
            presented = true
            
        }
        
    }
    
    
    open func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .none
        
    }
    
    
    func timePickerVCDismissed(_ date: Date?) {
        if let _dataChanged = dataChanged {
            
            if let _date = date {
                _dataChanged(_date, textField)
            }
            
        }
        presented = false
    }
    
    
    
}
