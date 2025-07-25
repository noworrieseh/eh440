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
        
        self.tableView = UITableView(frame: self.view.bounds, style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 88
        self.tableView.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        self.tableView.register(BlogTableViewCell.self, forCellReuseIdentifier: "cell")
        
        //self.view.backgroundColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        
        if let detailData = DataModelManager.requestJSON(
                URLString: "http://www.eh440.com/blog/?format=json-pretty") {
            
            blog.removeAll()
            var data:JSON = try! JSON(data: detailData)
            let json = data["items"]
            print("Count: \(json.count)")
            for index in 0...(json.count - 1) {
                
                print("OIndex: \(index)")
                
                let item = BlogDetails()
                item.title = json[index]["title"].string!
//                item.title = item.title.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
                item.title = item.title.replacingOccurrences(of: "&amp;", with: "&")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blog.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BlogTableViewCell(style: .subtitle, reuseIdentifier: "cell")
        print("Index: \(indexPath.row)")
        
        let item = blog[indexPath.row]
        cell.customView.blogTitle.text = item.title
        cell.customView.blogDate.setDate(date: item.date)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

class BlogView: UIView {
    
    var blogTitle: UILabel!
    var blogDate: DateYearView!
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        let shadowPath = UIBezierPath(rect: bounds)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        blogTitle = UILabel()
         blogDate = DateYearView()
        
        blogTitle.translatesAutoresizingMaskIntoConstraints = false
        blogDate.translatesAutoresizingMaskIntoConstraints = false
        blogTitle.font = UIFont.systemFont(ofSize: 15)
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(blogTitle)
        self.addSubview(blogDate)
        
        let viewsDict : [String:Any] = [
            "date" : blogDate,
            "blog" : blogTitle
        ]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[date]-[blog(>=20)]-4-|", options: [], metrics: nil, views: viewsDict))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[date]->=0-|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[blog]-|", options: [], metrics: nil, views: viewsDict))
        
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
        dayofWeek.backgroundColor = UIColor.red
        dayofWeek.textColor = UIColor.white
        dayofWeek.textAlignment = .center
        
        day.text = "4"
        day.font = UIFont(name: "HelveticaNeue", size: 20)
        day.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        day.textAlignment = .center
        
        month.text = "SEP"
        month.font = UIFont(name: "HelveticaNeue", size: 8)
        month.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.9)
        month.textAlignment = .center
        
        year.text = "YEAR"
        year.centerText = true
        //year.backgroundColor = UIColor(red: 176.0/255, green: 23.0/255, blue: 31.0/255, alpha: 1.0)
        year.backgroundColor = UIColor.lightGray
        year.font = UIFont.systemFont(ofSize: 10)

        self.addSubview(dayofWeek)
        self.addSubview(day)
        self.addSubview(month)
        self.addSubview(year)
        
        let viewsDict : [String:Any] = [
            "year" : year,
            "dayofweek" : dayofWeek,
            "day" : day,
            "month" : month
        ]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[year(11)][dayofweek(>=40)]|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[year(11)][day(>=40)]|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[year(11)][month(>=40)]|", options: [], metrics: nil, views: viewsDict))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dayofweek][day][month]-|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[year]-|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    func setDate(date: NSDate) {
        
        let calendar = NSCalendar.current
        let formatter = DateFormatter()
        
        day.text = String(calendar.component(.day, from: date as Date))
        year.text = String(calendar.component(.year, from: date as Date))
        
        formatter.dateFormat = "MMM"
        month.text = formatter.string(from: date as Date).uppercased()
        
        formatter.dateFormat = "EEEE"
        let formattedWeekDay = formatter.string(from: date as Date)
////        let index = formattedWeekDay.startIndex.advancedBy(3)
////        dayofWeek.text = formattedWeekDay.substringToIndex(index).uppercaseString
        dayofWeek.text = formattedWeekDay.substringToIndex(index: 3)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

