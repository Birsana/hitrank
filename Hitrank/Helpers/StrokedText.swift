
//
//  StrokedTest.swift
//  Hitrank
//
//Taken from https://stackoverflow.com/questions/40575408/outline-uilabel-text-in-uilabel-subclass


import Foundation
import UIKit

import UIKit

class StrokedLabel: UILabel {
    
    var strockedText: String = "" {
        willSet(newValue) {
            let strokeTextAttributes : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.strokeColor : UIColor.systemPink,
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.strokeWidth : -4.0,
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 30)
                ] as [NSAttributedString.Key  : Any]
            
            let customizedText = NSMutableAttributedString(string: newValue,
                                                           attributes: strokeTextAttributes)
            
            
            attributedText = customizedText
        }
    }
}

