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
import EFCountingLabel

class SongView: UIView, WKNavigationDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var songCover: UIImageView!
    @IBOutlet weak var chartInfo: EFCountingLabel!
    @IBOutlet weak var songEmbed: WKWebView!
    @IBOutlet weak var higherButton: UIButton!
    @IBOutlet weak var lowerButton: UIButton!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    
    
    var score: Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func populateData(song: Song) { //fills in the necessary song info
                
        let playURL = song.url.dropFirst(8)
        let html = genericHTML + playURL + HTMLEnd
        
        songEmbed.loadHTMLString(html, baseURL: nil)
        songEmbed.scrollView.isScrollEnabled = false
        songEmbed.scrollView.bounces = false
        songEmbed.layer.cornerRadius = 10.0
        songEmbed.clipsToBounds = true

        chartInfo.text = "Chart Position: ???"
        
        score = song.chartRank
        
        let artURL = song.artUrl.dropLast(14)
        let fullArtURL = artURL + "3000x3000bb.jpeg"
        songCover.kf.setImage(with: URL(string: String(fullArtURL)))
    }
    
    func formatSongCover(){ //makes the background song cover
        songCover.contentMode = .scaleAspectFill
        songCover.translatesAutoresizingMaskIntoConstraints = false
        songCover.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        songCover.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        songCover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        songCover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    func formatButtons() { //formats buttons
        higherButton.setTitle("Higher", for: .normal)
        lowerButton.setTitle("Lower", for: .normal)
        
        higherButton.layer.cornerRadius = higherButton.frame.size.height/2
        higherButton.layer.masksToBounds = true
        
        lowerButton.layer.cornerRadius = lowerButton.frame.size.height/2
        lowerButton.layer.masksToBounds = true
        
        higherButton.backgroundColor = UIColor.systemPink
        lowerButton.backgroundColor = UIColor.systemPink
    }
    
    
    private func commonInit() {
        
        //inital setup of view
        Bundle.main.loadNibNamed("songView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.sendSubviewToBack(songCover)
        
        formatButtons() //formats buttons
        
        //set up song embed
        songEmbed.addSubview(loadIndicator)
        loadIndicator.startAnimating()
        songEmbed.navigationDelegate = self
        loadIndicator.hidesWhenStopped = true
        
        //this allows the label to animate counting to position on chart
        chartInfo.setUpdateBlock { (value, label) in
            label.text = String(format: "Chart Position: #\(Int(value))")
        }
        chartInfo.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 1)
        
        formatSongCover() //formats the song cover
        
    }
    
    
    @IBAction func higherTapped(_ sender: Any) { //animate counting to position
        chartInfo.countFrom(0, to: CGFloat(score), withDuration: 1)
    }
    
    @IBAction func lowerTapped(_ sender: Any) { //animate counting to position
        chartInfo.countFrom(1, to: CGFloat(score), withDuration: 1)
    }
    
    //these methods deal with the loading icon
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadIndicator.stopAnimating()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadIndicator.stopAnimating()
    }
}
