//
//  StepsRecord.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 10/04/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//

import Foundation

// simple model class for mapping of Midata StepsRecords

class StepsRecord {
    
    
    var oid: String = ""
    var version: String = ""
    var effectiveDateTime: String = ""
    var stepsValue: String = ""
    
    
    init(oid: String, version: String, effectiveDateTime: String, stepsValue: String){
        
        
        self.oid = oid
        self.version = version
        self.effectiveDateTime = effectiveDateTime
        self.stepsValue = stepsValue
        
    }
    
}
