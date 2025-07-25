//
//  TourViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-06-28.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit
import EventKit

class TourViewController: ContentViewController, UITableViewDelegate, UITableViewDataSource {

    var upcomingEvent : [EventDetails] = []
    var pastEvent : [EventDetails] = []
    
    var tableView: UITableView!
    var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Map Button
        let backButton = UIBarButtonItem()
        backButton.title = "Tour Map"
        backButton.target = self
        backButton.action = #selector(TourViewController.rightButtonPress)
        self.navigationItem.setRightBarButton(backButton, animated: false)

        // Setup Segmented Control
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 110))
        newView.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        segmentedControl = UISegmentedControl(items: ["Upcoming", "Past"])
        segmentedControl.center = CGPoint(x: self.view.bounds.width / 2, y: 87)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.tintColor = UIColor.lightGray
        segmentedControl.addTarget(self, action: #selector(TourViewController.segmentedControlValueChanged), for: .valueChanged)
        newView.addSubview(segmentedControl)
        self.view.addSubview(newView)

        // Setup Table
        self.tableView = UITableView(frame: CGRect(x: 0, y: 110, width: self.view.bounds.width, height: self.view.bounds.height - 110), style: .plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "jsonCell")
        self.view.addSubview(self.tableView)

        // Setup View
        self.view.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)

        // Load Data
        upcomingEvent.removeAll()
        pastEvent.removeAll()
        let currDate = Date()
        for item in EventDetails.get() {
            if item.date.compare(currDate) == .orderedAscending {
                pastEvent.append(item)
            } else {
                upcomingEvent.append(item)
            }
        } // for: item
        upcomingEvent.sort(by: { $0.date.compare($1.date) == .orderedAscending })
        pastEvent.sort(by: { $0.date.compare($1.date) == .orderedDescending })

        self.tableView.reloadData()
        
    } // viewDidLoad()

    override func viewWillAppear(_ animated: Bool) {
        animateTable()
    } // viewWillAppear()

    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform.init(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransform.init(translationX: 0, y: 0);
                }, completion: nil)
            
            index += 1
        }
    }

    func contentSizeDidChange(size: String) {
        self.tableView.reloadData()
    }
    
    @objc func rightButtonPress(sender: AnyObject?) {
        print("Button pressed")
        
        self.title = "Tour"
        let controller = TourMapViewController()
        controller.back = true
        controller.upcoming = self.upcomingEvent
        controller.past = self.pastEvent
        self.navigationController?.pushViewController(controller, animated: true)

    } // rightButtonPress()

    @objc func segmentedControlValueChanged(sender: UISegmentedControl) {
        print("Segment: \(sender.selectedSegmentIndex)")
        self.tableView.reloadData()
    } // segmentedControlValueChanged
    
    func eventDetail(index: Int) -> EventDetails {
        if segmentedControl.selectedSegmentIndex == 0 {
            return upcomingEvent[index]
        } else {
            return pastEvent[index]
        }
    } // eventDetail()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return upcomingEvent.count
        if segmentedControl.selectedSegmentIndex == 0 {
            return upcomingEvent.count
        } else {
            return pastEvent.count
        }
    } // Table: Number Of Rows
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    } // Table: Row Height
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = CustomTableViewCell(style: .subtitle, reuseIdentifier: "jsonCell")
        
        let calendar = NSCalendar.current
        let formatter = DateFormatter()
        
        let item = eventDetail(index: indexPath.row)
        cell.customView.venue.text = item.venue
        cell.customView.location.text = item.location
        cell.customView.tour.text = item.tour
        cell.customView.dateView.day.text = String(calendar.component(.day, from: item.date))
        
        formatter.dateFormat = "MMM"
        cell.customView.dateView.month.text = formatter.string(from: item.date).uppercased()
 
        formatter.dateFormat = "EEEE"
        let formattedWeekDay = formatter.string(from: item.date)
////        let index = formattedWeekDay.startIndex.advancedBy(3)
////        cell.customView.dateView.dayofWeek.text = formattedWeekDay.substringToIndex(index).uppercaseString
        cell.customView.dateView.dayofWeek.text = formattedWeekDay.substringToIndex(index: 3).uppercased()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(TourViewController.handleLocationSelect))
        cell.customView.location.isUserInteractionEnabled = true
        cell.customView.location.addGestureRecognizer(tap)
        cell.customView.location.tag = indexPath.row
        
        cell.selectionStyle = .none
/*
        if item.type == "Free" {
            print("Free: \(item.venue)")
            cell.customView.free.enabled = true
            cell.customView.tickets.hidden = true;
        } else if item.type == "Tickets" {
            print("Tickets: \(item.venue)")
            cell.customView.free.hidden = true
            cell.customView.tickets.enabled = true
        } else {
            cell.customView.tickets.hidden = true
            cell.customView.free.hidden = true
        }
*/
        // Add Calendar tap (Only Upcoming)
        if segmentedControl.selectedSegmentIndex == 0 {
            let tap = UITapGestureRecognizer(target: self, action: #selector(TourViewController.handleSaveEvent))
            cell.customView.dateView.addGestureRecognizer(tap)
            cell.customView.dateView.tag = indexPath.row
        } // if
        
        return cell
    } // Table: Cell for row
    
    @objc func handleSaveEvent(sender: UIGestureRecognizer) {
        let item = eventDetail(index: sender.view!.tag)
        
        print("Date selected...\(item.location)")
        
        let alert = UIAlertController(title: "Add to Calendar", message: "Add performance to your calendar", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in

            let eventStore = EKEventStore()
            
            if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
                eventStore.requestAccess(to: .event, completion: {
                    granted, error in
                    self.createEvent(eventStore: eventStore, title: item.title, startDate: item.date, endDate: item.date)
                })
            } else {
                self.createEvent(eventStore: eventStore, title: item.title, startDate: item.date, endDate: item.date)
            }

        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
        }))
        
        present(alert, animated: true, completion: nil)
        
    } // handleSaveEvent()
    
    func createEvent(eventStore: EKEventStore, title: String, startDate: Date, endDate: Date) {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.save(event, span: .thisEvent)
        } catch {
            print("Save didn't work")
        }
    } // createEvent()
    
    @objc func handleLocationSelect(sender: UIGestureRecognizer) {
        print("handleLocationSelect")
        let item = eventDetail(index: sender.view!.tag)
        
        self.title = "Tour"
        let controller = EventMapViewController()
        controller.back = true
        controller.event = item
        
        self.navigationController?.pushViewController(controller, animated: true)

    } // handleLocationSelect()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        let item = eventDetail(index: indexPath.row)
    
        // Link to Bandsintown
////        UIApplication.shared.openURL(URL(string: item.rsvp)!)
        UIApplication.shared.openURL(URL(string: item.rsvp)!)

/*
        // Previous embedded browser link
        self.title = "Tour"
        let controller = WKViewController()
        controller.back = true
        controller.url = item.rsvp
        print(item.rsvp)

        self.navigationController?.pushViewController(controller, animated: true)
*/
    } // Table: Select Row
    

} // TourViewController()

class CustomTableViewCell: UITableViewCell {
    
    let customView = CustomView()

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

class CustomView: UIView {
    
    let dateView = DateView()
    let venue = UILabel()
    let location = UILabel()
    let tour = UILabel()
//    let tickets = UIButton(type: UIButtonType.RoundedRect)
//    let free = UIButton(type: UIButtonType.RoundedRect)
    let rvsp = UIMongolLabel()
    
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
        
        dateView.translatesAutoresizingMaskIntoConstraints = false
        venue.translatesAutoresizingMaskIntoConstraints = false
        tour.translatesAutoresizingMaskIntoConstraints = false
        location.translatesAutoresizingMaskIntoConstraints = false
//        tickets.translatesAutoresizingMaskIntoConstraints = false
//        free.translatesAutoresizingMaskIntoConstraints = false
        rvsp.translatesAutoresizingMaskIntoConstraints = false
        
        venue.font = UIFont(name: "HelveticaNeue", size: 15)
        tour.font = UIFont(name: "HelveticaNeue", size: 15)
        location.font = UIFont(name: "HelveticaNeue", size: 12)
        
        venue.isHighlighted = true
/*
        tickets.setTitle("Tickets", forState: UIControlState.Normal)
        tickets.layer.borderWidth = 1.0
        tickets.layer.masksToBounds = true
        tickets.layer.cornerRadius = 4
        tickets.clipsToBounds = true
        tickets.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        //tickets.backgroundColor = UIColor.blackColor()
        free.setTitle("Free", forState: UIControlState.Normal)
        free.layer.borderWidth = 1.0
        free.layer.masksToBounds = true
        free.layer.cornerRadius = 4
        free.clipsToBounds = true
        free.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
*/
        rvsp.text = "RVSP"
        rvsp.centerText = true
        rvsp.backgroundColor = UIColor(red: 176.0/255, green: 23.0/255, blue: 31.0/255, alpha: 1.0)

        self.backgroundColor = UIColor.white
        
        self.addSubview(dateView)
        self.addSubview(venue)
        self.addSubview(tour)
        self.addSubview(location)
//        self.addSubview(tickets)
//        self.addSubview(free)
        self.addSubview(rvsp)

        let viewsDict: [String:AnyObject] = [
            "date" : dateView,
            "venue" : venue,
            "tour" : tour,
            "location" : location,
//            "tickets" : tickets,
//            "free" : free,
            "rvsp" : rvsp,

        ]

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[date]-[venue]->=0-[rvsp(20)]|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[date]-[tour]->=0-[rvsp(20)]|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[date]-[location]->=0-[rvsp(20)]|", options: [], metrics: nil, views: viewsDict))
//        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-4-[date]-[tickets]-[free]", options: [], metrics: nil, views: viewsDict))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[rvsp]|", options: [], metrics: nil, views: viewsDict))

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[date]->=0-|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-4-[venue][tour][location]", options: [], metrics: nil, views: viewsDict))
//        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[tickets]-4-|", options: [], metrics: nil, views: viewsDict))
//        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[free]-4-|", options: [], metrics: nil, views: viewsDict))

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

class DateView: UIView {
    
    let dayofWeek = UILabel()
    let day = UILabel()
    let month = UILabel()
    var tableIndex = 0
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        
        dayofWeek.translatesAutoresizingMaskIntoConstraints = false
        day.translatesAutoresizingMaskIntoConstraints = false
        month.translatesAutoresizingMaskIntoConstraints = false
        
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
      
        self.addSubview(dayofWeek)
        self.addSubview(day)
        self.addSubview(month)
        
        let viewsDict = [
            "dayofweek" : dayofWeek,
            "day" : day,
            "month" : month
            ]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dayofweek(>=40)]|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[day(>=40)]|", options: [], metrics: nil, views: viewsDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[month(>=40)]|", options: [], metrics: nil, views: viewsDict))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dayofweek][day][month]-|", options: [], metrics: nil, views: viewsDict))
        
    }
    
    func setDate(date: Date) {
        
        let calendar = NSCalendar.current
        let formatter = DateFormatter()

        day.text = String(calendar.component(.day, from: date))

        formatter.dateFormat = "MMM"
        month.text = formatter.string(from: date).uppercased()
        
        formatter.dateFormat = "EEEE"
        let formattedWeekDay = formatter.string(from: date)
////        let index = formattedWeekDay.startIndex.advancedBy(3)
////        dayofWeek.text = formattedWeekDay.substringToIndex(index).uppercased()
        dayofWeek.text = formattedWeekDay.substringToIndex(index: 3).uppercased()

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
/*
class UIVerticalTextView: UIView {
    
    var textView = UITextView()
    let rotationView = UIView()
    
    var underlyingTextView: UITextView {
        get {
            return textView
        }
        set {
            textView = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func setup() {
        
        rotationView.backgroundColor = UIColor.redColor()
        textView.backgroundColor = UIColor.yellowColor()
        self.addSubview(rotationView)
        rotationView.addSubview(textView)
        
        // could also do this with auto layout constraints
        textView.frame = rotationView.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
 //       rotationView.transform = CGAffineTransformIdentity // *** key line ***
        
 //       rotationView.frame = CGRect(origin: CGPointZero, size: CGSize(width: self.bounds.height, height: self.bounds.width))
 //       rotationView.transform = translateRotateFlip()
    }
    
    func translateRotateFlip() -> CGAffineTransform {
        
        var transform = CGAffineTransformIdentity
        
        // translate to new center
        transform = CGAffineTransformTranslate(transform, (self.bounds.width / 2)-(self.bounds.height / 2), (self.bounds.height / 2)-(self.bounds.width / 2))
        // rotate counterclockwise around center
        transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
        // flip vertically
        transform = CGAffineTransformScale(transform, -1, 1)
        
        return transform
    }
}
*/
class UIMongolLabel: UIView {
    
    // TODO: make view resize to label length
    
    // MARK:- Unique to Label
    
    // ********* Unique to Label *********
    private let view = UILabel()
    private let rotationView = UIView()
    private var userInteractionEnabledForSubviews = true
    let mongolFontName = "HelveticaNeue"
    let defaultFontSize: CGFloat = 17
    
    @IBInspectable var text: String {
        get {
            return view.text ?? ""
        }
        set {
            view.text = newValue
            view.invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable var fontSize: CGFloat {
        get {
            if let font = view.font {
                return font.pointSize
            } else {
                return 0.0
            }
        }
        set {
            view.font = UIFont(name: mongolFontName, size: newValue)
            view.invalidateIntrinsicContentSize()
        }
    }
    
    @IBInspectable var textColor: UIColor {
        get {
            return view.textColor
        }
        set {
            view.textColor = newValue
        }
    }
    
    @IBInspectable var centerText: Bool {
        get {
            return view.textAlignment == NSTextAlignment.center
        }
        set {
            if newValue {
                view.textAlignment = NSTextAlignment.center
            }
        }
    }
    
    @IBInspectable var lines: Int {
        get {
            return view.numberOfLines
        }
        set {
            view.numberOfLines = newValue
        }
    }
    
    var textAlignment: NSTextAlignment {
        get {
            return view.textAlignment
        }
        set {
            view.textAlignment = newValue
        }
    }
    
    var font: UIFont {
        get {
            return view.font
        }
        set {
            view.font = newValue
        }
    }
    
    var adjustsFontSizeToFitWidth: Bool {
        get {
            return view.adjustsFontSizeToFitWidth
        }
        set {
            view.adjustsFontSizeToFitWidth = newValue
        }
    }
    
    var minimumScaleFactor: CGFloat {
        get {
            return view.minimumScaleFactor
        }
        set {
            view.minimumScaleFactor = newValue
        }
    }
    
////    override func intrinsicContentSize() -> CGSize {
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: view.frame.height, height: view.frame.width)
    }
    
    func setup() {
        
        self.addSubview(rotationView)
        rotationView.addSubview(view)
        
        // set font if user didn't specify size in IB
        if self.view.font.fontName != mongolFontName {
            view.font = UIFont(name: mongolFontName, size: defaultFontSize)
        }
        
    }
    
    
    // MARK:- General code for Mongol views
    
    // *******************************************
    // ****** General code for Mongol views ******
    // *******************************************
    
    // This method gets called if you create the view in the Interface Builder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // This method gets called if you create the view in code
    override init(frame: CGRect){
        super.init(frame: frame)
        self.setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
////        rotationView.transform = CGAffineTransformIdentity
        rotationView.transform = .identity
        rotationView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.bounds.height, height: self.bounds.width))
        rotationView.transform = translateRotateFlip()
        
        view.frame = rotationView.bounds
        
    }
    
    func translateRotateFlip() -> CGAffineTransform {
        
////        var transform = CGAffineTransformIdentity
        var transform = CGAffineTransform.identity
        
        // translate to new center
////        transform = CGAffineTransformTranslate(transform, (self.bounds.width / 2)-(self.bounds.height / 2), (self.bounds.height / 2)-(self.bounds.width / 2))
        transform = transform.translatedBy(x: (self.bounds.width / 2)-(self.bounds.height / 2), y: (self.bounds.height / 2)-(self.bounds.width / 2))
        // rotate counterclockwise around center
////        transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
        transform = transform.rotated(by: CGFloat(-M_PI_2))
        // flip vertically
        //transform = CGAffineTransformScale(transform, -1, 1)

        return transform
    }
    
}

