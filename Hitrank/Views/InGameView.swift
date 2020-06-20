
//
//  ViewController.swift
//  Hitrank
//
//  Created by Andre Birsan on 2020-05-01.
//  Copyright © 2020 Andre Birsan. All rights reserved.
//

import UIKit
import Alamofire
import QuartzCore
import EFCountingLabel

class InGameView: UIViewController{
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var upperView: SongView?
    var lowerView: SongView?
    var newSongView: SongView?
    let lineView = UIView()
    
    var upperSong: Song?
    var lowerSong: Song?
    
    var songList = [Song]()
    var availableSongs = [Song]()
    
    var score = 0
    var safeHeightGlobal: CGFloat?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameOver" {
            let destVC = segue.destination as! GameOverView
            destVC.score = score
        }
    }
    
    func lineLayout() { //adds a line to split top and bottom halves
        view.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        lineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lineView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        lineView.backgroundColor = UIColor.systemPink

    }
    
    func labelLayout() { //formats the center score label
        scoreLabel.backgroundColor = UIColor.clear
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scoreLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scoreLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        scoreLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        scoreLabel.layer.cornerRadius = 30
        scoreLabel.layer.masksToBounds = true
        
        //a backgroundView is used for colour animations, since UILabels can't be animated
        
        backgroundView.backgroundColor = UIColor.systemPink
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        backgroundView.layer.cornerRadius = 30
        backgroundView.layer.masksToBounds = true
        view.bringSubviewToFront(backgroundView)
        view.bringSubviewToFront(scoreLabel)
    }
    
    func songLayout(){ //layout the top and bottoms songs on the screen halves
        let safeHeight = view.safeAreaLayoutGuide.layoutFrame.size.height
        safeHeightGlobal = safeHeight
        
        
        upperView?.translatesAutoresizingMaskIntoConstraints = false
        upperView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        upperView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        upperView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        upperView?.heightAnchor.constraint(equalToConstant: safeHeight/2).isActive = true
        
        lowerView?.translatesAutoresizingMaskIntoConstraints = false
        lowerView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        lowerView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lowerView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lowerView?.heightAnchor.constraint(equalToConstant: safeHeight/2).isActive = true
        
        
    }
    
    
    func getSongs(){ //very messy due to complex JSON structure, am essentially creating all the Song instances from the JSON data
        
        URLCache.shared.removeAllCachedResponses() //remove existing cache so song data can update
        
        let dataURL = "https://hitrankchartdata.s3.us-east-2.amazonaws.com/data.json"
        AF.request(dataURL).responseJSON { (response) in
            guard let data = response.data else { return }
            let songJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let songs = songJSON as? [Any] {
                if let firstObject = songs.first {
                    if let dict = firstObject as? [String: Any] {
                        if let songsArray = dict["data"] as? [Any] {
                            var counter = 1
                            for object in songsArray{
                                if let songObject = object as? [String: Any] {
                                    if let songAttributes = songObject["attributes"] as? [String: Any] {
                                        let name = songAttributes["name"] as! String
                                        print(name)
                                        let url = songAttributes["url"] as! String
                                        if let artwork = songAttributes["artwork"] as? [String: Any] {
                                            let artUrl = artwork["url"] as! String
                                            let color = artwork["bgColor"] as! String
                                            let textColor = artwork["textColor1"] as! String
                                            let track = Song(chartRank: counter, url: url, artUrl: artUrl, name: name, bgColor: color, textColor: textColor)
                                            self.songList.append(track)
                                        }
                                    }
                                }
                                counter += 1
                            }
                        }
                    }
                }
            }
            self.startGame()
        }
    }
    
    func startGame(){ //gets the initial two songs and populates the views with their information
        
        scoreLabel.text = "0"
        scoreLabel.textAlignment = .center
        
        //get random song and remove it from list of available songs
        availableSongs = songList
        let topTrack = availableSongs.remove(at: Int.random(in: 0..<availableSongs.count))
        upperSong = topTrack
        
        let bottomTrack = availableSongs.remove(at: Int.random(in: 0..<availableSongs.count))
        lowerSong = bottomTrack
        
        upperView?.populateData(song: topTrack) //updates the top view with song data
        let upperRank = upperSong!.chartRank
        upperView?.chartInfo.text = "Chart Position: #\(upperRank)"
        
        lowerView?.populateData(song: bottomTrack) //updates the bottom view with song data
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
         
        //create upper and lower views
        upperView = SongView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        lowerView = SongView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        view.addSubview(upperView!)
        view.addSubview(lowerView!)
        
        //top song shouldn't have buttons, so remove them
        upperView?.higherButton.removeFromSuperview()
        upperView?.lowerButton.removeFromSuperview()
        
        self.view.bringSubviewToFront(self.backgroundView)
        view.bringSubviewToFront(scoreLabel)
        
        songLayout() //sets layout of container view controllers
        getSongs() //gets the songs
        lineLayout() //draws line across middle of songs
        labelLayout() //format label in center as a circle
        
        lowerView?.higherButton.addTarget(self, action: #selector(higherSelect), for: .touchUpInside)
        lowerView?.lowerButton.addTarget(self, action: #selector(lowerSelect), for: .touchUpInside)
    }
    
    @objc func higherSelect() { //user chooses higher
        //disable buttons for animation
        lowerView?.higherButton.isEnabled = false
        lowerView?.lowerButton.isEnabled = false

        if upperSong!.chartRank < lowerSong!.chartRank { //incorrect choice
            UIView.animate(withDuration: 2, delay: 0, animations: {
                //show an 'X' animate label red, and transition to game over screen
                self.scoreLabel.text = "X"
                self.backgroundView.backgroundColor = UIColor.systemRed
            }) { (finished) in
                self.backgroundView.backgroundColor = UIColor.systemPink
                self.gameOver()
            }
        } else { //correct choice
            UIView.animate(withDuration: 2, delay: 0, animations: {
                //show a check mark, animate label green, call next round method
                self.scoreLabel.text = "✔"
                self.backgroundView.backgroundColor = UIColor.systemGreen
            }) { (finished) in
                self.backgroundView.backgroundColor = UIColor.systemPink
                self.scoreLabel.text = "\(self.score)"
                self.nextRound()
            }
        }
    }
    
    @objc func lowerSelect() {
        //disable buttons for animation
        lowerView?.higherButton.isEnabled = false
        lowerView?.lowerButton.isEnabled = false
        if upperSong!.chartRank > lowerSong!.chartRank { //incorrect choice
            UIView.animate(withDuration: 2, delay: 0, animations: {
                //show an 'X' animate label red, and transition to game over screen
                self.scoreLabel.text = "X"
                self.backgroundView.backgroundColor = UIColor.systemRed
            }) { (finished) in
                self.backgroundView.backgroundColor = UIColor.systemPink
                self.gameOver()
            }
        } else { //correct choice
            UIView.animate(withDuration: 2, delay: 0, animations: {
                //show a check mark, animate label green, call next round method
                self.scoreLabel.text = "✔"
                self.backgroundView.backgroundColor = UIColor.systemGreen
            }) { (finished) in
                self.backgroundView.backgroundColor = UIColor.systemPink
                self.nextRound()
            }
        }
    }
    
    
    func nextRound() { //preparing the next round
        score += 1
        scoreLabel.text = "\(score)"
        upperSong = lowerSong
        lineView.isHidden = true
        UIView.animate(withDuration: 1.0, animations: { //animating away old song, and animating in new song
            
            //animate top outside screen
            let prevTransform = self.upperView?.transform
            self.upperView?.transform = CGAffineTransform(translationX: prevTransform!.tx, y: prevTransform!.ty - UIScreen.main.bounds.height/2)
            
            //animate bottom to top
            self.lowerView?.higherButton.removeFromSuperview()
            self.lowerView?.lowerButton.removeFromSuperview()
            
            //animate new song to bottom
            let prevTransformBottom = self.lowerView?.transform
            self.lowerView?.transform = CGAffineTransform(translationX: prevTransformBottom!.tx, y: prevTransformBottom!.ty - UIScreen.main.bounds.height/2)
            
            self.newSongView = self.newBottomView()
            self.newSongView!.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/2 * -1)
        }) { finished in
            self.upperView?.songEmbed.removeFromSuperview()
            self.upperView?.removeFromSuperview()
            
            //reassign views as needed
            self.upperView = self.lowerView
            self.lowerView = self.newSongView
            
            self.lowerView?.higherButton.addTarget(self, action: #selector(self.higherSelect), for: .touchUpInside)
            self.lowerView?.lowerButton.addTarget(self, action: #selector(self.lowerSelect), for: .touchUpInside)
            self.lineView.isHidden = false
            self.view.bringSubviewToFront(self.lineView)
            self.view.bringSubviewToFront(self.backgroundView)
            self.view.bringSubviewToFront(self.scoreLabel)
            
        }
        
        
    }
    
    
    func gameOver() { //bug here when press button twice
        lowerView?.songEmbed.removeFromSuperview()
        upperView?.songEmbed.removeFromSuperview()
        performSegue(withIdentifier: "gameOver", sender: nil)
    }
    
    func newBottomView() -> SongView { //creates the new bottom view
        let newBottom = SongView()
        view.addSubview(newBottom)
        
        //now we populate the new view with the necessary data
        if availableSongs.count == 0 { //if all the available songs have been used, reset it to songList minus the top song
            availableSongs = songList
            availableSongs = availableSongs.filter {$0 != upperSong}
        }
        
        let bottomTrack = availableSongs.remove(at: Int.random(in: 0..<availableSongs.count))
        lowerSong = bottomTrack
        
        newBottom.populateData(song: bottomTrack)
        
        //formatting for the new view
        newBottom.translatesAutoresizingMaskIntoConstraints = false
        newBottom.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        newBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        newBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        newBottom.heightAnchor.constraint(equalToConstant: safeHeightGlobal!/2).isActive = true
        self.view.bringSubviewToFront(self.backgroundView)
        view.bringSubviewToFront(scoreLabel)
        
        return newBottom
    }
    
}
