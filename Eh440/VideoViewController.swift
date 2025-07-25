//
//  VideoViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-06-29.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit

class VideoViewController: ContentViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var segmentedControl: UISegmentedControl!
    
    var segmentToList: [Int: String] = [0: VideoLists.FEATURED, 1: VideoLists.OFFICIAL, 2: VideoLists.LIVE, 3: VideoLists.FAN]
    var videoMap: [String: VideoDetails] = [:]
    var listMap: [String: VideoLists] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Segmented Control
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 110))
        newView.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        segmentedControl = UISegmentedControl(items: ["Featured", "Official", "Live", "Fan"])
        segmentedControl.center = CGPoint(x: self.view.bounds.width / 2, y: 87)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.tintColor = UIColor.lightGray
        segmentedControl.addTarget(self, action: #selector(VideoViewController.segmentedControlValueChanged), for: .valueChanged)
        newView.addSubview(segmentedControl)
        self.view.addSubview(newView)
        self.title = "Featured"

        // Setup Tableview Control
        self.tableView = UITableView(frame: CGRect(x: 0, y: 110, width: self.view.bounds.width, height: self.view.bounds.height - 110), style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        //self.tableView.autoresizingMask = [ .FlexibleWidth, .FlexibleHeight ]
        self.tableView.estimatedRowHeight = 40
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        self.tableView.register(CustomVideoTableViewCell.self, forCellReuseIdentifier: "jsonCell2")
        
        self.view.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        
        // Get Data
        videoMap = VideoDetails.get()
        listMap = VideoLists.get()
        print("CHECK: \(listMap.count)")
        
        self.tableView.reloadData()
        
    } // viewDidLoad()
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.layoutSubviews()
    }
    func contentSizeDidChange(size: String) {
        self.tableView.reloadData()
    }
    
    @objc func segmentedControlValueChanged(sender: UISegmentedControl) {
        print("Segment: \(sender.selectedSegmentIndex)")
        self.title = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        self.tableView.reloadData()
    }
    
    func videoItem(index: Int) -> VideoDetails {
        if let videoList = listMap[segmentToList[segmentedControl.selectedSegmentIndex]!] {
            if let array = videoList.list {
                let videoId = array[index]
                if let video = videoMap[videoId] {
                    return video
                } else {
                    print("Unknown Video ID: \(videoId)")
                    return VideoDetails()
                }
                //return videoMap[videoId]!
            } // if: array
        } // if: videoList
        
        print("Unknown videoItem i=\(index) seg=\(segmentedControl.selectedSegmentIndex)")
        return VideoDetails()
        
    } // videoItem()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let videoList = listMap[segmentToList[segmentedControl.selectedSegmentIndex]!] {
            if let array = videoList.list {
                return array.count
            } // if: array
        } // if: videoList
        return 0
    } // tableView: numberOfRowsInSection()

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomVideoTableViewCell! = self.tableView.dequeueReusableCell(withIdentifier: "jsonCell2") as! CustomVideoTableViewCell?
        let item = videoItem(index: indexPath.row)
    
        cell.customView.title.text = item.title
    //    cell.customView.image.setScaledImage(item.image)
        cell.customView.image.image = item.image
        cell.selectionStyle = .none

        return cell
    } // tableView: cellForRowAtIndexPath()
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")

        let url = videoItem(index: indexPath.row).url
        print("URL \(url)")
        
        let center = YouTubeViewController()
        center.url = url
        center.back = true
        self.navigationController?.pushViewController(center, animated: true)

    }

} // VideoViewController()

class CustomVideoTableViewCell: UITableViewCell {
    
    let customView = CustomVideoView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.layer.borderColor = UIColor.black.cgColor
        customView.layer.borderWidth = 1.0
        
        //  contentView.backgroundColor = UIColor.lightGrayColor()
        contentView.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        contentView.addSubview(customView)
        let viewsDict = [
            "inner" : customView
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[inner]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[inner]-|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

class CustomVideoView: UIView {
    
    let title = UILabel()
    let image = UIImageView()
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let shadowPath = UIBezierPath(rect: bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        
        title.font = UIFont(name: "HelveticaNeue", size: 15)
 //       image.contentMode = .ScaleAspectFit
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(image)
        self.addSubview(title)
        
        let viewsDict: [String:AnyObject] = [
            "title" : title,
            "image" : image,
            
            ]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[image]-4-|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[title]-4-|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[image]-4-[title]-4-|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

/*
class AspectFitImageView: UIImageView {
    
    var aspectRatio: NSLayoutConstraint?
    
    override func awakeFromNib() {
        updateAspectRatioWithImage(self.image!)
    }
    
    func setScaledImage(i: UIImage) {
        image = i
        updateAspectRatioWithImage(image!)
    }
    
    func updateAspectRatioWithImage(image: UIImage) {
        if let ar = aspectRatio {
//        if (aspectRatio != nil) {
            print("Remove...")
            removeConstraint(ar)
        }
        let aspectRatioValue = image.size.height / image.size.width;
        aspectRatio = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: aspectRatioValue, constant: 0)
        addConstraint(self.aspectRatio!)
        
    }
    
}
*/
