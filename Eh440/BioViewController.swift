//
//  BioViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-07-09.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit

class BioViewController: ContentViewController {
    
    var bio : [BioDetails] = []
    var extraImage: UIImage!
    var extraView: UIImageView!
    var countSwitch = 0
    
    var name = UILabel()
    var role = UILabel()
    var details = UITextView()
    var hometown = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load Data
        bio = BioDetails.get()
        
        // Setup Images
        var imageList: [UIView] = []
        var index = 0
        for item in bio {
            
            if item.name != "Mike Celia" && item.name != "Jake Stern" {
            // Get ImageView
            var imageView = navigationItem.titleView!
            if (item.name != "Eh440") {
//                let image = UIImage(named: "stripe\(item.image)")
                let image = UIImage(named: "split\(item.image)")
                let uiView = UIImageView(image: image)
                imageView = uiView
                imageView.contentMode = .scaleAspectFit
                imageList.append(imageView)
                if item.name == "Jake Stern" {
                    extraView = uiView
                }
            } // if
            
            // Setup Tap gesture
            let tap = UITapGestureRecognizer(target: self, action: #selector(BioViewController.handleBioSelect))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tap)
            imageView.tag = index
            index += 1
            } else {
                extraImage = UIImage(named: "stripe\(item.image)")
            }
        } // for
       
        // Build Strip
        let strip = UIStackView(arrangedSubviews: imageList)
        strip.axis = .horizontal
        strip.distribution = .fillEqually
        strip.alignment = .fill
        strip.spacing = 0
        strip.translatesAutoresizingMaskIntoConstraints = false
        
        name.translatesAutoresizingMaskIntoConstraints = false
        role.translatesAutoresizingMaskIntoConstraints = false
        hometown.translatesAutoresizingMaskIntoConstraints = false
        details.translatesAutoresizingMaskIntoConstraints = false
        
        // Build Info
        name.font = UIFont.boldSystemFont(ofSize: 24.0)
        role.font = UIFont.systemFont(ofSize: 15)
        hometown.font = UIFont.systemFont(ofSize: 15)
        details.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        details.font = UIFont.systemFont(ofSize: 15)
        details.isEditable = false
        
        // Calculate Height
//        let ratio = (UIScreen.mainScreen().bounds.width / 5) / 377
//        let newHeight = 1086 * ratio
        let ratio = (UIScreen.main.bounds.width / 5) / 593
        let newHeight = 1969 * ratio
        print("newheight: \(newHeight)")
        //newHeight = 216
        
        // Layout
        //let navheight = Int((navigationController?.navigationBar.frame.size.height)!)
        view.addSubview(strip)
        view.addSubview(name)
        view.addSubview(role)
        view.addSubview(hometown)
        view.addSubview(details)
        let viewsDict: [String: AnyObject] = ["top" : topLayoutGuide, "strip": strip, "name":name, "role": role, "hometown": hometown, "details": details]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[strip]|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[name]|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[role]|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[hometown]|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[details]|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[top][strip(\(newHeight))][name][role][hometown][details(>=50)]|", options: [], metrics: nil, views: viewsDict))

        self.view.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        
        displayBio(index: 0)
        
    } // viewDidLoad()
    
    @objc func handleBioSelect(sender: UIGestureRecognizer) {
        print("Received tap")
        if sender.view!.tag == 1 {
            countSwitch += 1
            if countSwitch > 20 {
                extraView.image = extraImage
                extraView.tag = 6
            }
        }
        displayBio(index: sender.view!.tag)
    } // handleBioSelect()
    
    func displayBio(index: Int) {
        let item = bio[index]
        print("Selected: \(index)")
        name.text = item.name
        role.text = item.role
        //details.text = item.facts.joinWithSeparator("\n")
        details.text = item.facts
        hometown.text = item.hometown
        view.setNeedsLayout()
        view.setNeedsDisplay()
    } // displayBio()
    
} // BioViewController()


