
//
//  ViewController.swift
//  Hitrank
//
//  Created by Andre Birsan on 2020-05-01.
//  Copyright © 2020 Andre Birsan. All rights reserved.
//

import UIKit
import Alamofire

class inGameView: UIViewController{
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    var upperView: songView?
    var lowerView: songView?
    var newSongView: songView?
    
    var upperSong: Song?
    var lowerSong: Song?
    
    var songList = [Song]()
    var availableSongs = [Song]()
    
    var score = 0
    var safeHeightGlobal: CGFloat?
    
    
    
    func labelLayout() {
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scoreLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scoreLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        scoreLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        scoreLabel.layer.cornerRadius = 30
        scoreLabel.layer.masksToBounds = true
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
    
    func constrainToTop(songView: songView) {
        //songView.translatesAutoresizingMaskIntoConstraints = false
        songView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        songView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        songView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        songView.heightAnchor.constraint(equalToConstant: safeHeightGlobal!/2).isActive = true
    }
    
    func constrainToBottom(songView: songView) {
        // songView.translatesAutoresizingMaskIntoConstraints = false
        songView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        songView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        songView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        songView.heightAnchor.constraint(equalToConstant: safeHeightGlobal!/2).isActive = true
    }
    
    func constrainToAboveScreen(songView: songView) {
        //    songView.translatesAutoresizingMaskIntoConstraints = false
        songView.bottomAnchor.constraint(equalTo: view.topAnchor).isActive = true
        songView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        songView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        songView.heightAnchor.constraint(equalToConstant: safeHeightGlobal!/2).isActive = true
    }
    
    
    func getSongs(){ //very messy due to complex JSON structure, am essentially creating all the Song instances from the JSON data
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
        
        view.setGradientBackground(colorOne: Colors.darkBlue, colorTwo: Colors.blue)
        
        upperView = songView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        lowerView = songView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        view.addSubview(upperView!)
        view.addSubview(lowerView!)
        
        //top song shouldn't have buttons, so remove them
        upperView?.higherButton.removeFromSuperview()
        upperView?.lowerButton.removeFromSuperview()
        
        view.bringSubviewToFront(scoreLabel)
        
        labelLayout() //format label in center as a circle
        songLayout() //sets layout of container view controllers
        getSongs() //gets the songs
        
        lowerView?.higherButton.addTarget(self, action: #selector(higherSelect), for: .touchUpInside)
        lowerView?.lowerButton.addTarget(self, action: #selector(lowerSelect), for: .touchUpInside)
    }
    
    @objc func higherSelect() {
        if upperSong!.chartRank < lowerSong!.chartRank { //incorrect choice
            gameOver()
        } else { //correct choice
            nextRound()
        }
    }
    
    @objc func lowerSelect() {
        if upperSong!.chartRank > lowerSong!.chartRank { //incorrect choice
            gameOver()
        } else { //correct choice
            nextRound()
        }
    }
    
    
    func selectionMade(choseHigher: Bool){
        if choseHigher {
            if upperSong!.chartRank < lowerSong!.chartRank { //incorrect choice
                //REMEMBER TO ADD SCORE LABEL ANIMATION
                gameOver()
            } else { //correct choice
                nextRound()
            }
        }
        else {
            if upperSong!.chartRank > lowerSong!.chartRank { //incorrect choice
                gameOver()
            } else { //correct choice
                nextRound()
            }
        }
    }
    
    var count = 0
    
    func nextRound() { //preparing the next round
        count = count+1
        score += 1
        scoreLabel.text = "\(score)"
        upperSong = lowerSong
        UIView.animate(withDuration: 2.0, animations: { //animating away old song, and animating in new song
            
            //          self.upperView?.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/2 * -1)
            let prevTransform = self.upperView?.transform
            self.upperView?.transform = CGAffineTransform(translationX: prevTransform!.tx, y: prevTransform!.ty - UIScreen.main.bounds.height/2)
            
            
            self.lowerView?.higherButton.removeFromSuperview()
            self.lowerView?.lowerButton.removeFromSuperview()
            
            let prevTransformBottom = self.lowerView?.transform
            self.lowerView?.transform = CGAffineTransform(translationX: prevTransformBottom!.tx, y: prevTransformBottom!.ty - UIScreen.main.bounds.height/2)
            
            self.newSongView = self.newBottomView()
            self.newSongView!.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/2 * -1)
            
            //self.constrainToAboveScreen(songView: self.upperView!)
            //  self.constrainToTop(songView: self.lowerView!)
            //  self.constrainToBottom(songView: self.newSongView!)
        }) { finished in
            self.upperView?.songEmbed.removeFromSuperview()
            self.upperView?.removeFromSuperview()
            self.upperView = self.lowerView
            self.lowerView = self.newSongView
            self.lowerView?.higherButton.addTarget(self, action: #selector(self.higherSelect), for: .touchUpInside)
            self.lowerView?.lowerButton.addTarget(self, action: #selector(self.lowerSelect), for: .touchUpInside)
            self.view.bringSubviewToFront(self.scoreLabel)
        }
        
        
    }
    
    
    func gameOver() {
        lowerView?.songEmbed.removeFromSuperview()
        upperView?.songEmbed.removeFromSuperview()
        performSegue(withIdentifier: "gameOver", sender: nil)
    }
    
    func newBottomView() -> songView { //creates the new bottom view
        let newBottom = songView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
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
        view.bringSubviewToFront(scoreLabel)
        
        return newBottom
    }
    
}
