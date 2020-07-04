//
//  ViewController.swift
//  Hitrank
//
//  Created by Andre Birsan on 2020-05-01.
//  Copyright © 2020 Andre Birsan. All rights reserved.
//

import Foundation
import UIKit
import Reachability


class HomeView: UIViewController{
    
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var menu: UIStackView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var highScore: UILabel!
    
    let reachability = try! Reachability()
    
    
    func isFirstLaunch(){ //when the user first launches the app, set the high score to 0
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            return
        } else {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set(0, forKey: "highscore")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) { //used to check if user is connected to internet
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .unavailable:
            print("Network not reachable")
        case .none:
            print("None")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isFirstLaunch() //check if first launch of app, to set highscore to 0
        titleText.backgroundColor = UIColor.clear
        self.view.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.2156862745, blue: 0.4980392157, alpha: 1) //set app background colour and title image
        icon.image = UIImage(named: "icon2")
        
        //edit title
        titleText.font = UIFont(name: "Verdana-Bold", size: titleText.font.pointSize)
        titleText.textColor = UIColor.white
        
        //format buttons
        playButton.layer.cornerRadius = playButton.frame.size.height/2
        playButton.layer.masksToBounds = true
        playButton.backgroundColor = UIColor.systemPink
        
        howToPlayButton.layer.cornerRadius = howToPlayButton.frame.size.height/2
        howToPlayButton.layer.masksToBounds = true
        howToPlayButton.backgroundColor = UIColor.systemPink
        
        //format highscore label
        highScore.text = "Highscore: \(String(UserDefaults.standard.integer(forKey: "highScore")))"
        highScore.textColor = UIColor.white
    }
    
    
    @IBAction func playTapped(_ sender: Any) { //need to check if internet connection is available to allow user to start game
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            print("Not connected")
            let alert = UIAlertController(title: "No Internet Connection Detected", message: "An internet connection is required to play Hitrank", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        case .online(.wwan):
            performSegue(withIdentifier: "start", sender: nil)
            
        case .online(.wiFi):
            performSegue(withIdentifier: "start", sender: nil)
        }
    }
}

