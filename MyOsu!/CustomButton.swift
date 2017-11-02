//
//  CustomButton.swift
//  MyOsu!
//
//  Created by Robert Wei on 11/1/17.
//  Copyright © 2017 Nathan Rizik. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    var select = false
    var SelectionColor = [(UIColor.white).cgColor]

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 2
        self.layer.borderColor  = self.SelectionColor[0]
        self.MakeBorderColor()
        self.layer.cornerRadius = 12
        self.addTarget(self, action: #selector(self.OnPress), for: .touchUpInside)
        
    }
    
    @objc func OnPress()
    {
        self.select = !self.select
        self.layer.borderColor = self.SelectionColor[self.select==true ? 1 : 0]
    }
    
    func MakeBorderColor()
    {
        var rgb : [Float] = [Float(arc4random_uniform(176)+80)/255, Float(arc4random_uniform(176)+80)/255, 255/255]
        rgb.shuffle()
        self.SelectionColor.append(UIColor(displayP3Red: CGFloat(rgb[0]), green: CGFloat(rgb[1]), blue: CGFloat(rgb[2]), alpha: 1).cgColor)
    }
    

    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
