//
//  ContentViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-07-03.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    var back = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add NavButton
        if (back == false) {
            let leftDrawerButton = DrawerBarButtonItem(target: self, action:
                #selector(ContentViewController.leftDrawerButtonPress))
            self.navigationItem.setLeftBarButton(leftDrawerButton, animated: true)
        } // if
        
        // Header Image
        let imageView = UIImageView(image: UIImage(named: "eh440logoheader.png"))
        imageView.contentMode = .scaleAspectFit
        //imageView.layer.minificationFilter = kCAFilterTrilinear
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    } // viewDidLoad()
    
    @objc func leftDrawerButtonPress(sender: AnyObject?) {
        self.evo_drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

} // ContentViewController()

