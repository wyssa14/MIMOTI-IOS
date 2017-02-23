//
//  OfflineViewController.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 08/04/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//

import UIKit

class OfflineViewController: UIViewController {
    
    // reachability observer opens this view if connectivity is not available
    
    @IBOutlet weak var mimotiLogo: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mimotiLogo.image = UIImage(named: "logoText")
        
        
    }
    
    
    @IBAction func mailButtonTapped(_ sender: Any) {
        
        if let mailURL = URL(string: "mailto:adrianroman.wyss@bfh.ch"){
            
        UIApplication.shared.open(mailURL)
        
        }

    }
    
}
