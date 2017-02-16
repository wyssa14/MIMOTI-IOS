//
//  SubjectiveCondition.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 03/04/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//

import Foundation

// simple model class for mapping of Midata SubjectiveCondition Records

class SubjectiveCondition {
    
    
    var oid: String = ""
    var version: String = ""
    var effectiveDateTime: String = ""
    var value: Double
    
    
    init(oid: String, version: String, effectiveDateTime: String, value: Double){
        
        
        self.oid = oid
        self.version = version
        self.effectiveDateTime = effectiveDateTime
        self.value = value
        
    }
    
}
