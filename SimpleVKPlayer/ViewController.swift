//
//  ViewController.swift
//  SimpleVKPlayer
//
//  Created by admin on 13.03.16.
//  Copyright © 2016 Yukupov Aziz. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit




class ViewController: UIViewController, AVAudioPlayerDelegate {
    var blurEffectExtraLight : UIBlurEffect?
    var blurViewExtraLight : UIVisualEffectView?
    
    var audioPlayer : AVAudioPlayer?
    var currentTrackID : Int?
    var arrayTrack : [String]?
    var timer:NSTimer!
    var isPlaying = false
    
    @IBOutlet weak var trackLb: UILabel!
    
    @IBOutlet weak var artistLb: UILabel!
    
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var btPlay: UIButton!
    @IBOutlet weak var btNext: UIButton!
    @IBOutlet weak var btPrev: UIButton!

    @IBOutlet weak var playRandom: UIButton!
    @IBOutlet weak var playLoop: UIButton!
    @IBOutlet weak var showPlayList: UIButton!
    @IBOutlet weak var exitApp: UIButton!
    
    @IBOutlet weak var timerScroll: UISlider!
    @IBOutlet weak var volumeScroll: UISlider!
    
    @IBOutlet weak var mainCover: UIImageView?
    @IBOutlet weak var backgroundCover: UIImageView?
    
    @IBAction func play(sender: UIButton) {
        if audioPlayer!.playing {
 
            self.btPlay.setTitle("\u{f144}", forState: UIControlState.Normal)
            audioPlayer!.stop()
            isPlaying = false
            timer.invalidate()
            timer = nil
        } else {
            self.btPlay.setTitle("\u{f28d}", forState: UIControlState.Normal)
            audioPlayer!.play()
            isPlaying = true
            self.startTimer()
        }
    }
    
    
    @IBAction func next(sender: UIButton) {
        
        if (self.currentTrackID!  == ((self.arrayTrack?.count)! - 1)) {
          self.currentTrackID = 0
        } else {
          self.currentTrackID = self.currentTrackID! + 1
        }
        playTrack(self.arrayTrack![self.currentTrackID!])
        
    }
    
    
    @IBAction func previus(sender: UIButton) {
        if ( self.currentTrackID  == 0) {
            self.currentTrackID = (self.arrayTrack?.count)! - 1
        } else {
            self.currentTrackID = self.currentTrackID! - 1
        }
        playTrack(self.arrayTrack![self.currentTrackID!])
        
    }
    
    @IBAction func scrollVolumeChanged(sender: UISlider) {
        audioPlayer!.volume = sender.value
    }
    
    @IBAction func scrollTimeTrack(sender: UISlider) {
         let detectFutureTime = Double(sender.value) * audioPlayer!.duration
         audioPlayer!.currentTime = detectFutureTime
    }

    @IBAction func actionShowPlayList(sender: UIButton) {
        
        print("Show Play List")
    }
    
    @IBAction func actionLoopTrack(sender: UIButton) {
        
        print("Loop Track")
    }
    
    @IBAction func actionPlayRandom(sender: UIButton) {
        
        print("Random Play")
    }
    
    @IBAction func actionExitApp(sender: UIButton) {
        
        print("ExitApp")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //audioPlayer?.delegate = self
        addBlur()
        customSlider()

        self.arrayTrack = ["n1","n2","p1","pn1","s1","b1","b2","b3","j1","j2"]
        
        if self.currentTrackID == nil {
            self.currentTrackID = 0
            playTrack(arrayTrack![self.currentTrackID!])
        }
        

    }

    func playTrack(track : String) {
        let audioFilePath = NSBundle.mainBundle().pathForResource(track, ofType: "mp3")
        if audioFilePath != nil {
            let audioFileUrl = NSURL.fileURLWithPath(audioFilePath!)
            try! audioPlayer = AVAudioPlayer(contentsOfURL: audioFileUrl)
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
            audioPlayer!.volume = 0.5
            audioPlayer!.play()
            let playerItem = AVPlayerItem(URL: audioFileUrl)
            let metadataList = playerItem.asset.metadata
            getMetaData(metadataList)
            self.btPlay.setTitle("\u{f28d}", forState: UIControlState.Normal)
            self.startTimer()

        } else {
            print("audio file is not found")
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("Finish")
        
        if (self.currentTrackID!  == ((self.arrayTrack?.count)! - 1)) {
            self.currentTrackID = 0
        } else {
            self.currentTrackID = self.currentTrackID! + 1
        }
        playTrack(self.arrayTrack![self.currentTrackID!])

    }
    
    
    func getMetaData(metadataList : [AVMetadataItem]) {
        
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
    
    
    
    func addBlur() {
        blurEffectExtraLight = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        blurViewExtraLight = UIVisualEffectView(effect: blurEffectExtraLight)
        blurViewExtraLight!.frame = (self.backgroundCover?.bounds)!
        blurViewExtraLight?.alpha = 0.4
        blurViewExtraLight?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.backgroundCover!.addSubview(blurViewExtraLight!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTime() {
        let currentTime = Int(self.audioPlayer!.currentTime)
        let duration = Int(self.audioPlayer!.duration)
        let total = currentTime - duration
        
        let minutes = currentTime / 60
        let seconds = currentTime - (minutes * 60)
        
        let totalMinutes = -1 * (total / 60)
        let totalSeconds = (-1 * total) - (totalMinutes * 60)
        
        let min = convertDigitals(minutes)
        let sec = convertDigitals(seconds)
        
        let minTotal = convertDigitals(totalMinutes)
        let secTotal = convertDigitals(totalSeconds)

        self.startTime.text = "\(min):\(sec) "
        self.endTime.text = "-"+"\(minTotal):\(secTotal) "
        
        //print(self.audioPlayer!.currentTime)
        //print(self.audioPlayer!.duration)
        
        let tim = (self.audioPlayer!.currentTime * 1) / self.audioPlayer!.duration
        self.timerScroll.value = Float(tim)
        //print("Timer Work")
     
    }
    
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
    
    func customSlider () {

        
        timerScroll.minimumTrackTintColor = UIColor(red: 0/255, green: 80/255, blue: 255/255, alpha: 1.0) /* #0050ff */
        //timerScroll.backgroundColor = UIColor.redColor()
        timerScroll.maximumTrackTintColor = UIColor.whiteColor()

        timerScroll.setThumbImage(UIImage(named: "pan")!, forState: .Normal)

        volumeScroll.maximumTrackTintColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1.0) /* #efefef */
        volumeScroll.minimumTrackTintColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1.0) /* #191919 */
        
        volumeScroll.setThumbImage(UIImage(named: "volumePan")!, forState: .Normal)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}





