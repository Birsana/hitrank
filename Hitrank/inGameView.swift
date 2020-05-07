
//
//  ViewController.swift
//  Hitrank
//
//  Created by Andre Birsan on 2020-05-01.
//  Copyright © 2020 Andre Birsan. All rights reserved.
//

import UIKit
import Alamofire

class inGameView: UIViewController {
    
    @IBOutlet weak var topSong: UIView!    
    @IBOutlet weak var bottomSong: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var topView: gameTopView?
    var bottomView: gameBottomView?

    
    var songList = [Song]()
    var availableSongs = [Song]()
    
    var isFirstRound = true
    var score = 0
    
    func songLayout(){
        let safeHeight = view.safeAreaLayoutGuide.layoutFrame.size.height
        topSong.translatesAutoresizingMaskIntoConstraints = false
        topSong.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topSong.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topSong.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topSong.heightAnchor.constraint(equalToConstant: safeHeight/2).isActive = true
        
        bottomSong.translatesAutoresizingMaskIntoConstraints = false
        bottomSong.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomSong.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomSong.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomSong.heightAnchor.constraint(equalToConstant: safeHeight/2).isActive = true
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
                                        let url = songAttributes["url"] as! String
                                        if let artwork = songAttributes["artwork"] as? [String: Any] {
                                            let artUrl = artwork["url"] as! String
                                            let track = Song(chartRank: counter, url: url, artUrl: artUrl, name: name)
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
            //MAKE NEXT FUNCTION CALL HERE
            self.startGame()
            print(self.songList[17])
        }
    }
    
    func startGame(){ //gets the initial two songs and populates the views with their information
        
        scoreLabel.text = "0"
        scoreLabel.textAlignment = .center
        
        availableSongs = songList
        let topTrack = availableSongs.remove(at: Int.random(in: 0..<availableSongs.count))
        let bottomTrack = availableSongs.remove(at: Int.random(in: 0..<availableSongs.count))
        topView?.populateData(song: topTrack) //updates the top view with song data
        bottomView?.populateData(song: bottomTrack) //updates the bottom view with song data
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "topSong" {
            topView = segue.destination as? gameTopView
        } else if segue.identifier == "bottomSong" {
            bottomView = segue.destination as? gameBottomView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradientBackground(colorOne: Colors.darkBlue, colorTwo: Colors.blue)
        
        //format label in center as a circle
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scoreLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scoreLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        scoreLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        scoreLabel.layer.cornerRadius = 30
        scoreLabel.layer.masksToBounds = true
        
        
        songLayout() //sets layout of container view controllers
        getSongs() //gets the songs
        
    }
    
    func selectionMade(){
        
    }
    
    func nextRound(){
        
    }
    
    
}
