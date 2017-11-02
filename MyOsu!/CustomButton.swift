//
//  CustomButton.swift
//  MyOsu!
//
//  Created by Robert Wei on 11/1/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 2
        self.layer.borderColor  = UIColor(displayP3Red: 101/255, green: 255/255, blue: 250/255, alpha: 1).cgColor
        self.layer.cornerRadius = 12
        
    }
    

    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
