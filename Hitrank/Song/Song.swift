//
//  songEntry.swift
//  Hitrank
//
//  Created by Andre Birsan on 2020-05-01.
//  Copyright © 2020 Andre Birsan. All rights reserved.
//

import Foundation

struct Song: Equatable {
    var chartRank: Int
    let url: String
    let artUrl: String
    let name: String
    let bgColor: String
    let textColor: String
}

//the html needed to embed the song player

let genericHTML = """
<meta content="width=device-width; initial-scale=1.0; maximum-scale=1.0;"; user-scalable=YES; name="viewport" />
<iframe allow="autoplay *; encrypted-media *;" frameborder="0" height="150";  style="width:100%;max-width:660px;overflow:hidden;background: transparent;" sandbox="allow-forms allow-popups allow-same-origin allow-scripts allow-storage-access-by-user-activation allow-top-navigation-by-user-activation" src="https://embed.
"""

let HTMLEnd = """
&app=music"></iframe>
"""
