//
//  WeightRecord.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 03/04/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//

import Foundation


// simple model class for mapping of Midata WeightRecords

class WeightRecord {
    
    
    var oid: String = ""
    var version: String = ""
    var effectiveDateTime: String = ""
    var weightValue: Double
    
    
    init(oid: String, version: String, effectiveDateTime: String, weightValue: Double){
        
        self.oid = oid
        self.version = version
        self.effectiveDateTime = effectiveDateTime
        self.weightValue = weightValue
        
    }
    
}
