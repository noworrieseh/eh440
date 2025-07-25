//
//  YouTubeViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-06-30.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit

class YouTubeViewController: ContentViewController, YouTubePlayerDelegate  {

    var videoPlayer: YouTubePlayerView!
    var url: String = String()

    override func viewDidLoad() {
        super.viewDidLoad()
     
        videoPlayer = YouTubePlayerView(frame: self.view.bounds)
        videoPlayer.delegate = self
        let videoURL = URL(string: url)
        videoPlayer.loadVideoURL(videoURL!)
        videoPlayer.play()
        
        self.view.addSubview(videoPlayer)

    } // viewDidLoad()

    func playerReady(videoPlayer: YouTubePlayerView) {
        print("player ready...")
        videoPlayer.play()
    } // playerReady()

} // YouTubeViewController()

 
