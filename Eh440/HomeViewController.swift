//
//  HomeViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-06-25.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var homeImage: UIImageView!
    var banner: UIBanner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make NavBar invisible
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // Add NavButton
////        let leftDrawerButton = DrawerBarButtonItem(target: self, action: #selector(HomeViewController.leftDrawerButtonPress(_:)))
        let leftDrawerButton = DrawerBarButtonItem(target: self, action: #selector(leftDrawerButtonPress))
        self.navigationItem.setLeftBarButton(leftDrawerButton, animated: true)

        // Image
        homeImage = UIImageView(frame: self.view.frame)
        homeImage.image = UIImage(named: launchImageName())
        self.view.addSubview(homeImage)

        // Banner
        let height = UIScreen.main.bounds.size.height
        if height == 480 {
            banner = UIBanner(frame: CGRect(x: self.view.bounds.width - 150, y: 400, width: 200, height: 60))
            banner.bannerLabel.font = UIFont.systemFont(ofSize: 14)
        } else if height == 568 {
            banner = UIBanner(frame: CGRect(x: self.view.bounds.width - 150, y: 450, width: 200, height: 60))
            banner.bannerLabel.font = UIFont.systemFont(ofSize: 14)
        } else {
            banner = UIBanner(frame: CGRect(x: self.view.bounds.width - 200, y: 500, width: 200, height: 80))
        } // if
        banner.center.x += view.bounds.width
        self.view.addSubview(banner)

    } // viewDidLoad()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.banner.center.x -= self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)

    } // viewDidAppear()
    
    @objc func leftDrawerButtonPress(sender: AnyObject?) {
        self.evo_drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)
    } // leftDrawerButtonPress()
    
    func launchImageName() -> String {
        switch (UI_USER_INTERFACE_IDIOM(), UIScreen.main.scale, UIScreen.main.bounds.size.height) {
        case (.phone, _, 480): return "LaunchImage-700@2x.png"
        case (.phone, _, 568): return "LaunchImage-700-568h@2x.png"
        case (.phone, _, 667): return "LaunchImage-800-667h@2x.png"
        case (.phone, _, 736): return "LaunchImage-800-Portrait-736h@3x.png"
        case (.pad, 1, _): return "LaunchImage-700-Portrait~ipad.png"
        case (.pad, 2, _): return "LaunchImage-700-Portrait@2x~ipad.png"
        default: return "LaunchImage"
        }
    } // launchImageName()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

} // HomeViewController()

class UIBanner: UIView {
    
    var bannerLabel: UILabel!
    
    override init (frame : CGRect) {
        super.init(frame : frame)

        // Setup Banner Label
        bannerLabel = UILabel()
        bannerLabel.textColor = UIColor.white
        bannerLabel.font = UIFont.systemFont(ofSize: 20)
        bannerLabel.translatesAutoresizingMaskIntoConstraints = false
        bannerLabel.numberOfLines = 0
//        bannerLabel.text = "BOSS LEVEL\nOfficial Release\nSept 2, 2016"
        bannerLabel.text = "BOSS LEVEL\nAvailable now"
        addSubview(bannerLabel)
        
        // Setup View
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        self.backgroundColor = UIColor.purple

        // Setup Layout
        let viewsDict = [
            "banner" : bannerLabel
             ]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[banner(>=50)]-4-|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[banner]-4-|", options: [], metrics: nil, views: viewsDict))
        
    } // init()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
} // UIBanner()
