//
//  ViewController.swift
//  Hitrank
//
//  Created by Andre Birsan on 2020-05-01.
//  Copyright © 2020 Andre Birsan. All rights reserved.
//

import Foundation
import UIKit

class HomeView: UIViewController {
    
    
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var menu: UIStackView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var highScore: UILabel!
    
    
    func isFirstLaunch(){ //when the user first launches the app, set the high score to 0
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            return
        } else {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set(0, forKey: "highscore")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isFirstLaunch()
        
        view.setGradientBackground(colorOne: Colors.darkBlue, colorTwo: Colors.blue)
        
        
        
        titleText.textColor = UIColor.white
        titleText.font = UIFont(name: "Verdana-Bold", size: titleText.font.pointSize)
        
        
        playButton.layer.cornerRadius = playButton.frame.size.height/2
        playButton.layer.masksToBounds = true
        playButton.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.brightOrange)
        
        howToPlayButton.layer.cornerRadius = howToPlayButton.frame.size.height/2
        howToPlayButton.layer.masksToBounds = true
        howToPlayButton.setGradientBackground(colorOne: Colors.orange, colorTwo: Colors.brightOrange)
        
        highScore.text = "Highscore: \(String(UserDefaults.standard.integer(forKey: "highScore")))"
    }
    
    
}

