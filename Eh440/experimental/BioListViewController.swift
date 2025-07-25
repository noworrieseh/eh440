//
//  BioListViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-07-09.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit
import MapKit
import AVKit
import AVFoundation


class BioListViewController: ContentViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var segmentedControl: UISegmentedControl!
    
    var featuredVideo : [VideoDetails] = []
    var officialVideo : [VideoDetails] = []
    var liveVideo : [VideoDetails] = []

    var bio : [BioDetails] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //bio = BioViewController.getData("bio")
        bio = BioDetails.get()
        
        self.tableView = UITableView(frame: self.view.bounds, style: .Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.autoresizingMask = [ .FlexibleWidth, .FlexibleHeight ]
        self.tableView.separatorStyle = .None
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 88
        self.tableView.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        self.tableView.registerClass(CustomBioTableViewCell.self, forCellReuseIdentifier: "jsonCell2")
        
        //self.view.backgroundColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        
        
        if bio.count > 0 {
            self.tableView.reloadData()
        }
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()

    }
    
    
    func contentSizeDidChange(size: String) {
        self.tableView.reloadData()
    }
    
    func segmentedControlValueChanged(sender: UISegmentedControl) {
        print("Segment: \(sender.selectedSegmentIndex)")
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bio.count - 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = CustomBioTableViewCell(style: .Subtitle, reuseIdentifier: "jsonCell2")
        print("Index: \(indexPath.row)")
        let item = bio[indexPath.row + 1]
        cell.customView.name.text = item.name
        cell.customView.role.text = item.role
        //cell.customView.details.text = item.facts.joinWithSeparator("\n")
        cell.customView.details.text = item.facts
        cell.customView.hometown.text = item.hometown
//        cell.customView.image.image = item.image
        let image = UIImage(named: "bio\(item.image)")
        cell.customView.image.image = image
        
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}

class CustomBioTableViewCell: UITableViewCell {
    
    let customView = CustomBioView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.layer.borderColor = UIColor.blackColor().CGColor
        customView.layer.borderWidth = 1.0
        
        //  contentView.backgroundColor = UIColor.lightGrayColor()
        contentView.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        contentView.addSubview(customView)
        let viewsDict = [
            "inner" : customView
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[inner]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-2-[inner]-|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

class CustomBioView: UIView {
    
    let image = UIImageView()
    let name = UILabel()
    let role = UILabel()
    let hometown = UILabel()
    let details = UITextView()
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let shadowPath = UIBezierPath(rect: bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeMake(0.0, 5.0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.CGPath
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        role.translatesAutoresizingMaskIntoConstraints = false
        hometown.translatesAutoresizingMaskIntoConstraints = false
        details.translatesAutoresizingMaskIntoConstraints = false
        
        name.font = UIFont.boldSystemFontOfSize(20)
        details.font = role.font
        details.scrollEnabled = false
        details.editable = false
        let title = UIStackView(arrangedSubviews: [name, role])
        title.axis = .Horizontal
        title.distribution = .Fill
        title.alignment = .Fill
        title.spacing = 2
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let info = UIStackView(arrangedSubviews: [title, hometown])
        info.axis = .Vertical
        info.distribution = .Fill
        info.alignment = .Fill
        info.spacing = 2
        info.translatesAutoresizingMaskIntoConstraints = false

        self.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(image)
        self.addSubview(info)
        self.addSubview(details)
        
        let viewsDict = [
            "info" : info,
            "image" : image,
            "details": details
            ]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-4-[image(50)]-4-[info]-4-|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-4-[details]-4-|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-4-[image(50)]-4-[details(>=100)]-4-|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-4-[info]-4-[details(>=100)]-4-|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
