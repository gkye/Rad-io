//
//  ViewController.swift
//  Rad-io
//
//  Created by George on 2016-05-19.
//  Copyright © 2016 George. All rights reserved.
//

import UIKit
import KDEAudioPlayer
import AVFoundation
import MediaPlayer

struct Player {
    static var radio = AVPlayer()
}



class ViewController: UIViewController {
    
    private var url = "http://tuneinads.moodmedia.com/streams/bad_girl_radio_with_ads.acp"
    private var playerItem: AVPlayerItem!

    override func viewDidLoad() {
         playerItem = AVPlayerItem(URL: NSURL(string: url)!)
        Player.radio = AVPlayer(playerItem: playerItem)
        playerItem.addObserver(self, forKeyPath: "timedMetadata", options: NSKeyValueObservingOptions.New, context: nil)
        Player.radio.play()
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        guard keyPath == "timedMetadata" else { return }
        
        for item in playerItem.timedMetadata! {
            
            if item.commonKey == "title" {
                let value = item.value
                print(value)
            } else {
                print(item.key)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

