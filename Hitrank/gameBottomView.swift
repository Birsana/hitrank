//
//  gameBottomView.swift
//  Hitrank
//
//  Created by Andre Birsan on 2020-05-02.
//  Copyright © 2020 Andre Birsan. All rights reserved.
//

import UIKit
import WebKit
import Kingfisher

class gameBottomView: UIViewController {
    
    var gameView: inGameView?
    
    @IBOutlet weak var songCover: UIImageView!
    @IBOutlet weak var songEmbed: WKWebView!
    @IBOutlet weak var chartInfo: UILabel!
    
    func formatSongCover(){
        songCover.translatesAutoresizingMaskIntoConstraints = false
        songCover.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        songCover.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        songCover.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        songCover.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    }
    
    
    func populateData(song: Song) {
        
        view.backgroundColor = hexStringToUIColor(hex: song.bgColor)
        
        let playURL = song.url.dropFirst(8)
        let html = genericHTML + playURL + HTMLEnd
        songEmbed.loadHTMLString(html, baseURL: nil)
        songEmbed.scrollView.isScrollEnabled = false
        songEmbed.scrollView.bounces = false
        
        chartInfo.text = "Chart Position: ???"
        chartInfo.textColor = hexStringToUIColor(hex: song.textColor)
        
        let artURL = song.artUrl.dropLast(14)
        let fullArtURL = artURL + "3000x3000bb.jpeg"
        songCover.kf.setImage(with: URL(string: String(fullArtURL)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.sendSubviewToBack(songCover)
        formatSongCover()
    }
    
    
}
