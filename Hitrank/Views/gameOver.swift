//
//  gameOver.swift
//  Hitrank
//
//  Created by Andre Birsan on 2020-05-09.
//  Copyright © 2020 Andre Birsan. All rights reserved.
//

import UIKit

class gameOver: UIViewController {

    var score: Int!
    var highScore: Int!
    
    @IBOutlet weak var ring: UIImageView!
    
    @IBOutlet weak var playAgain: UIButton!
    @IBOutlet weak var mainMenu: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    
    func formatButtons() {
        playAgain.layer.cornerRadius = playAgain.frame.size.height/2
        playAgain.layer.masksToBounds = true
        
        mainMenu.layer.cornerRadius = mainMenu.frame.size.height/2
        mainMenu.layer.masksToBounds = true
        
        playAgain.backgroundColor = UIColor.systemPink
        mainMenu.backgroundColor = UIColor.systemPink
    }
    
    func createOuterBorder() {
        let border = UIView()
        view.addSubview(border)
        view.sendSubviewToBack(border)
        border.translatesAutoresizingMaskIntoConstraints = false
        border.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        border.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        border.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        border.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        border.layer.borderWidth = 2
        border.layer.borderColor = UIColor.systemPink.cgColor
        border.layer.cornerRadius = 10
        border.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ring.image = UIImage(named: "justring")
        view.sendSubviewToBack(ring)
        if score > UserDefaults.standard.integer(forKey: "highScore") {
            UserDefaults.standard.set(score, forKey: "highScore")
        }
        highScore = UserDefaults.standard.integer(forKey: "highScore")
        
        scoreLabel.text = "Score: \(score ?? 0)"
        highScoreLabel.text = "Highscore: \(highScore ?? 0)"
        
        formatButtons()
        createOuterBorder()
    }
    
}
