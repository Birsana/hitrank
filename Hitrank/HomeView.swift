//
//  ViewController.swift
//  Hitrank
//
//  Created by Andre Birsan on 2020-05-01.
//  Copyright © 2020 Andre Birsan. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {


    
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var menu: UIStackView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var highScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.setGradientBackground(colorOne: Colors.darkBlue, colorTwo: Colors.blue)
        
     
        
        titleText.textColor = UIColor.white
        titleText.font = UIFont(name: "Verdana-Bold", size: titleText.font.pointSize)
        
        
        playButton.layer.cornerRadius = playButton.frame.size.height/2
        playButton.layer.masksToBounds = true
        playButton.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.brightOrange)
        
        howToPlayButton.layer.cornerRadius = howToPlayButton.frame.size.height/2
        howToPlayButton.layer.masksToBounds = true
        howToPlayButton.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.brightOrange)
    }


}

