//
//  howToPlay.swift
//  Hitrank
//
//  Created by Andre Birsan on 2020-05-24.
//  Copyright © 2020 Andre Birsan. All rights reserved.
//

import UIKit

class howToPlay: UIViewController {
    
    @IBOutlet weak var info: UIView!
    @IBOutlet weak var instructions: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        info.layer.borderWidth = 2
        info.layer.borderColor = UIColor.systemPink.cgColor
        
    }
    
    @IBAction func dismissPopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
