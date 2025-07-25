//
//  SlideViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-07-21.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit

class SlideViewController: UIViewController {
    
    var bgImage: UIImageView?
    var stripeImages: [UIImage] = [
        UIImage(named: "launch.png")!,
        
        //        UIImage(named: "stripe-jake.png")!,
        //        UIImage(named: "stripe-luke.png")!,
        //        UIImage(named: "stripe-stacey.png")!,
        //        UIImage(named: "stripe-janet.png")!,
        //        UIImage(named: "stripe-joe.png")!
    ]
    var imageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make NavBar invisible
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        // Add NavButton
        let leftDrawerButton = DrawerBarButtonItem(target: self, action: #selector(HomeViewController.leftDrawerButtonPress(_:)))
        self.navigationItem.setLeftBarButtonItem(leftDrawerButton, animated: true)
        
        // Setup Rotating images
        let image: UIImage = UIImage(named: "launch.png")!
        bgImage = UIImageView(image: image)
        bgImage!.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)
        bgImage?.contentMode = .ScaleAspectFill
        bgImage?.autoresizingMask = (.FlexibleBottomMargin)
        self.view.addSubview(bgImage!)
        
        updateTime()
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(SlideViewController.updateTime),
                                               userInfo: nil, repeats: true)
        
    }
    func leftDrawerButtonPress(sender: AnyObject?) {
        self.evo_drawerController?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    func updateTime() {
        bgImage?.image = stripeImages[imageIndex]
        //        print("updateTime \(imageIndex)")
        imageIndex += 1
        if (imageIndex > stripeImages.count - 1) {
            imageIndex = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}