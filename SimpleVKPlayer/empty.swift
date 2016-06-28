//
//  empty.swift
//  SimpleVKPlayer
//
//  Created by admin on 26.06.16.
//  Copyright © 2016 Yukupov Aziz. All rights reserved.
//

import UIKit

class empty {

    /*
     for index in 0...(self.arrayTrack!.count - 1)  {
     
     //print(index)
     
     let audioFilePath = NSBundle.mainBundle().pathForResource(self.arrayTrack![index], ofType: "mp3")
     if audioFilePath != nil {
     ///print("Audio Good")
     
     let audioFileUrl = NSURL.fileURLWithPath(audioFilePath!)
     let playerItem = AVPlayerItem(URL: audioFileUrl)
     let metadataList = playerItem.asset.metadata
     
     var title = ""
     
     let asset = AVURLAsset(URL: NSURL(fileURLWithPath: audioFilePath!), options: nil)
     let audioDuration = asset.duration
     
     let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
     
     
     for item in metadataList {
     if item.commonKey == nil{
     continue
     }
     if let key = item.commonKey, let value = item.value {
     if key == "title" {
     title = (value as? String)!
     }
     }
     
     }
     //let track = TrackModel(trackTitle: title, trackTime: self.getTimer(Int(audioDurationSeconds)))
     //self.arrayTracksObjects?.append(track)
     }
     
     
     }
 
    
    func updateTime() {
        let currentTime = Int(self.APlayer.duration)
        let duration = Int(self.APlayer.duration)
        let total = currentTime - duration
        
        let totalMinutes = -1 * (total / 60)
        let totalSeconds = (-1 * total) - (totalMinutes * 60)
        
        let seconds = Int(currentTime) % 60
        let minutes = (Int(currentTime) / 60) % 60
        
        self.startTime.text = String(format: "%0.2d:%0.2d", minutes, seconds) //"\(min):\(sec) "
        self.endTime.text = String(format: "%0.2d:%0.2d", totalMinutes, totalSeconds) //"-"+"\(minTotal):\(secTotal) "
        
        //print(self.audioPlayer!.currentTime)
        //print(self.audioPlayer!.duration)
        
        //let tim = (self.audioPlayer!.currentTime * 1) / self.audioPlayer!.duration
        //self.timerScroll.value = Float(tim)
        
        
    }
    
    /*
     
     func getCurrentTimeAsString() -> String {
     var seconds = 0
     var minutes = 0
     if let time = player?.currentTime {
     seconds = Int(time) % 60
     minutes = (Int(time) / 60) % 60
     }
     return String(format: "%0.2d:%0.2d",minutes,seconds)
     }
     
     func startTimer(){
     timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateViewsWithTimer:"), userInfo: nil, repeats: true)
     }
     
     
     func updateViewsWithTimer(theTimer: NSTimer){
     updateViews()
     }
     
     
     func updateViews(){
     trackTime.text = mp3Player?.getCurrentTimeAsString()
     if let progress = mp3Player?.getProgress() {
     progressBar.progress = progress
     }
     }
     @IBAction func stopSong(sender: AnyObject) {
     mp3Player?.stop()
     updateViews()
     timer?.invalidate()
     }
     
     
     
     
     
     func setupNotificationCenter(){
     NSNotificationCenter.defaultCenter().addObserver(self,
     selector:"setTrackName",
     name:"SetTrackNameText",
     object:nil)
     }
     
     func setTrackName(){
     trackName.text = mp3Player?.getCurrentTrackName()
     }
     
     override func viewDidLoad() {
     super.viewDidLoad()
     mp3Player = MP3Player()
     setupNotificationCenter()
     }
     func queueTrack(){
     if(player != nil){
     player = nil
     }
     
     var error:NSError?
     let url = NSURL.fileURLWithPath(tracks[currentTrackIndex] as String)
     player = AVAudioPlayer(contentsOfURL: url, error: &error)
     
     if let hasError = error {
     //SHOW ALERT OR SOMETHING
     } else {
     player?.delegate = self
     player?.prepareToPlay()
     NSNotificationCenter.defaultCenter().postNotificationName("SetTrackNameText", object: nil)
     }
     }
     */
    
    func convertDigitals(digital : Int) ->String {
        var str = ""
        if digital < 10 {
            str = "0\(digital)"
        } else {
            str = "\(digital)"
        }
        return str
    }
    
    
    func startTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
    }
    
    
    func getMetaData(metadataList : [AVMetadataItem]) {
        
        self.mainCover!.image = UIImage(named: "emptyCover")
        self.backgroundCover!.image = UIImage(named: "emptyCover")
        
        self.trackLb.text = "Track"
        self.artistLb.text = "Artist"
        
        for item in metadataList {
            
            guard let key = item.commonKey, let value = item.value else{
                continue
            }
            switch key {
            case "title" : self.trackLb.text = value as? String
            case "artist": self.artistLb.text = value as? String
            case "artwork" where value is NSData :
                
                self.mainCover!.image = UIImage(data: value as! NSData)
                self.backgroundCover!.image = UIImage(data: value as! NSData)
                
            default:
                continue
            }
        }
        
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("Finish")
        
        if (self.currentTrackID!  == ((self.arrayTrack?.count)! - 1)) {
            self.currentTrackID = 0
        } else {
            self.currentTrackID = self.currentTrackID! + 1
        }
        playTrack(self.arrayTracksObjects[self.currentTrackID!].trackUrl!)
        
    }
    
    
    func getTimer(time : Int) -> String {
        let minutes = time / 60
        let seconds = time - (minutes * 60)
        
        let min = convertDigitals(minutes)
        let sec = convertDigitals(seconds)
        
        return "\(min):\(sec)"
    }
    
    */

}
