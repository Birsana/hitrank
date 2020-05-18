//
//  gameOver.swift
//  Hitrank
//
//  Created by Andre Birsan on 2020-05-09.
//  Copyright © 2020 Andre Birsan. All rights reserved.
//

import UIKit

class gameOver: UIViewController {

    var score: Int? = nil
    var highScore: Int? = nil
    
    
    @IBOutlet weak var playAgain: UIButton!
    @IBOutlet weak var mainMenu: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if score! > UserDefaults.standard.integer(forKey: "highScore") {
            UserDefaults.standard.set(score!, forKey: "highScore")
        }
        highScore = UserDefaults.standard.integer(forKey: "highScore")
    }
    
}
