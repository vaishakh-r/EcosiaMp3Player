//
//  ViewController.swift
//  EcosiaMp3Player
//
//  Created by Vaishakh on 3/29/17.
//  Copyright © 2017 Vaishakh. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var player:MusicPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player = MusicPlayer.init()
        player?.musicPlayerDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

