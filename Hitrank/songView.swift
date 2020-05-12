//
//  songView.swift
//  Hitrank
//
//  Created by Andre Birsan on 2020-05-11.
//  Copyright © 2020 Andre Birsan. All rights reserved.
//

import UIKit
import WebKit
import Kingfisher

class songView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var songCover: UIImageView!
    @IBOutlet weak var chartInfo: UILabel!
    @IBOutlet weak var songEmbed: WKWebView!
    
    @IBOutlet weak var higherButton: UIButton!
    
    @IBOutlet weak var lowerButton: UIButton!
    
    var score: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func populateData(song: Song) { //fills in the necessary song info
        
        contentView.backgroundColor = hexStringToUIColor(hex: song.bgColor)
        
        let playURL = song.url.dropFirst(8)
        let html = genericHTML + playURL + HTMLEnd
        songEmbed.loadHTMLString(html, baseURL: nil)
        songEmbed.scrollView.isScrollEnabled = false
        songEmbed.scrollView.bounces = false
        
        chartInfo.text = "Chart Position: ???"
        
        score = song.chartRank
        
        let artURL = song.artUrl.dropLast(14)
        let fullArtURL = artURL + "3000x3000bb.jpeg"
        songCover.kf.setImage(with: URL(string: String(fullArtURL)))
    }
    
    func formatSongCover(){ //makes the background song cover
        songCover.translatesAutoresizingMaskIntoConstraints = false
        songCover.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        songCover.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        songCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        songCover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("songView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.sendSubviewToBack(songCover)
        formatSongCover()
    }
    
    
    @IBAction func higherTapped(_ sender: Any) {
     chartInfo.text = "Chart Position: #\(String(score))"
    }
    
    @IBAction func lowerTapped(_ sender: Any) {
       chartInfo.text = "Chart Position: #\(String(score))"
    }
    
}
