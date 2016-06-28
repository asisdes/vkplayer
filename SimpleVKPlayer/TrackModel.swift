//
//  trackModel.swift
//  SimpleVKPlayer
//
//  Created by admin on 23.06.16.
//  Copyright © 2016 Yukupov Aziz. All rights reserved.
//

import UIKit

class TrackModel {  
        var trackTitle : String?
        var trackTime : String?
        var trackUrl : String?
        var trackArtist : String?
    
        init(trackTitle : String, trackTime : String, trackUrl : String, trackArtist : String) {
          self.trackTitle = trackTitle
          self.trackTime = trackTime
          self.trackUrl = trackUrl
          self.trackArtist = trackArtist
        }
}


