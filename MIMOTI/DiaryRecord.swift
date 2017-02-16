//
//  DiaryRecord.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 03/04/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//


import Foundation

// simple model class for mapping of Midata DiaryRecords

class DiaryRecord {
    
    
    var oid: String = ""
    var version: String = ""
    var effectiveDateTime: String = ""
    var comment: String = ""
    
    
    init(oid: String, version: String, effectiveDateTime: String, comment: String){
        
        
        self.oid = oid
        self.version = version
        self.effectiveDateTime = effectiveDateTime
        self.comment = comment
        
    }
    
}
