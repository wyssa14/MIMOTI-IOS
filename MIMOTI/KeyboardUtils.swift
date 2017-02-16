//
//  KeyboardUtils.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 17/04/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    
    // extension of the UIViewController class. Hide keyboard when tapped outside
    
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
}
