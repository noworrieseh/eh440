//
//  VideoDetails.swift
//  Eh440
//
//  Created by Family iMac on 2016-07-15.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit

class VideoDetails: NSObject, NSCoding {
    
    // Data
    var id: String = ""
    var title: String = ""
    var url: String = ""
    var image: UIImage = UIImage()
    
    // NSCoding
    
    override init() {
        self.id = ""
        self.title = ""
        self.url = ""
        self.image = UIImage()
        super.init()
    } // init()
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.url = aDecoder.decodeObject(forKey: "url") as! String
        self.image = aDecoder.decodeObject(forKey: "image") as! UIImage
    } // init()
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.image, forKey: "image")
    } // encodeWithCoder()

    
    // Data Management
    
    static let LAST = "VideoDetails.last"
    static let FILE = "videodata.plist"
    static var details: [String: VideoDetails] = [:]
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
    
    static func get() -> [String: VideoDetails] {
        print("VideoDetails.get()")
        
        // Initialize Data Store
        if path == nil {
            print("Init VideoDetails")
            let fileManager = FileManager.default
//            let documentsDirectory = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
//            path = documentsDirectory.URLByAppendingPathComponent(FILE)!.path!
            path = getDocs().appendingFormat("/" + FILE)
            if !fileManager.fileExists(atPath: path) {
                if let bundle = Bundle.main.path(forResource: "videodata", ofType: "plist") {
                    do {
                        print("Copy \(FILE)")
                        try fileManager.copyItem(atPath: bundle, toPath: path)
                    } catch {
                        print("Problem copying \(FILE)")
                    }
                } // if
            } // if
            
            // Load Data Store
            print("Load \(FILE)")
            do {
////if let rawData = NSData(contentsOfFile: path) {
                if let rawData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                // do we get serialized data back from the attempted path?
                // if so, unarchive it into an AnyObject, and then convert to an array of AlbumDetails, if possible
////                let dataArray: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(rawData);
                let dataArray: Any? = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rawData);
                details = dataArray as? [String:VideoDetails] ?? [:];
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
            DispatchQueue.global(qos: .userInitiated).async {
////            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                reload()
            } // dispatch()
        } // if: reloadData
        
//        reload()
        
        print("Return EventDetails")
        return details

    } // get()
    
    static func reload() {
        
        let youtubeKey = "AIzaSyAnyngdHduskWJ2PdEQTS9MLPq32vwTi78"
        let uploadsList = "UUMX4AkaiNEyaYNVjNlc0fww"

        var updated: [String: VideoDetails] = [:]
        
        // Get VideoDetails Data
        print("Reload videodata")
        if let detailData = DataModelManager.requestJSON(URLString: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(uploadsList)&key=\(youtubeKey)&maxResults=50") {
            
            // Parse
            updated = parseData(nsdata: detailData)
            
            // Add Fan Data
            let fanList = "PLBU3p57owcBrbVUGfVDkdkTPgzkK152vQ"
            if let fanData = DataModelManager.requestJSON(URLString: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(fanList)&key=\(youtubeKey)&maxResults=50") {
                updated = updated.mergedWith(otherDictionary: parseData(nsdata: fanData))
            } else {
                return
            } // if
            
            // Save
            details = updated
            print("Save \(FILE)")
            let saveData = NSKeyedArchiver.archivedData(withRootObject: details);
            if saveData.writeToFile(path, atomically: true) {
                
                // Refresh date
                let defaults = UserDefaults.standard
                let curr = Int(NSDate().timeIntervalSince1970)
                print("Update \(LAST) \(curr)")
                defaults.set(curr, forKey: LAST)
                
            } // if
            print("Done save \(FILE)")
            
        } // if
        
    } // reload()
    
    static func parseData(nsdata: Data) -> [String:VideoDetails] {
        
        var videoList : [String:VideoDetails] = [:]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        var data:JSON = try! JSON(data: nsdata)
        let json = data["items"]
        print("Count: \(json.count)")
        //self.officialVideo.removeAll()
        for index in 0...(json.count - 1) {
            
            print("OIndex: \(index)")
            let item = VideoDetails()
            var fulltitle = json[index]["snippet"]["title"].string!
            if fulltitle.indexOfTest("-")! > 0 {
                fulltitle = fulltitle.components(separatedBy: "-")[1].trim()
//                fulltitle = fulltitle.componentsSeparatedByString("-")[1].trim()
            }
            item.title = fulltitle
            let videoId = json[index]["snippet"]["resourceId"]["videoId"].string!
            item.id = videoId
            item.url = "https://youtu.be/\(videoId)"
            print("O URL: \(item.url)")
            
            // Get Thumbnail image
            let thmb = json[index]["snippet"]["thumbnails"]["medium"]["url"].string
            //thmb = thmb?.stringByReplacingOccurrencesOfString("hqdefault", withString: "mqdefault")
            let url = URL(string: thmb!)
            let data = try? Data(contentsOf: url!)
//print("Video: \(item.title)")
            item.image = UIImage(data: data!)!.cropLetterBox()!
            
//            videoList.append(item)
            videoList[item.id] = item

        } // for
        
/*
        print("COunt: \(json.count)")
        for index in 0...(json.count - 1) {
            
            //                print("Index: \(index)")
            
            let item = EventDetails()
            
            // Get Title
            item.title = json[index]["title"].string!
            
            // Get Venue
            var venueName = json[index]["venue"]["name"].string!
            if let range = venueName.rangeOfString("(") {
                var tour = venueName.substringFromIndex(range.startIndex.advancedBy(1))
                let endIndex = tour.rangeOfString(")")
                item.tour = tour.substringToIndex(endIndex!.startIndex)
                venueName = venueName.substringToIndex(range.startIndex)
            }
            if let range2 = venueName.rangeOfString(" - ") {
                item.tour = venueName.substringFromIndex(range2.startIndex.advancedBy(3))
                venueName = venueName.substringToIndex(range2.startIndex)
            }
            item.venue = venueName
            
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
            item.date = formatter.dateFromString(dateStr!)!
            
            // Links
            item.rsvp = json[index]["facebook_rsvp_url"].string!
            
            // Co-ordinates
            let latitude = json[index]["venue"]["latitude"].number!
            let longitude = json[index]["venue"]["longitude"].number!
            item.coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees((Float(latitude))), longitude: CLLocationDegrees((Float(longitude))))
            
            print("Adding \(item.title)")
            eventList.append(item)
            
        } // for
        */
        return videoList
        
    } // parseData()
 
    
 /*
    // Get Featured
    Alamofire.request(.GET, "http://www.eh440.com/video/?format=json-pretty").responseJSON { (responseData) -> Void in
    
    if((responseData.result.value) != nil) {
    print("Received data from eh440")
    let data = JSON(responseData.result.value!)
    let json = data["items"]
    print("Count: \(json.count)")
    for index in 0...(json.count - 1) {
    print("Index: \(index)")
    let item = VideoDetails()
    let fulltitle = json[index]["title"].string!
    
    if let range = fulltitle.rangeOfString(" - ") {
    item.title = fulltitle.substringFromIndex(range.endIndex)
    } else {
    item.title = fulltitle
    }
    item.url = json[index]["oembed"]["url"].string!
    print("URL: \(item.url)")
    
    // Get Thumbnail image
    var thmb = json[index]["oembed"]["thumbnailUrl"].string
    thmb = thmb?.stringByReplacingOccurrencesOfString("hqdefault", withString: "mqdefault")
    let url = NSURL(string: thmb!)
    let data = NSData(contentsOfURL: url!)
    item.image = UIImage(data: data!)!.cropLetterBox()!
    
    self.featuredVideo.append(item)
    
    }
    
    self.tableView.reloadData()
    }
    }
     
     list of all videos=https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=UUMX4AkaiNEyaYNVjNlc0fww&key=AIzaSyAnyngdHduskWJ2PdEQTS9MLPq32vwTi78&maxResults=50
    
    let youtubeKey = "AIzaSyAnyngdHduskWJ2PdEQTS9MLPq32vwTi78"
     
    eh440="UCMX4AkaiNEyaYNVjNlc0fww"
     
     uploads="UUMX4AkaiNEyaYNVjNlc0fww"
     
    let officialList = "PLC9oZSvXyl1IC-P5ivE6tKJGEsjt90dOj"
    let liveList = "PLC9oZSvXyl1IoFM8KT0IqM4U-GJIzigX6"
    
    request(.GET, "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(officialList)&key=\(youtubeKey)&maxResults=20").responseJSON { (responseData) -> Void in
    
    if((responseData.result.value) != nil) {
    print("Received data from official")
    let data = JSON(responseData.result.value!)
    let json = data["items"]
    print("Count: \(json.count)")
    self.officialVideo.removeAll()
    for index in 0...(json.count - 1) {
    print("OIndex: \(index)")
    let item = VideoDetails()
    let fulltitle = json[index]["snippet"]["title"].string!
    item.title = fulltitle.componentsSeparatedByString("-")[1].trim()
    let videoId = json[index]["snippet"]["resourceId"]["videoId"].string!
    item.url = "https://youtu.be/\(videoId)"
    print("O URL: \(item.url)")
    
    // Get Thumbnail image
    var thmb = json[index]["snippet"]["thumbnails"]["medium"]["url"].string
    //thmb = thmb?.stringByReplacingOccurrencesOfString("hqdefault", withString: "mqdefault")
    let url = NSURL(string: thmb!)
    let data = NSData(contentsOfURL: url!)
    item.image = UIImage(data: data!)!.cropLetterBox()!
    
    self.officialVideo.append(item)
    
    }
    
    self.tableView.reloadData()
    }
    }
    
    request(.GET, "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(liveList)&key=\(youtubeKey)&maxResults=20").responseJSON { (responseData) -> Void in
    
    if((responseData.result.value) != nil) {
    print("Received data from live")
    let data = JSON(responseData.result.value!)
    let json = data["items"]
    print("Count: \(json.count)")
    self.liveVideo.removeAll()
    for index in 0...(json.count - 1) {
    print("LIndex: \(index)")
    let item = VideoDetails()
    let fulltitle = json[index]["snippet"]["title"].string!
    item.title = fulltitle.componentsSeparatedByString("-")[1].trim()
    let videoId = json[index]["snippet"]["resourceId"]["videoId"].string!
    item.url = "https://youtu.be/\(videoId)"
    print("O URL: \(item.url)")
    
    // Get Thumbnail image
    var thmb = json[index]["snippet"]["thumbnails"]["medium"]["url"].string
    //thmb = thmb?.stringByReplacingOccurrencesOfString("hqdefault", withString: "mqdefault")
    let url = NSURL(string: thmb!)
    let data = NSData(contentsOfURL: url!)
    item.image = UIImage(data: data!)!.cropLetterBox()!
    
    self.liveVideo.append(item)
    
    }
    
    self.tableView.reloadData()
    }
    }
    
    
    
    //https://youtu.be/Jw-WID0xgws
    // https://www.youtube.com/watch?v=Jq7sNLR9YW8
    
    //https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=PLC9oZSvXyl1IC-P5ivE6tKJGEsjt90dOj&key=AIzaSyAaff5U1Fqp9mzp96iIh2zAZnjFnlQnGBE
    
    
    // YouTube API Key (ioskey): AIzaSyAnyngdHduskWJ2PdEQTS9MLPq32vwTi78
    // YouTube API Key (browserkey): AIzaSyAaff5U1Fqp9mzp96iIh2zAZnjFnlQnGBE
    // YouTube API Key (serverkey): AIzaSyCWPAq-WdA_cl8JWkIGbmlUmqlUL6VRcWM
    
    
    // Official: https://www.youtube.com/playlist?list=PLC9oZSvXyl1IC-P5ivE6tKJGEsjt90dOj
    // Live: https://www.youtube.com/playlist?list=PLC9oZSvXyl1IoFM8KT0IqM4U-GJIzigX6
    
*/
    
    
    
} // VideoDetails()
