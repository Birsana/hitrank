//
//  gradientstuff.swift
//  Hitrank
//
//  Created by Andre Birsan on 2020-05-01.
//  Copyright © 2020 Andre Birsan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor){
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
}

struct Colors {
    static let brightOrange = UIColor(red: 255.0/255.0, green: 69.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    static let orange = UIColor(red: 255.0/255.0, green: 175.0/255.0, blue: 72.0/255.0, alpha: 1.0)
    
    static let darkBlue = UIColor(red: 0.0/255.0, green: 23.0/255.0, blue: 45.0/255.0, alpha: 1.0)
    static let blue = UIColor(red: 2.0/255.0, green: 56.0/255.0, blue: 110.0/225.0, alpha: 1.0)
    
    static let lightPink = UIColor(red: 147.0/255.0, green: 116.0/255.0, blue: 229.0/225.0, alpha: 1.0)
    static let otherPink = UIColor(red: 125.0/255, green: 150.0/255, blue: 228.0/255, alpha: 1.0)
    
}
