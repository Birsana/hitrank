//
//  howToPlay.swift
//  Hitrank
//
//  Created by Andre Birsan on 2020-05-24.
//  Copyright © 2020 Andre Birsan. All rights reserved.
//

import UIKit

class HowToPlayView: UIViewController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //dismiss the instructions on tap
    @IBAction func dismissPopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
