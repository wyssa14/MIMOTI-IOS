//
//  ReselectableSegmentedControl.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 06/04/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//

import UIKit

class ReselectableSegmentedControl: UISegmentedControl {
    
    @IBInspectable var allowReselection: Bool = true
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let previousSelectedSegmentIndex = self.selectedSegmentIndex
        super.touchesEnded(touches, with: event)
        if allowReselection && previousSelectedSegmentIndex == self.selectedSegmentIndex || self.selectedSegmentIndex != -1 {
            
            self.selectedSegmentIndex = -1
            
            if let touch = touches.first  {
                let touchLocation = touch.location(in: self)
                if bounds.contains(touchLocation) {
                    self.sendActions(for: .valueChanged)
                }
            }
        }
    }
        
}
