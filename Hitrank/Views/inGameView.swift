
//
//  ViewController.swift
//  Hitrank
//
//  Created by Andre Birsan on 2020-05-01.
//  Copyright © 2020 Andre Birsan. All rights reserved.
//

import UIKit
import Alamofire

class inGameView: UIViewController, ContainerToMaster {
    
    @IBOutlet weak var topSong: UIView!    
    @IBOutlet weak var bottomSong: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var topView: gameTopView?
    var bottomView: gameBottomView?
    
    
    var topTest: songView?
    var bottomTest: songView?
    
    var songList = [Song]()
    var availableSongs = [Song]()
    
    var score = 0
    var safeHeightGlobal: CGFloat?
    
    var upperSong: Song?
    var lowerSong: Song?
    
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
        
        //        topSong.translatesAutoresizingMaskIntoConstraints = false
        //        topSong.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        //        topSong.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //        topSong.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //        topSong.heightAnchor.constraint(equalToConstant: safeHeight/2).isActive = true
        //
        //        bottomSong.translatesAutoresizingMaskIntoConstraints = false
        //        bottomSong.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        //        bottomSong.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //        bottomSong.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //        bottomSong.heightAnchor.constraint(equalToConstant: safeHeight/2).isActive = true
        
        
        topTest?.translatesAutoresizingMaskIntoConstraints = false
        topTest?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topTest?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topTest?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topTest?.heightAnchor.constraint(equalToConstant: safeHeight/2).isActive = true
        
        bottomTest?.translatesAutoresizingMaskIntoConstraints = false
        bottomTest?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomTest?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomTest?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomTest?.heightAnchor.constraint(equalToConstant: safeHeight/2).isActive = true
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
            //MAKE NEXT FUNCTION CALL HERE
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
        
        //topView?.populateData(song: topTrack) //updates the top view with song data
        //bottomView?.populateData(song: bottomTrack) //updates the bottom view with song data
        
        topTest?.populateData(song: topTrack)
        let upperRank = upperSong!.chartRank
        topTest?.chartInfo.text = "Chart Position: #\(upperRank)"
        
        bottomTest?.populateData(song: bottomTrack)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "topSong" {
            topView = segue.destination as? gameTopView
        } else if segue.identifier == "bottomSong" {
            bottomView = segue.destination as? gameBottomView
            bottomView!.gameView = self
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradientBackground(colorOne: Colors.darkBlue, colorTwo: Colors.blue)
        
        topView?.view.isHidden = true
        bottomView?.view.isHidden = true
        
        // topTest = (self.storyboard!.instantiateViewController(withIdentifier: "bottom") as! gameBottomView)
        //  bottomTest = (self.storyboard!.instantiateViewController(withIdentifier: "bottom") as! gameBottomView)
        
        topTest = songView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        bottomTest = songView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
        view.addSubview(topTest!)
        view.addSubview(bottomTest!)
        
        
        topTest?.higherButton.isHidden = true
        topTest?.lowerButton.isHidden = true
        
        view.bringSubviewToFront(scoreLabel)
        
        labelLayout() //format label in center as a circle
        songLayout() //sets layout of container view controllers
        getSongs() //gets the songs
        
    }
    
    func selectionMade(choseHigher: Bool){
        print("IM HERE")
        
        if choseHigher {
            if upperSong!.chartRank < lowerSong!.chartRank { //incorrect choice
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
    
    func nextRound() {
        score += 1
        scoreLabel.text = "\(score)"
        upperSong = lowerSong
        UIView.animate(withDuration: 2.0, animations: {
            UIView.animate(withDuration: 2.0) { //REMOVE TOP VIEW COMPLETION HANDLER
                //                self.topSong.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/2 * -1)
                //                self.topView?.songEmbed.removeFromSuperview()
                //                self.bottomView?.higherButton.removeFromSuperview()
                //                self.bottomView?.lowerButton.removeFromSuperview()
                //                self.bottomSong.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/2 * -1)
                //                let newSong = self.newBottomView()
                //                newSong.view.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/2 * -1)
                self.topTest?.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/2 * -1)
                self.topTest?.songEmbed.removeFromSuperview()
                self.bottomTest?.higherButton.removeFromSuperview()
                self.bottomTest?.lowerButton.removeFromSuperview()
                self.bottomTest?.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/2 * -1)
                let newSong = self.newBottomView()
                newSong.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/2 * -1)
                self.topTest = self.bottomTest
                self.bottomTest = newSong
            }
        })
        
    }
    
    func nextRoundGeneric() {
        
    }
    
    func gameOver() {
        bottomView?.songEmbed.removeFromSuperview()
        topView?.songEmbed.removeFromSuperview()
        performSegue(withIdentifier: "gameOver", sender: nil)
    }
    
    func newBottomView() -> songView { //creates the new bottom view
        let newBottom = songView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        
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
