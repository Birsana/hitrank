//
//  howToPlay.swift
//  Hitrank
//
//  Created by Andre Birsan on 2020-05-24.
//  Copyright © 2020 Andre Birsan. All rights reserved.
//

import UIKit

class HowToPlayView: UIViewController {
    
    @IBOutlet weak var info: UIView!
    @IBOutlet weak var instructions: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //format background, border, and text
        info.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.2156862745, blue: 0.4980392157, alpha: 1)
        info.layer.borderWidth = 2
        info.layer.borderColor = UIColor.systemPink.cgColor
        instructions.textColor = UIColor.white
        
    }
    
    //dismiss the instructions on tap
    @IBAction func dismissPopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
