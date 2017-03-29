//
//  ViewController.swift
//  EcosiaMp3Player
//
//  Created by Vaishakh on 3/29/17.
//  Copyright © 2017 Vaishakh. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var musicPlayer:MusicPlayer?
    
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    var timer: Timer?
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationTimeLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicPlayer = MusicPlayer.init()
        musicPlayer?.musicPlayerDelegate = self
        setDisplayInfo()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func startButtonClicked(_ sender: Any) {
        if (musicPlayer?.player?.isPlaying)! {
            musicPlayer?.pauseMusicPlayer()
            playButton.setBackgroundImage(UIImage.init(named: "play"), for: .normal)
            stopTimer()
        } else {
        musicPlayer?.startMusicPlayer()
        startTimer()
        playButton.setBackgroundImage(UIImage.init(named: "pause"), for: .normal)
        if let time = musicPlayer?.player?.duration {
            durationTimeLabel.text = musicPlayer?.convertTimetoStringFormat(time: time)
            }
        }
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        musicPlayer?.pauseMusicPlayer()
        stopTimer()
    }

    @IBAction func shuffleButtonClicked(_ sender: Any) {
        shuffleTrack()
    }
    
    @IBAction func slideChanged(_ sender: UISlider) {
        if (musicPlayer?.player?.isPlaying)! {
            musicPlayer?.playAtProgress(progress: sender.value)
        }
    }
   
    @IBAction func nextButtonPressed(_ sender: Any) {
        musicPlayer?.playNextTrack()
        progressSlider.value = 0.0
        setTrackBasicInfo()
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        musicPlayer?.playPreviousTrack()
        progressSlider.value = 0.0
        setTrackBasicInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

