//
//  ViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-06-25.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class AVViewController: UIViewController {

    var player: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Slide Button
        self.navigationController?.navigationBar.isHidden = true
        let button = AnimatedMenuButton(frame: CGRect(x: 10, y: 30, width: 30, height: 30))
        button.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(AVViewController.leftDrawerButtonPress))
        button.addGestureRecognizer(tap)
        
        //if let resourceURL = NSBundle.mainBundle().pathForResource("video2", ofType: "MOV") {
        if let resourceURL = Bundle.main.path(forResource: "preview", ofType: "mp4") {
           
////            self.player = AVPlayer(URL: URL(fileURLWithPath: resourceURL))
            self.player = AVPlayer(url: URL(fileURLWithPath: resourceURL))
            let playerController = AVPlayerViewController()
            
            playerController.player = player
            playerController.showsPlaybackControls = false
////            playerController.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.addChildViewController(playerController)
            self.view.addSubview(playerController.view)
            playerController.view.frame = self.view.frame
            view.addSubview(button)

            NotificationCenter.default.addObserver(self,
                                                             selector: #selector(AVViewController.playerItemDidReachEnd),
                                                             name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                             object: self.player.currentItem)
        
            player.play()
            
        } else {
            print("Unable to find video")
        }
        
    }
    @objc func leftDrawerButtonPress(sender: AnyObject?) {
        print("selected")
        self.evo_drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)
    }

    @objc func playerItemDidReachEnd(notification: NSNotification) {
        self.player.seek(to: kCMTimeZero)
        self.player.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

