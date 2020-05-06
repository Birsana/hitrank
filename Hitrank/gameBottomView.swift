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
    
    
    @IBOutlet weak var songCover: UIImageView!
    @IBOutlet weak var songEmbed: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let html = """
        <meta content="width=device-width; initial-scale=1.0; maximum-scale=1.0;"; user-scalable=YES; name="viewport" />
        <iframe allow="autoplay *; encrypted-media *;" frameborder="0" height="150" style="width:100%;max-width:660px;overflow:hidden;background:transparent;" sandbox="allow-forms allow-popups allow-same-origin allow-scripts allow-storage-access-by-user-activation allow-top-navigation-by-user-activation" src="https://embed.music.apple.com/us/album/pain-1993-feat-playboi-carti/1511037323?i=1511037736&app=music"></iframe>

        """
        songEmbed.loadHTMLString(html, baseURL: nil)
        songEmbed.scrollView.isScrollEnabled = false
        songEmbed.scrollView.bounces = false
        
        songCover.kf.setImage(with: URL(string: "https://is4-ssl.mzstatic.com/image/thumb/Music123/v4/02/32/85/02328553-ae05-1801-47bf-8f1e29871db1/20UMGIM34466.rgb.jpg/175x175bb.jpeg"))
    }
    
    
}
