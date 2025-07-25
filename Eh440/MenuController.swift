//
//  MenuController.swift
//  Eh440
//
//  Created by Family iMac on 2016-06-25.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit
import AVFoundation

class SocialLinks {
    init(i: UIImage, u: String) {
        image = i
        url = u
    } // init
    var image = UIImage()
    var url = ""
} // SocialLinks()

class MenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var items: [String] = ["LOGO", "Tour", "Music", "Video", "Shop", "Bio", "Contacts", "LINKS"]
    var links: [SocialLinks] = []
    var logoImage: UIImage!
    var menuFont: UIFont!
    var cellHeight: Int!
    var iconSpacing: Int!
    
    var player:AVAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup social links
        links.append(SocialLinks(i: UIImage(named: "facebook.jpeg")!, u: "https://facebook.com/Eh440/"))
        links.append(SocialLinks(i: UIImage(named: "twitter.jpeg")!, u: "https://twitter.com/eh440"))
        links.append(SocialLinks(i: UIImage(named: "youtube.jpeg")!, u: "http://www.youtube.com/channel/UCMX4AkaiNEyaYNVjNlc0fww"))
        links.append(SocialLinks(i: UIImage(named: "instagram.png")!, u: "https://www.instagram.com/eh440/"))
//        links.append(SocialLinks(i: UIImage(named: "blog.png")!, u: "BLOG"))
        
        // Setup easter egg
        let audioPath = Bundle.main.path(forResource: "beat", ofType: "mp3")
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        } catch {
            print("Unable to load audio file")
        }

        // Setup View
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.white
        self.evo_drawerController?.showsShadows = true
      
        // Setup Table
        self.tableView = UITableView(frame: self.view.bounds, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.tableView.separatorStyle = .none
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Check screen size
        let height = UIScreen.main.bounds.size.height
        print("Height \(height)")
        if height < 568 {
            menuFont = UIFont(name:"Avenir", size:30)
            cellHeight = 55
        } else if height == 568 {
            print("TEST")
            menuFont = UIFont(name:"Avenir", size:35)
            cellHeight = 65
        } else {
            menuFont = UIFont(name:"Avenir", size:40)
            cellHeight = 80
        } // if
        
        let width = UIScreen.main.bounds.size.width
        print("Width \(width)")
        if width <= 320 {
            iconSpacing = 15
        } else {
            iconSpacing = 20
        } // if
        
    } // viewDidLoad()
    
////    override func preferredStatusBarStyle() -> UIStatusBarStyle {
////        return .lightContent
////    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Easter Egg:  Respond to shake

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    } // viewDidAppear()
    override var canBecomeFirstResponder: Bool { return true }
////    override func canBecomeFirstResponder() -> Bool {
////        return true
////    } // canBecomeFirstResponder()
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent!) {
        if(event.subtype == UIEventSubtype.motionShake) {
            print("Shake!!!")
            player.play()
        }
    } // motionEnded()
 
    
/*
    private func contentSizeDidChangeNotification(notification: NSNotification) {
        if let userInfo: NSDictionary = notification.userInfo {
            self.contentSizeDidChange(userInfo[UIContentSizeCategoryNewValueKey] as! String)
        }
    }
*/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // See https://github.com/sascha/DrawerController/issues/12
        self.navigationController?.view.setNeedsLayout()
        
////        self.tableView.reloadSections(IndexSet(indexesIn: NSRange(location: 0, length: self.tableView.numberOfSections - 1)), with: .None)
        self.tableView.reloadSections(IndexSet(integersIn: 0...self.tableView.numberOfSections - 1), with: .none)
    }
/*
    func contentSizeDidChange(size: String)
        self.tableView.reloadData()
    }
*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    } // Table: numberOfRows

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = self.tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?
        
        switch (items[indexPath.row]) {
            case "LOGO":
                cell.imageView?.image = UIImage(named: "eh440logo10.png")!
//                cell.imageView?.image = logoImage
                cell.selectionStyle = .none
                break;
            case "LINKS":
                cell = UITableViewCell()
                cell.selectionStyle = .none
            
                var list: [UIView] = []
                var index = 0
                for item in links {
                    let imageView = UIImageView(image: item.image)
                    imageView.layer.minificationFilter = kCAFilterTrilinear
                    imageView.isUserInteractionEnabled = true
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    cell.contentView.addSubview(imageView)
                
                    // Setup Tap gesture
                    let tap = UITapGestureRecognizer(target: self, action: #selector(MenuController.handleSocialSelect))
                    imageView.isUserInteractionEnabled = true
                    imageView.addGestureRecognizer(tap)
                    imageView.tag = index
                
                    list.append(imageView)
                    index += 1
                }
            
//                let viewsDict = ["fb": list[0], "tw": list[1], "yt": list[2], "ig": list[3], "b": list[4]]
                let viewsDict = ["fb": list[0], "tw": list[1], "yt": list[2], "ig": list[3]]
                let metrics: [String:Any] = ["icon": 30, "space": iconSpacing]
//                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[fb(icon)]-space-[tw(icon)]-space-[yt(icon)]-space-[ig(icon)]-space-[b(icon)]->=0-|", options: [], metrics: metrics, views: viewsDict))
                cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[fb(icon)]-space-[tw(icon)]-space-[yt(icon)]-space-[ig(icon)]->=0-|", options: [], metrics: metrics, views: viewsDict))
                cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[fb(icon)]->=0-|", options: [], metrics: metrics, views: viewsDict))
                cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[tw(icon)]->=0-|", options: [], metrics: metrics, views: viewsDict))
                cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[yt(icon)]->=0-|", options: [], metrics: metrics, views: viewsDict))
                cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[ig(icon)]->=0-|", options: [], metrics: metrics, views: viewsDict))
//                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[b(icon)]->=0-|", options: [], metrics: metrics, views: viewsDict))

            default:
                cell.textLabel?.text = self.items[indexPath.row]
//                cell.textLabel?.adjustsFontSizeToFitWidth = true
//                cell.textLabel?.font = UIFont(name:"Avenir", size:40)
                cell.textLabel!.font = menuFont
            
        }

        return cell
    } // Table: Cell at row
    
    @objc func handleSocialSelect(sender: UIGestureRecognizer) {
        print("Received tap")
        let item = links[sender.view!.tag]
        print("Selected: \(sender.view!.tag)")
        if (item.url == "BLOG") {
            let ctrl = BlogViewController()
            let nav = UINavigationController(rootViewController: ctrl)
            self.evo_drawerController?.setCenter(nav, withCloseAnimation: true, completion: nil)
        } else {
            let center = WKViewController()
            center.url = item.url
            let nav = UINavigationController(rootViewController: center)
            self.evo_drawerController?.setCenter(nav, withCloseAnimation: true, completion: nil)
        } // if
    } // handleSocialSelect()

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        if let ctrl = getController(index: indexPath.row) {
            let nav = UINavigationController(rootViewController: ctrl)
            self.evo_drawerController?.setCenter(nav, withCloseAnimation: true, completion: nil)
        } // if
    } // Table: SelectRow
    
    func getController(index: Int) -> UIViewController? {
        switch (index) {
            case 0: return HomeViewController()
            case 1: return TourViewController()
            case 2: return MusicViewController()
            case 3: return VideoViewController()
            case 4: let ctrl = WKViewController(); ctrl.url = "http://www.eh440.com/shop/"; return ctrl
//            case 5: let ctrl = WKViewController(); ctrl.url = "http://www.eh440.com/gallery/"; return ctrl
            case 5: return BioViewController()
//            case 6: let ctrl = WKViewController(); ctrl.url = "http://www.eh440.com/contact/"; return ctrl
            case 6: let ctrl = WKViewController(); ctrl.url = "http://www.eh440.com/contact/?format=main-content"; return ctrl
            default: return nil
        }
    } // getController()
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    } // Table: Header height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return CGFloat(cellHeight + 15)
        }
        return CGFloat(cellHeight)
    } // Table: Row Height
  
} // MenuController()
