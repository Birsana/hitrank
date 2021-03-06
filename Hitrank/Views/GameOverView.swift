//
//  gameOver.swift
//  Hitrank
//
//  Created by Andre Birsan on 2020-05-09.
//  Copyright © 2020 Andre Birsan. All rights reserved.
//

import UIKit

class GameOverView: UIViewController {
    
    var score: Int!
    var highScore: Int!
    
    @IBOutlet weak var ring: UIImageView!
    
    @IBOutlet weak var playAgain: UIButton!
    @IBOutlet weak var mainMenu: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBOutlet weak var scoreComment: UILabel!
    
    func formatButtons() {
        playAgain.layer.cornerRadius = playAgain.frame.size.height/2
        playAgain.layer.masksToBounds = true
        
        mainMenu.layer.cornerRadius = mainMenu.frame.size.height/2
        mainMenu.layer.masksToBounds = true
        
        playAgain.backgroundColor = UIColor.systemPink
        mainMenu.backgroundColor = UIColor.systemPink
    }
    
    func formatLabels() {
        scoreLabel.text = "Score: \(score ?? 0)"
        scoreLabel.textColor = UIColor.white
        highScoreLabel.text = "Highscore: \(highScore ?? 0)"
        highScoreLabel.textColor = UIColor.white
    }
    
    func comment() { //writes a comment based on user's score
        scoreComment.textColor = UIColor.systemPink
        if score < 5{
            scoreComment.text = "Come on! You can do better than that!"
        } else if score < 10{
            scoreComment.text = "Not bad - you know your stuff!"
        } else if score < 15{
            scoreComment.text = "You should consider playing this game for a living!"
        } else {
            scoreComment.text = "You've gotta be cheating!"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set background colour and icon
        self.view.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.2156862745, blue: 0.4980392157, alpha: 1)
        ring.image = UIImage(named: "justring")
        view.sendSubviewToBack(ring)
        
        //if the user beat their old highscore, update to new highscore
        if score > UserDefaults.standard.integer(forKey: "highScore") {
            UserDefaults.standard.set(score, forKey: "highScore")
        }
        highScore = UserDefaults.standard.integer(forKey: "highScore")
        
        formatLabels()//formats labels
        formatButtons() //formats buttons
        comment() //writes a comment based on person's score
    }
    
    @IBAction func againTapped(_ sender: Any) { //need to check if internet connection is available to allow user to start game
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            print("Not connected")
            let alert = UIAlertController(title: "No Internet Connection Detected", message: "An internet connection is required to play Hitrank", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        case .online(.wwan):
            performSegue(withIdentifier: "again", sender: nil)
            
        case .online(.wiFi):
            performSegue(withIdentifier: "again", sender: nil)
        }
    }
}
