//
//  DateUtils.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 15/03/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//

import UIKit
import Foundation

// extension of NSDate. Helper functions for conversion of date -> string

extension Date {
    
    
    func toDateMediumString() -> NSString? {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self) as NSString?
    }
    
    
    func toTimeMediumString() -> NSString? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self) as NSString?
    }
    
    
    
    func extractTimeStamp() -> NSString {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return formatter.string(from: self) as NSString
        
    }
}
