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





class ViewController: UIViewController, AVAudioPlayerDelegate, UITableViewDelegate, UITableViewDataSource {
    var blurEffectExtraLight : UIBlurEffect?
    var blurViewExtraLight : UIVisualEffectView?
    
    var audioPlayer : AVAudioPlayer?
    var currentTrackID : Int?
    var arrayTrack : [String]?
    var timer:NSTimer!
    var isPlaying = false
    var isListShow = false
    
    var arrayTracksObjects : [TrackModel]?
    
    @IBOutlet weak var tableView: UITableView?
    
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

        if isListShow {
            UIView.animateWithDuration(0.5, animations: {
                self.mainCover!.frame = CGRectMake(self.mainCover!.bounds.origin.x, self.mainCover!.bounds.origin.y,
                                                                                self.mainCover!.bounds.size.width, self.mainCover!.bounds.size.height)
                self.backgroundCover!.frame = CGRectMake(self.backgroundCover!.bounds.origin.x, self.backgroundCover!.bounds.origin.y,
                    self.backgroundCover!.bounds.size.width, self.backgroundCover!.bounds.size.height)
                
                self.isListShow = false
            })

        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.mainCover!.frame = CGRectMake(self.mainCover!.bounds.origin.x - self.mainCover!.bounds.size.width - 20, self.mainCover!.bounds.origin.y,
                                                                                self.mainCover!.bounds.size.width, self.mainCover!.bounds.size.height)
                self.backgroundCover!.frame = CGRectMake(self.backgroundCover!.bounds.origin.x - self.backgroundCover!.bounds.size.width - 20, self.backgroundCover!.bounds.origin.y,
                    self.backgroundCover!.bounds.size.width, self.backgroundCover!.bounds.size.height)
                self.isListShow = true
            })
        }

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
    
    func hidePlayList() {
        UIView.animateWithDuration(2, animations: {
            //self.tableView!.frame = self.backgroundCover!.bounds
        })
    }
    
    
    var tickerView:RSingleTickerView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.checkInternetStatus()
    }
    
    override func viewDidLoad() {


        super.viewDidLoad()
        //audioPlayer?.delegate = self
        
        addBlur()
        customSlider()
        hidePlayList()

        self.arrayTrack = ["v1", "e1", "s1", "b1", "b2", "b3", "n1", "n2", "p1", "pn1", "j1", "j2"]
        self.arrayTracksObjects = []
        
        
        
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
                let track = TrackModel(trackTitle: title, trackTime: self.getTimer(Int(audioDurationSeconds)))
                self.arrayTracksObjects?.append(track)
            }
            
  
        }

        
        if self.currentTrackID == nil {
            self.currentTrackID = 0
            playTrack(arrayTrack![self.currentTrackID!])
        }
        

    }
    
    func getTimer(time : Int) -> String {
        let minutes = time / 60
        let seconds = time - (minutes * 60)

        let min = convertDigitals(minutes)
        let sec = convertDigitals(seconds)
 
        return "\(min):\(sec)"
    }

    func playTrack(track : String) {
        
        self.checkInternetStatus()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView!.reloadData()
        })
        
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
            //print(metadataList)
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
    
    
    
    func addBlur() {
        blurEffectExtraLight = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        blurViewExtraLight = UIVisualEffectView(effect: blurEffectExtraLight)
        blurViewExtraLight!.frame = (self.backgroundCover?.bounds)!
        blurViewExtraLight?.alpha = 0.4
        //blurViewExtraLight?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
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
        return UIStatusBarStyle.Default
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTrack!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! myCell
        
        
        
        //cell.cellType.text = arr[indexPath.row].type
        //cell.cellImage.image = UIImage(named: arr[indexPath.row].image)
        //cell.cellImage.layer.cornerRadius = cell.cellImage.frame.size.height / 2
        //cell.cellImage.clipsToBounds = true
        if self.currentTrackID! == indexPath.row {
           cell.backgroundColor = UIColor(red: 255/255, green: 191/255, blue: 0/255, alpha: 1.0) /* #ffbf00 */
           
           //cell.cellTrackName.text = self.arrayTrack![indexPath.row]  //self.playingTrackTitle(self.arrayTrack![indexPath.row])
           cell.cellTrackName.text = self.arrayTracksObjects![indexPath.row].trackTitle
            cell.cellTrackName.addImage("iconPlay.png")
            cell.timePlay.text = self.arrayTracksObjects![indexPath.row].trackTime

        } else {
           cell.backgroundColor = UIColor(red: 256/256, green: 256/256, blue: 256/256, alpha: 1.0)
           //cell.cellTrackName.text = self.arrayTrack![indexPath.row]
            cell.cellTrackName.text = self.arrayTracksObjects![indexPath.row].trackTitle
            cell.timePlay.text = self.arrayTracksObjects![indexPath.row].trackTime
        }
        
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentTrackID! = indexPath.row
        playTrack(self.arrayTrack![self.currentTrackID!])
    }
    
    func checkInternetStatus() {
        if Reachability.isConnectedToNetwork() == true {
            
        } else {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ConnectInternet") as! ConnectInternet
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
 
    
}

extension UILabel
{
    func addImage(imageName: String, afterLabel bolAfterLabel: Bool = false)
    {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        if (bolAfterLabel)
        {
            let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            strLabelText.appendAttributedString(attachmentString)
            
            self.attributedText = strLabelText
        }
        else
        {
            let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
            let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.appendAttributedString(strLabelText)
            
            self.attributedText = mutableAttachmentString
        }
    }
    
    func removeImage()
    {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}





