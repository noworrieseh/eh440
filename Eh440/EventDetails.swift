//
//  EventDetails.swift
//  Eh440
//
//  Created by Family iMac on 2016-07-07.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//


import UIKit
import MapKit
import AVKit
import AVFoundation
import EventKit

class EventDetails: NSObject, NSCoding {
    
    // Data
    var id: Int = 0
    var title: String = ""
    var venue: String = ""
    var location: String = ""
    var tour: String = ""
    var type: String = ""
    var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var date: Date = Date()
    var rsvp: String = ""
    
    // NSCoding
    
    override init() {
        self.id = 0
        self.title = ""
        self.venue = ""
        self.location = ""
        self.tour = ""
        self.type = ""
        self.coordinates = CLLocationCoordinate2D()
        self.date = Date()
        self.rsvp = ""
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! Int
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.venue = aDecoder.decodeObject(forKey: "venue") as! String
        self.location = aDecoder.decodeObject(forKey: "location") as! String
        self.tour = aDecoder.decodeObject(forKey: "tour") as! String
        self.type = aDecoder.decodeObject(forKey: "type") as! String
        self.coordinates = CLLocationCoordinate2D(latitude: aDecoder.decodeObject(forKey: "coordinates-lat") as! Double,
                                                  longitude: aDecoder.decodeObject(forKey: "coordinates-long") as! Double)
        self.date = aDecoder.decodeObject(forKey: "date") as! Date
        self.rsvp = aDecoder.decodeObject(forKey: "rsvp") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.venue, forKey: "venue")
        aCoder.encode(self.location, forKey: "location")
        aCoder.encode(self.tour, forKey: "tour")
        aCoder.encode(self.type, forKey: "type")
        aCoder.encode(self.coordinates.latitude, forKey: "coordinates-lat")
        aCoder.encode(self.coordinates.longitude, forKey: "coordinates-long")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.rsvp, forKey: "rsvp")
    }

    // Data Management
    
    static let LAST = "EventDetails.last"
    static let FILE = "eventdata.plist"
    static var eventDetails: [EventDetails] = []
    static var path: String! = nil
    
    static func getDocs() -> String {
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        if dirs.count > 0 {
            return dirs[0]
        } else {
            return ""
        }
    }
    
    static func reset() {
        let fileManager = FileManager.default
//        let documentsDirectory = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
//        let resetPath = documentsDirectory.URLByAppendingPathComponent(FILE)!.path!
        let resetPath = getDocs().appendingFormat("/" + FILE)
        if fileManager.fileExists(atPath: resetPath) {
            do {
                try fileManager.removeItem(atPath: resetPath)
                UserDefaults.standard.removeObject(forKey: LAST)
            } catch {
                print("Problem reseting \(FILE)")
            } // do
        } // if
    } // reset()
    
    static func get() -> [EventDetails] {
        print("EventDetails.get()")
        
        // Initialize Data Store
        if path == nil {
            print("Init EventDetails")
            let fileManager = FileManager.default
//            let documentsDirectory = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
//            EventDetails.path = documentsDirectory.URLByAppendingPathComponent(FILE)!.path!
            EventDetails.path = getDocs().appendingFormat("/" + FILE)
            if !fileManager.fileExists(atPath: EventDetails.path) {
                if let bundle = Bundle.main.path(forResource: "eventdata", ofType: "plist") {
                    do {
                        print("Copy \(FILE)")
                        try fileManager.copyItem(atPath: bundle, toPath: EventDetails.path)
                    } catch {
                        print("Problem copying \(FILE)")
                    }
                } // if
            } // if
            
            // Load Data Store
            print("Load \(FILE)")
            do {
                
////            if let rawData = NSData(contentsOfFile: EventDetails.path) {
            if let rawData = try? Data(contentsOf: URL(fileURLWithPath: EventDetails.path)) {
                // do we get serialized data back from the attempted path?
                // if so, unarchive it into an AnyObject, and then convert to an array of AlbumDetails, if possible
////                let dataArray: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(rawData);
                let dataArray: Any? = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rawData);
                EventDetails.eventDetails = dataArray as? [EventDetails] ?? [];
            } else {
                reload()
            } // if
            } catch let ex {
                // Ignore for now
            }
            print("Done load \(FILE)")
            
        } // if
        
        // Check if reload is needed
        var reloadData = false
        let defaults = UserDefaults.standard
        if (defaults.object(forKey: LAST) != nil) {
            let last = defaults.integer(forKey: LAST)
            let curr = Int(NSDate().timeIntervalSince1970)
            let refresh = defaults.integer(forKey: "refresh_interval")
            print("Last \(last) Curr \(curr) Refresh \(refresh)")
            if curr > (last + refresh) {
                print("Refresh cache...")
                reloadData = true
            }
        } else {
            print("Refresh cache (new)...")
            reloadData = true
        } // if
        if reloadData {
////            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            DispatchQueue.global(qos: .userInitiated).async {
                EventDetails.reload()
            } // dispatch()
        } // if: reloadData
       
        print("Return EventDetails")
        return eventDetails
        
    }
    
    static func reload() {
        
        // Get EventDetails Data
        print("Reload eventdata")
        if let albumDetailData = DataModelManager.requestJSON(URLString: "https://api.bandsintown.com/artists/Eh440/events.json?api_version=2.0&app_id=MyTest&date=all") {
            
            // Parse
            EventDetails.eventDetails = EventDetails.parseData(nsdata: albumDetailData)
            let saveData = NSKeyedArchiver.archivedData(withRootObject: EventDetails.eventDetails);
            
            // Save
            print("Save \(FILE)")
            if saveData.writeToFile(EventDetails.path, atomically: true) {
                
                // Refresh date
                let defaults = UserDefaults.standard
                let curr = Int(NSDate().timeIntervalSince1970)
                print("Update \(LAST) \(curr)")
                defaults.set(curr, forKey: LAST)
                
            } // if
            print("Done save \(FILE)")
            
        } // if
        
    } // reload()
    
    static func parseData(nsdata: Data) -> [EventDetails] {
        
        var eventList : [EventDetails] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        let data:JSON = JSON(nsdata)
        var json = data
        
        print("COunt: \(json.count)")
        for index in 0...(json.count - 1) {
            
            //                print("Index: \(index)")
            
            let item = EventDetails()
            
            // Get Title
            item.title = json[index]["title"].string!
            
            // Get Venue
            var venueName = json[index]["venue"]["name"].string!
            if venueName.indexOfTest("(")! > 0 {
                let startIndex = venueName.indexOfTest("(")!
                let endIndex = venueName.indexOfTest(")")!
                item.tour = venueName.substring(location: startIndex, length: endIndex - startIndex)!
                venueName = venueName.substring(location: 0, length: startIndex)!
            } else if venueName.indexOfTest(" - ")! > 0 {
                let startIndex = venueName.indexOfTest(" - ")!
                item.tour = venueName.substringFromIndex(index: startIndex + 3)
                venueName = venueName.substringToIndex(index: startIndex)
            }
/*
            if let range = venueName.rangeOfString("(") {
                let tour = venueName.substringFromIndex(range.startIndex.advancedBy(1))
                let endIndex = tour.rangeOfString(")")
                item.tour = tour.substringToIndex(endIndex!.startIndex)
                venueName = venueName.substringToIndex(range.startIndex)
            }
            if let range2 = venueName.rangeOfString(" - ") {
                item.tour = venueName.substringFromIndex(range2.startIndex.advancedBy(3))
                venueName = venueName.substringToIndex(range2.startIndex)
            }
 */
            item.venue = venueName
            
            // Check for "min" in tour
            if item.tour.contains("min") {
                item.tour = ""
            }
            
            // Get Location
            item.location = json[index]["formatted_location"].string!
            /*                    let city = json[index]["venue"]["city"].string!
             var region = ""
             if let regionCheck = json[index]["venue"]["region"].string {
             region = regionCheck
             }
             
             let country = json[index]["venue"]["country"].string!
             item.location = "\(city), \(region), \(country)"
             */
            
            // Get Type
            if let check = json[index]["ticket_type"].string {
                item.type = check
            }
            
            // Get Date
            let dateStr = json[index]["datetime"].string
            item.date = formatter.date(from: dateStr!)!
            
            // Links
            item.rsvp = json[index]["facebook_rsvp_url"].string!
            
            // Co-ordinates
            let latitude = json[index]["venue"]["latitude"].number!
            let longitude = json[index]["venue"]["longitude"].number!
            item.coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees((Float(latitude))), longitude: CLLocationDegrees((Float(longitude))))
            
            print("Adding \(item.title)")
            eventList.append(item)
            
        } // for
        
        return eventList
        
    } // parseData()


} // EventDetails()
