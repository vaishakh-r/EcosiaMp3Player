//
//  MusicPlayer.swift
//  EcosiaMp3Player
//
//  Created by Vaishakh on 3/29/17.
//  Copyright © 2017 Vaishakh. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import MediaPlayer

class MusicPlayer: NSObject, AVAudioPlayerDelegate {
    
    var player:AVAudioPlayer?
    var mp3Tracks:[String] = []
    var currentPlayingTrackUrl:URL?
    weak var musicPlayerDelegate:MusicPlayerDelegate?
    var currentMusicIndex = 0
    
    // designated initializer
    override init() {
        super.init()
        registerForRemoteControl()
        initAllMp3Files()
        setRandomTrack()
    }
    
    func registerForRemoteControl() {
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        if #available(iOS 9.1, *) {
            commandCenter.changePlaybackPositionCommand.isEnabled = true
            
            commandCenter.changePlaybackPositionCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
                self.player?.currentTime = event.timestamp
                return MPRemoteCommandHandlerStatus.success
            }
        }
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget(self, action:#selector(resetMusicTrack))
        
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget(self, action:#selector(resetMusicTrack))
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.player?.pause()
            _ = try? AVAudioSession.sharedInstance().setActive(false)
            return MPRemoteCommandHandlerStatus.success
        }
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget(self, action:#selector(startMusicPlayer))
        commandCenter.togglePlayPauseCommand.isEnabled = true
        
    }
    
    
    func startMusicPlayer() {
        player?.play()
        setMetaDataInformation()
    }
    
    func setMetaDataInformation() {
        let metaInfo = getMetaData()
        if let artwork = metaInfo.artwork {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyArtist : metaInfo.artist ?? "",  MPMediaItemPropertyTitle : metaInfo.title ?? "", MPMediaItemPropertyPlaybackDuration:
                player?.duration ?? 0.0, MPNowPlayingInfoPropertyElapsedPlaybackTime: player?.currentTime ?? 0.0,MPMediaItemPropertyArtwork:MPMediaItemArtwork(image: artwork)]
        } else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyArtist : metaInfo.artist ?? "",  MPMediaItemPropertyTitle : metaInfo.title ?? "", MPMediaItemPropertyPlaybackDuration:
                player?.duration ?? 0.0, MPNowPlayingInfoPropertyElapsedPlaybackTime: player?.currentTime ?? 0.0]
        }
    
    }
    
    func getMetaData() -> Metadata {
        let asset = AVAsset.init(url: currentPlayingTrackUrl!)
        let metaItem = Metadata()
        for format in asset.availableMetadataFormats {
            
            for metadataItem in asset.metadata(forFormat: format) {
                guard  let commonKey = metadataItem.commonKey else {
                    continue
                }
                if commonKey == "title" {
                    metaItem.title = metadataItem.stringValue
                } else if commonKey == "artist" {
                    metaItem.artist = metadataItem.stringValue
                } else if commonKey == "albumName" {
                    metaItem.albumName = metadataItem.stringValue
                } else if commonKey == "artwork" {
                    guard let imageData = metadataItem.value as? NSData, metaItem.artwork == nil  else{
                        continue
                    }
                    let image = UIImage.init(data: imageData as Data)
                    metaItem.artwork = image
                }
                print(commonKey)
            }
        }
        return metaItem
    }
    
    func setRandomTrack() {
        let randomIndex = Int(arc4random_uniform(UInt32(mp3Tracks.count)))
        currentMusicIndex = randomIndex
        setTrackAtIndex(randomIndex: randomIndex)
    }
    
    func setTrackAtIndex(randomIndex: Int) {
        let randomPath = mp3Tracks[randomIndex]
        currentPlayingTrackUrl = URL.init(fileURLWithPath: randomPath)
        do {
            player = try AVAudioPlayer.init(contentsOf: currentPlayingTrackUrl!)
            player?.delegate = self
            player?.prepareToPlay()
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func playPreviousTrack() {
        if currentMusicIndex > 0 {
            currentMusicIndex -= 1
        } else {
            currentMusicIndex = mp3Tracks.count-1
        }
        setTrackAtIndex(randomIndex: currentMusicIndex)
        startMusicPlayer()
    }
    
    func playNextTrack() {
        if currentMusicIndex < mp3Tracks.count-1 {
            currentMusicIndex += 1
        } else {
            currentMusicIndex = 0
        }
        setTrackAtIndex(randomIndex: currentMusicIndex)
        startMusicPlayer()
    }
    
    func initAllMp3Files() {
        let paths = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil)
        mp3Tracks = paths
    }
    
    
    func pauseMusicPlayer() {
        player?.pause()
    }
    
    func stopMusicPlayer() {
        player?.stop()
    }
    
    func resetMusicTrack() {
        setRandomTrack()
        startMusicPlayer()
    }
    
    func getCurrentTimeAsString() -> String {
        if let time = player?.currentTime {
          return convertTimetoStringFormat(time: time)
        }
        return ""
    }
    
    func convertTimetoStringFormat(time: Double) -> String {
        let seconds = Int(time) % 60
        let minutes = (Int(time) / 60) % 60
        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
    
    func getProgress() -> Float {
        var theCurrentTime = 0.0
        var theCurrentDuration = 0.0
        if let currentTime = player?.currentTime, let duration = player?.duration {
            theCurrentTime = currentTime
            theCurrentDuration = duration
        }
        return Float(theCurrentTime / theCurrentDuration)
    }
    
    func playAtProgress(progress: Float) {
        if let duration = player?.duration {
            let currentTime = Double(duration)*Double(progress)
            player?.currentTime = currentTime
        }
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio Finished playing")
        musicPlayerDelegate?.startNewTrackPlay()
    }
    
}


protocol MusicPlayerDelegate: class {
    func startNewTrackPlay()
}

class Metadata {
    var title:String?
    var artist:String?
    var albumName:String?
    var artwork:UIImage?
}
