//
//  BlogViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-07-18.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit
import MapKit
import AVKit
import AVFoundation

class BlogDetails {
    var date: NSDate!
    var title: String!
    var url: String!
    var body: String!
} // BlogDetails

class BlogViewController: ContentViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var blog: [BlogDetails] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Blog"
        
        self.tableView = UITableView(frame: self.view.bounds, style: .Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.autoresizingMask = [ .FlexibleWidth, .FlexibleHeight ]
        self.tableView.separatorStyle = .None
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 88
        self.tableView.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        self.tableView.registerClass(BlogTableViewCell.self, forCellReuseIdentifier: "cell")
        
        //self.view.backgroundColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        
        if let detailData = DataModelManager.requestJSON(.GET,
                URLString: "http://www.eh440.com/blog/?format=json-pretty") {
            
            blog.removeAll()
            var data:JSON = JSON(data: detailData)
            let json = data["items"]
            print("Count: \(json.count)")
            for index in 0...(json.count - 1) {
                
                print("OIndex: \(index)")
                
                let item = BlogDetails()
                item.title = json[index]["title"].string!
                item.title = item.title.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
                item.url = "http://eh440.com" + json[index]["fullUrl"].string!
                item.body = json[index]["body"].string!
                if let epoch = json[index]["publishOn"].int {
                    item.date = NSDate(timeIntervalSince1970: Double(epoch/1000))
                }
                
                blog.append(item)
                
            } // for
        }// if
        
        if blog.count > 0 {
            self.tableView.reloadData()
        }
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        
    }
    
    func contentSizeDidChange(size: String) {
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blog.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = BlogTableViewCell(style: .Subtitle, reuseIdentifier: "cell")
        print("Index: \(indexPath.row)")
        
        let item = blog[indexPath.row]
        cell.customView.blogTitle.text = item.title
        cell.customView.blogDate.setDate(item.date)
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
        
        let item = blog[indexPath.row]
        print("URL: \(item.url)")
        let ctrl = WKViewController()
        ctrl.url = item.url
        //ctrl.html = item.body
        ctrl.back = true
        
        // Navigate to Controller
        self.navigationController?.pushViewController(ctrl, animated: true)

    }
    
}

class BlogTableViewCell: UITableViewCell {
    
    let customView = BlogView()
    
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

class BlogView: UIView {
    
    var blogTitle: UILabel!
    var blogDate: DateYearView!
    
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
        
        blogTitle = UILabel()
         blogDate = DateYearView()
        
        blogTitle.translatesAutoresizingMaskIntoConstraints = false
        blogDate.translatesAutoresizingMaskIntoConstraints = false
        blogTitle.font = UIFont.systemFontOfSize(15)
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(blogTitle)
        self.addSubview(blogDate)
        
        let viewsDict = [
            "date" : blogDate,
            "blog" : blogTitle
        ]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-4-[date]-[blog(>=20)]-4-|", options: [], metrics: nil, views: viewsDict))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[date]->=0-|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[blog]-|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

class DateYearView: UIView {
    
    let dayofWeek = UILabel()
    let day = UILabel()
    let month = UILabel()
    let year = UIMongolLabel()
    var tableIndex = 0
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        dayofWeek.translatesAutoresizingMaskIntoConstraints = false
        day.translatesAutoresizingMaskIntoConstraints = false
        month.translatesAutoresizingMaskIntoConstraints = false
        year.translatesAutoresizingMaskIntoConstraints = false
        
        dayofWeek.text = "SUN"
        dayofWeek.font = UIFont(name: "HelveticaNeue", size: 8)
        dayofWeek.backgroundColor = UIColor.redColor()
        dayofWeek.textColor = UIColor.whiteColor()
        dayofWeek.textAlignment = .Center
        
        day.text = "4"
        day.font = UIFont(name: "HelveticaNeue", size: 20)
        day.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        day.textAlignment = .Center
        
        month.text = "SEP"
        month.font = UIFont(name: "HelveticaNeue", size: 8)
        month.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.9)
        month.textAlignment = .Center
        
        year.text = "YEAR"
        year.centerText = true
        //year.backgroundColor = UIColor(red: 176.0/255, green: 23.0/255, blue: 31.0/255, alpha: 1.0)
        year.backgroundColor = UIColor.lightGrayColor()
        year.font = UIFont.systemFontOfSize(10)

        self.addSubview(dayofWeek)
        self.addSubview(day)
        self.addSubview(month)
        self.addSubview(year)
        
        let viewsDict = [
            "year" : year,
            "dayofweek" : dayofWeek,
            "day" : day,
            "month" : month
        ]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[year(11)][dayofweek(>=40)]|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[year(11)][day(>=40)]|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[year(11)][month(>=40)]|", options: [], metrics: nil, views: viewsDict))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[dayofweek][day][month]-|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[year]-|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    func setDate(date: NSDate) {
        
        let calendar = NSCalendar.currentCalendar()
        let formatter = NSDateFormatter()
        
        day.text = String(calendar.component(.Day, fromDate: date))
        year.text = String(calendar.component(.Year, fromDate: date))
        
        formatter.dateFormat = "MMM"
        month.text = formatter.stringFromDate(date).uppercaseString
        
        formatter.dateFormat = "EEEE"
        let formattedWeekDay = formatter.stringFromDate(date)
        let index = formattedWeekDay.startIndex.advancedBy(3)
        
        dayofWeek.text = formattedWeekDay.substringToIndex(index).uppercaseString
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

