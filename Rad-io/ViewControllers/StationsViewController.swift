//
//  StationsViewController.swift
//  Rad-io
//
//  Created by George on 2016-05-19.
//  Copyright © 2016 George. All rights reserved.
//

import Foundation
import UIKit


//FIXME: , NowPlayingViewControllerDelegate
class StationViewController: UIViewController, UITableViewDelegate{
    
    @IBOutlet var tableView: UITableView!
    var stations = [Station]()
    @IBOutlet var miniPlayerView: UIView!
    var currentTrack: Track?
    @IBOutlet weak  var playBtn: UIButton!
    @IBOutlet weak  var songTitle: UILabel!
    @IBOutlet weak  var songImg: UIImageView!
    
    override func viewDidLoad() {
        Station.retriveStations(){
            if let data = $0.stations{
                self.stations = data
                self.tableView.reloadData()
            }
        }        
        miniPlayerView.hidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateUI), name:"DataChanged", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateArtwork), name:"ArtworkChanged", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func updateUI(){
        if globalTrack.title != ""{
            self.songTitle.text = globalTrack.title
            miniPlayerView.hidden = false
            updatePlayBtn(globalTrack.isPlaying)
        }
    }
    
    
    func updateArtwork(){
        songImg.image = globalTrack.image
    }
    
    func updatePlayBtn(status: Bool){
        if status == false{
            playBtn.setImage(UIImage(named: "play"), forState: .Normal)
        }else{
            playBtn.setImage(UIImage(named: "pause"), forState: .Normal)
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if globalTrack.title != ""{
            miniPlayerView.hidden = false
            updateUI()
            updateArtwork()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.text = stations[indexPath.row].station_name
        if let desc = stations[indexPath.row].station_desc{
            cell?.detailTextLabel?.text = desc
        }
        return cell!
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showPlayer", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let index = tableView.indexPathForSelectedRow{
            let currentStation = stations[index.row]
            let vc = segue.destinationViewController as! PlayerViewController
            vc.currentStation = currentStation
            //            vc.delegate = self
            if globalTrack.title != ""{
                vc.track = globalTrack
            }
        }
    }
    
    
    @IBAction func playButtonTapped(sender: AnyObject){
        if globalTrack.isPlaying == false{
            Player.radio.play()
            globalTrack.isPlaying = true
        }else{
            Player.radio.pause()
            globalTrack.isPlaying = false
        }
        updatePlayBtn(globalTrack.isPlaying)
    }
    
    //FIXME: Get delegates to update UI and replace notifications
    //    func songMetaDataDidUpdate(track: Track) {
    //    }
    //
    //    func artworkDidUpdate(track: Track) {
    //    }
    //
    //    func trackPlayingToggled(track: Track) {
    //    }
    //    
    
}