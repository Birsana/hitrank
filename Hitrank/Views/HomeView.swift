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
    
    @objc func reachabilityChanged(note: Notification) {
        
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
        isFirstLaunch()
        //view.backgroundColor = UIColor(red: 37, green: 38, blue: 108, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.2156862745, blue: 0.4980392157, alpha: 1)
        icon.image = UIImage(named: "icon2")
        
        createOuterBorder()
        
        titleText.font = UIFont(name: "Verdana-Bold", size: titleText.font.pointSize)
        titleText.textColor = UIColor.white
        
        playButton.layer.cornerRadius = playButton.frame.size.height/2
        playButton.layer.masksToBounds = true
        playButton.backgroundColor = UIColor.systemPink
        
        howToPlayButton.layer.cornerRadius = howToPlayButton.frame.size.height/2
        howToPlayButton.layer.masksToBounds = true
        howToPlayButton.backgroundColor = UIColor.systemPink
        
        highScore.text = "Highscore: \(String(UserDefaults.standard.integer(forKey: "highScore")))"
        highScore.textColor = UIColor.white
    }
    
    
    @IBAction func instructionsTapped(_ sender: Any) {
        
    }
    
    @IBAction func playTapped(_ sender: Any) { //need to check if internet connection is available
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

