//
//  FunViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-07-10.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//


import UIKit
import AVFoundation

class FunViewController: ContentViewController {
    
    var player:AVAudioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioPath = Bundle.main.path(forResource: "beat", ofType: "mp3")
        //var error:NSError? = nil
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        }
        catch {
            print("Something bad happened. Try catching specific errors to narrow things down")
        }

    }
    
////    override func preferredStatusBarStyle() -> UIStatusBarStyle {
////        return .lightContent
////    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
////    override func canBecomeFirstResponder() -> Bool {
////        return true
////    }
    override var canBecomeFirstResponder: Bool { return true }
    
////    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent!) {
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent!) {
        if(event.subtype == UIEventSubtype.motionShake) {
            print("Shake!!!")
            player.play()
        }
    } // motionEnded()
 
    

}
