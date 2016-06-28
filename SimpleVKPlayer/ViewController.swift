//
//  ViewController.swift
//  SimpleVKPlayer
//
//  Created by admin on 13.03.16.
//  Copyright © 2016 Yukupov Aziz. All rights reserved.
//

import UIKit
import AVFoundation

import AVKit
import VK_ios_sdk
enum AudioMode {
    
    case Repeat
    case Random
    case Normal
}


enum StateTrack {
    case STKAudioPlayerStateReady
    case STKAudioPlayerStateRunning
    case STKAudioPlayerStatePlaying
    case STKAudioPlayerStateBuffering
    case STKAudioPlayerStatePaused
    case STKAudioPlayerStateStopped
    case STKAudioPlayerStateError
    case STKAudioPlayerStateDisposed
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, STKAudioPlayerDelegate {
    
    var blurEffectExtraLight : UIBlurEffect?
    var blurViewExtraLight : UIVisualEffectView?
    
    var AudioModeStatus : AudioMode = .Normal
    
    var AudioPlayer : STKAudioPlayer!
    
    var currentTrackID : Int?
    var arrayTrack : [String]?
    var timer:NSTimer!
    
    var isPlaying = false
    var isListShow = false
    var allMusicCount = 0
    var arrayTracksObjects = [TrackModel]()
    
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

    
    @IBAction func play(sender: UIButton) {
        
        if self.AudioPlayer == nil
        {
            return
        }

        if self.AudioPlayer.state.rawValue == 9
        {
            self.AudioPlayer.resume()
        }
        else
        {
            self.AudioPlayer.pause()
        }
    }
    
    
    @IBAction func next(sender: UIButton) {
        if self.currentTrackID == self.arrayTracksObjects.count - 1 {
            self.currentTrackID = 0
            self.playTrack(self.arrayTracksObjects[self.currentTrackID!].trackUrl!)
        } else {
            self.currentTrackID = self.currentTrackID! + 1
            self.playTrack(self.arrayTracksObjects[self.currentTrackID!].trackUrl!)
        }
    }
    
    
    @IBAction func previus(sender: UIButton) {
        if self.currentTrackID == 0  {
            self.currentTrackID = self.arrayTracksObjects.count - 1
            self.playTrack(self.arrayTracksObjects[self.currentTrackID!].trackUrl!)
        } else {
            self.currentTrackID = self.currentTrackID! - 1
            self.playTrack(self.arrayTracksObjects[self.currentTrackID!].trackUrl!)
        }
    }
    
    @IBAction func scrollVolumeChanged(sender: UISlider) {
        //print("Volume Scroll \(sender.value)")
        self.AudioPlayer.volume = sender.value
    }
    
    @IBAction func scrollTimeTrack(sender: UISlider) {
         let detectFutureTime = Double(sender.value) * AudioPlayer.duration
         AudioPlayer!.seekToTime(detectFutureTime)
    }

    @IBAction func actionShowPlayList(sender: UIButton) {
        if isListShow {
            UIView.animateWithDuration(0.5, animations: {
                self.mainCover!.frame = CGRectMake(self.mainCover!.bounds.origin.x, self.mainCover!.bounds.origin.y,
                                                                                self.mainCover!.bounds.size.width, self.mainCover!.bounds.size.height)

                
                self.isListShow = false
                self.showPlayList.setTitleColor(UIColor(red: 255/255, green: 191/255, blue: 0/255, alpha: 1.0), forState: .Normal)
            })

        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.mainCover!.frame = CGRectMake(self.mainCover!.bounds.origin.x, self.mainCover!.bounds.origin.y  - self.mainCover!.bounds.size.height - 20,
                                                                                self.mainCover!.bounds.size.width, self.mainCover!.bounds.size.height)

                self.isListShow = true
                self.showPlayList.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0), forState: .Normal)
            })
        }
    }
    
    @IBAction func actionLoopTrack(sender: UIButton) {
        print("Loop Track")
        
        if self.AudioModeStatus == .Repeat {
           self.AudioModeStatus = .Normal
        } else {
           self.AudioModeStatus = .Repeat
        }
        upadetBtn()
    }
    
    @IBAction func actionPlayRandom(sender: UIButton) {
        if self.AudioModeStatus == .Random {
            self.AudioModeStatus = .Normal
        } else {
            self.AudioModeStatus = .Random
        }
        upadetBtn()
    }
    
    func upadetBtn(){
        switch self.AudioModeStatus {
            case .Normal : print("Normal")
            
            playRandom.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0) , forState: .Normal)
            playLoop.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0) , forState: .Normal)
            //showPlayList.setTitleColor(UIColor(red: 255/255, green: 191/255, blue: 0/255, alpha: 1.0) , forState: .Normal)
            
            case .Repeat : print("Repeat")
            playRandom.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0) , forState: .Normal)
            playLoop.setTitleColor(UIColor(red: 255/255, green: 191/255, blue: 0/255, alpha: 1.0) , forState: .Normal)
            //showPlayList.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0) , forState: .Normal)
        
            case .Random : print("Random")
            playRandom.setTitleColor(UIColor(red: 255/255, green: 191/255, blue: 0/255, alpha: 1.0) , forState: .Normal)
            playLoop.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0) , forState: .Normal)
            //showPlayList.setTitleColor(UIColor(red: 255/255, green: 191/255, blue: 0/255, alpha: 1.0) , forState: .Normal)
        }
        
    
    }
    
    @IBAction func actionExitApp(sender: UIButton) {
        
        //self.AudioPlayer.stop()
        self.AudioPlayer.clearQueue()
        timer?.invalidate()
        
        print("ExitApp")
        VKSdk.forceLogout()
        let isLogged = VKSdk.isLoggedIn()
        if isLogged == true {
            print("Пользователь авторизован")
        } else if isLogged == false {
            print("Пользователь не авторизован")
            let VC1 = self.storyboard!.instantiateViewControllerWithIdentifier("LoginForm") as! LoginForm
            self.navigationController!.pushViewController(VC1, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        customSlider()
        getMusic()

        self.AudioPlayer = STKAudioPlayer()
        self.AudioPlayer.volume = 0.5
        self.AudioPlayer.equalizerEnabled = true
        
        self.AudioPlayer.delegate = self
        self.currentTrackID = 0
        
        self.showPlayList.setTitleColor(UIColor(red: 255/255, green: 191/255, blue: 0/255, alpha: 1.0), forState: .Normal)
        
    }
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.checkInternetStatus()
    }

    func startTimer(){
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.updateViewsWithTimer(_:)), userInfo: nil, repeats: true)
    }
    func updateViewsWithTimer(theTimer: NSTimer){
        self.updateViews()
    }
    
    func updateViews() {
        self.timerScroll.value = Float(self.AudioPlayer.progress / self.AudioPlayer.duration)

        let currentTime = Int(self.AudioPlayer.progress)
        let duration = Int(self.AudioPlayer.duration)
        let total = currentTime - duration
        
        let totalMinutes = -1 * (total / 60)
        let totalSeconds = (-1 * total) - (totalMinutes * 60)
        
        let seconds = Int(currentTime) % 60
        let minutes = (Int(currentTime) / 60) % 60
        
        self.startTime.text = String(format: "%0.2d:%0.2d", minutes, seconds)
        self.endTime.text = String(format: "-%0.2d:%0.2d", totalMinutes, totalSeconds)
        //print("timer is work")
    }
        
    func getTimer (time : Int) -> String  {
        let seconds = time % 60
        let minutes = (time / 60) % 60
        return String(format: "%0.2d:%0.2d", minutes, seconds)
    }
    
    
    func getMusic(offset : Int = 0) {
        
        let audioReq : VKRequest = VKRequest(method: "audio.get", parameters:  ["owner_id": VKSdk.accessToken().userId, "count":"50", "offset" : offset])
        audioReq.executeWithResultBlock(
            {
                (response) -> () in
                var tempArray = [TrackModel]()
                let audios =  response.json as! NSDictionary
                
                let audiosCount = audios["count"]!
                self.allMusicCount = Int(audiosCount as! NSNumber)
                
                
                let tracks = audios["items"] as! NSArray
                for index in 0...tracks.count - 1 {
                    let firstTrack = tracks[index]
                    let firstTrackAuthor = firstTrack["artist"]! as! String
                    let firstTrackName = firstTrack["title"]!  as! String
                    let firstTrackDuration = self.getTimer(firstTrack["duration"]! as! Int)
                    let firstTrackUrl = firstTrack["url"]! as! String

                    let track = TrackModel(trackTitle: firstTrackName, trackTime: firstTrackDuration, trackUrl: firstTrackUrl, trackArtist: firstTrackAuthor)
                    tempArray.append(track)
                }
                self.arrayTracksObjects.appendContentsOf(tempArray)
                
                
                self.tableView?.reloadData()
            }, errorBlock: {
                (error) -> () in
                print(error)
                
        })
    }
    
    

    

    func playTrack(track : String?) {
        self.checkInternetStatus()

        AudioPlayer.play(track!)

        //self.getMetaData(track!)

        self.trackLb.text = self.arrayTracksObjects[self.currentTrackID!].trackTitle!.truncate(20)
        self.artistLb.text = self.arrayTracksObjects[self.currentTrackID!].trackArtist!.truncate(20)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView!.reloadData()
        })
    }
    
    func getMetaData(track : String) {
        
        self.mainCover!.image = UIImage(named: "emptyCover")
        self.trackLb.text = "Track"
        self.artistLb.text = "Artist"
        
 
    }

    
    func audioPlayer(audioPlayer: STKAudioPlayer, didFinishBufferingSourceWithQueueItemId queueItemId: NSObject) {
        //print("didFinishBufferingSourceWithQueueItemId")
    }
    
    func audioPlayer(audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, withReason stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double) {
        print("didFinishPlayingQueueItemId")
        
        if self.AudioPlayer.state.rawValue == 16 {
        
        switch self.AudioModeStatus {
        case .Normal :
            
            if (self.arrayTracksObjects.count - 1 == self.currentTrackID) {
                 self.currentTrackID = 0
                 playTrack(self.arrayTracksObjects[self.currentTrackID!].trackUrl!)
            } else {
                 self.currentTrackID = self.currentTrackID! + 1
                 playTrack(self.arrayTracksObjects[self.currentTrackID!].trackUrl!)
            }
            
            
            case .Repeat : playTrack(self.arrayTracksObjects[self.currentTrackID!].trackUrl!)
            case .Random :
                
                let k: Int = random() % (self.arrayTracksObjects.count - 1);
                self.currentTrackID = k;
                playTrack(self.arrayTracksObjects[self.currentTrackID!].trackUrl!);
         
        }
        }

        
    }
    
    func audioPlayer(audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode) {
        //print("unexpectedError")
    }
    
    func audioPlayer(audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject) {
        //print("didStartPlayingQueueItemId")
    }
    
    func audioPlayer(audioPlayer: STKAudioPlayer, logInfo line: String) {
        //print("logInfo")
    }
    
    func audioPlayer(audioPlayer: STKAudioPlayer, didCancelQueuedItems queuedItems: [AnyObject]) {
        //print("didCancelQueuedItems")
    }
    
    func audioPlayer(audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState) {
        switch state.rawValue {
            case 3 : timer?.invalidate(); self.startTimer(); btPlay.setTitle("\u{f28d}", forState: .Normal); self.tableView?.reloadData(); //print("play");
            case 9 : timer?.invalidate(); btPlay.setTitle("\u{f144}", forState: .Normal); self.tableView?.reloadData(); // print("pause");
            case 16 : timer?.invalidate(); btPlay.setTitle("\u{f144}", forState: .Normal); self.tableView?.reloadData(); // print("stop");
            case 5 : print("");
            default : break
        }
        print(state)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func customSlider() {
        timerScroll.minimumTrackTintColor = UIColor(red: 0/255, green: 80/255, blue: 255/255, alpha: 1.0) /* #0050ff */
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
        return self.arrayTracksObjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! myCell

        if self.currentTrackID! == indexPath.row {
            cell.backgroundColor = UIColor(red: 255/255, green: 191/255, blue: 0/255, alpha: 1.0) /* #ffbf00 */

            cell.cellTrackName.text = self.arrayTracksObjects[indexPath.row].trackTitle!.truncate(30, trailing: "...")
            if self.AudioPlayer.state.rawValue == 3  || self.AudioPlayer.state.rawValue == 5 {
                cell.cellTrackName.addImage("iconPlay.png")
            } else {
                cell.cellTrackName.addImage("iconStop.png")
            }
            cell.timePlay.text = self.arrayTracksObjects[indexPath.row].trackTime

        } else {
           cell.backgroundColor = UIColor(red: 256/256, green: 256/256, blue: 256/256, alpha: 1.0)
           cell.cellTrackName.text = self.arrayTracksObjects[indexPath.row].trackTitle!.truncate(30, trailing: "...")
           cell.timePlay.text = self.arrayTracksObjects[indexPath.row].trackTime
        }
        
        
        if (indexPath.row == self.arrayTracksObjects.count - 1) && (allMusicCount != self.arrayTracksObjects.count - 1) {
            print("Вы в конце таблицы")
            self.getMusic(self.arrayTracksObjects.count - 1)
        }
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentTrackID! = indexPath.row
        playTrack(self.arrayTracksObjects[self.currentTrackID!].trackUrl!)
        //self.tableView?.reloadData()
    }
    
    func checkInternetStatus() {
        if Reachability.isConnectedToNetwork() == true {
            //print("Интернет есть все хорошо!")
        } else {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ConnectInternet") as! ConnectInternet
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    

    
}


extension String {
    /// Truncates the string to length number of characters and
    /// appends optional trailing string if longer
    func truncate(length: Int, trailing: String? = nil) -> String {
        if self.characters.count  > length {
            
            let index = self.startIndex.advancedBy(length)
            
            return self.substringToIndex(index) + (trailing ?? "")
        } else {
            return self
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





