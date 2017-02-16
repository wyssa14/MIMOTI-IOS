//
//  RecordCell.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 28/03/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//

import UIKit

// simple custom class for UITableViewCell displaying the values from Midata

class RecordCell: UITableViewCell {
    
    
    var effectiveDate : String = ""
    
    @IBOutlet weak var noWeightIcon: UIImageView!
    
    @IBOutlet weak var conditionIcon: UIImageView!
    
    @IBOutlet weak var weightValue: UILabel!
    
    @IBOutlet weak var dateValue: UILabel!
    
    @IBOutlet weak var commentValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
}
