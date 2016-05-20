//
//  ViewController.swift
//  Rad-io
//
//  Created by George on 2016-05-19.
//  Copyright © 2016 George. All rights reserved.
//

import UIKit
import AlamofireImage
import AVFoundation
import MediaPlayer

struct Player {
    static var radio = AVPlayer()
    static var currentStation: String! = ""
}

var globalTrack = Track()
var placeHolderImg = "kingslanding_castle_d-1"

class PlayerViewController: UIViewController {
    
    @IBOutlet var playBtn: UIButton!
    @IBOutlet var pauseBtn: UIButton!
    @IBOutlet var stationName: UILabel!
    @IBOutlet var currentSong: UILabel!
    @IBOutlet var currentSong_Art: UIImageView!
    
    var currentStation: Station!
    private var playerItem: AVPlayerItem!
    var track: Track!
    var delegate: NowPlayingViewControllerDelegate?
    
    override func viewDidLoad() {
   
        
        /**
         *  Check if currentStation being played is equal to the previous to prevents pointless reloading
         */
        if Player.currentStation != currentStation.station_name{
            playerItem = AVPlayerItem(URL: NSURL(string: currentStation.station_url)!)
            Player.radio = AVPlayer(playerItem: playerItem)
            playerItem.addObserver(self, forKeyPath: "timedMetadata", options: NSKeyValueObservingOptions.New, context: nil)
            playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(), context: nil)
            
            Player.radio.play()
            track = Track()
            globalTrack = track
            Player.currentStation = currentStation.station_name
            NSNotificationCenter.defaultCenter().postNotificationName("DataChanged", object: nil)
            
        }else{
            if globalTrack.title != ""{
                currentSong.text = globalTrack.title
            }
            if globalTrack.artwork != ""{
                self.currentSong_Art.af_setImageWithURL(NSURL(string: globalTrack.artworkCover)!)
            }else{
                setDefaultImage()
            }
        }
        stationName.text = currentStation.station_name
    }
    
    /**
     Pass track to stationsViewController to update UI
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowStations" {
            let infoController = segue.destinationViewController as! StationViewController
            infoController.currentTrack = track
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     setDefault image if image cannot be found
     */
    func setDefaultImage(){
        self.currentSong_Art.image = UIImage(named: placeHolderImg)
    }
    
    //MARK: Play controlls
    
    /**
     Play station if audio player is not currently playing
     
     - parameter sender: <#sender description#>
     */
    @IBAction func playSong(sender: AnyObject){
        if track.isPlaying == false{
            Player.radio.play()
            track.isPlaying = true
            globalTrack = track
            delegate?.trackPlayingToggled(track)
        }
    }
    
    @IBAction func pauseSong(sneder: AnyObject){
        if track.isPlaying == true{
            Player.radio.pause()
            track.isPlaying = false
            globalTrack = track
            delegate?.trackPlayingToggled(track)
        }
    }
    
    //MARK: Notification Updates
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        guard keyPath == "timedMetadata" else { return }
        
        for item in playerItem.timedMetadata! {
            
            if item.commonKey == "title" {
                let value = item.value
                print("NOW PLAYING:", value!)
                track.title = String(value!)
                currentSong.text = String(value!)
                
                var searchterm = track.title
                if let range = searchterm.rangeOfString("(") {
                    searchterm.removeRange(range.startIndex..<searchterm.endIndex)
                }
                if let range = searchterm.rangeOfString("[") {
                    searchterm.removeRange(range.startIndex..<searchterm.endIndex)
                }
                track.itunesSearchTerm = searchterm
                delegate?.songMetaDataDidUpdate(track)
                getArtwork()
                track.isPlaying = true
                globalTrack = track
                delegate?.trackPlayingToggled(track)
                
            } else {
                print("NO SONG TITLE FOUND")
                track.title = currentStation.station_name
                currentSong.text = currentStation.station_name
                globalTrack = track
                delegate?.songMetaDataDidUpdate(track)
            }
            NSNotificationCenter.defaultCenter().postNotificationName("DataChanged", object: nil)
            updateRemotePlayer()

        }
    }
    
    /**
     Set image and information for lock free
     */
    func updateRemotePlayer(){
        let albumArt = MPMediaItemArtwork(image: globalTrack.image)
        let songInfo = [
            MPMediaItemPropertyTitle: globalTrack.title,
            MPMediaItemPropertyArtist: "Rad-io",
            MPMediaItemPropertyArtwork: albumArt
        ]
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = songInfo
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    
    
    func getArtwork(){
        ItunesAPI.getTrackArtwork(track.itunesSearchTerm){
            art in
            if art != nil{
                self.track.artwork = art!
                let coverArt = art?.stringByReplacingOccurrencesOfString("100x100", withString: "400x400")
                ItunesAPI.downloadImage(coverArt!){
                    img in
                    self.currentSong_Art.image = img
                    self.track.artworkCover = coverArt!
                    self.track.image = img
                    globalTrack = self.track
                    self.delegate?.artworkDidUpdate(self.track)
                    NSNotificationCenter.defaultCenter().postNotificationName("ArtworkChanged", object: true)
                    self.updateRemotePlayer()
                }
                
            }else{
                self.setDefaultImage()
                self.track.artworkCover = ""
                self.track.artwork = ""
                globalTrack = self.track
                self.delegate?.artworkDidUpdate(self.track)
                NSNotificationCenter.defaultCenter().postNotificationName("ArtworkChanged", object: false)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

