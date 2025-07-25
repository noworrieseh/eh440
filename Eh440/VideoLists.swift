//
//  VideoLists.swift
//  Eh440
//
//  Created by Family iMac on 2016-07-15.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit

class VideoLists: NSObject, NSCoding {
    
    // Data
    var name: String?
    var list: [String]?
    
    init(n: String, l: [String]) {
        name = n
        list = l
    } // init()
    
    // NSCoding
    
    override init() {
        self.name = ""
        self.list = []
        super.init()
    } // init()
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.list = aDecoder.decodeObject(forKey: "list") as? [String]
    } // init()
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.list, forKey: "list")
    } // encodeWithCoder()

    // Data Management
    
    static let FEATURED = "featured"
    static let OFFICIAL = "official"
    static let LIVE = "live"
    static let FAN = "fan"
    
    static let LAST = "VideoLists.last"
    static let FILE = "videolist.plist"
    static var details: [String: VideoLists] = [:]
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
//        let fileManager = NSFileManager.defaultManager()
//        let documentsDirectory = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
//        let resetPath = documentsDirectory.URLByAppendingPathComponent(FILE)!.path!
        let fileManager = FileManager.default
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
    
    static func get() -> [String: VideoLists] {
        print("VideoLists.get()")
        
        // Initialize Data Store
        if path == nil {
            print("Init VideoLists")
            let fileManager = FileManager.default
            let path = getDocs().appendingFormat("/" + FILE)
            if !fileManager.fileExists(atPath: path) {
                if let bundle = Bundle.main.path(forResource: "videolist", ofType: "plist") {
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
////            if let rawData = NSData(contentsOfFile: path) {
                if let rawData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                // do we get serialized data back from the attempted path?
                // if so, unarchive it into an AnyObject, and then convert to an array of AlbumDetails, if possible
                let dataArray: Any? = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rawData);
                details = dataArray as? [String:VideoLists] ?? [:];
                print("Loaded \(details.count)")
            } else {
                reload()
            } // if
            } catch let ex {
                // Ignore for now
            }
/*
            if let rawData = NSData(contentsOfFile: path) {
                // do we get serialized data back from the attempted path?
                // if so, unarchive it into an AnyObject, and then convert to an array of AlbumDetails, if possible
                let dataArray: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(rawData);
                details = dataArray as? [String:VideoLists] ?? [:];
                print("Loaded \(details.count)")
            } else {
                reload()
            } // if
 */
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
        
        print("Return VideoLists")
        return details
        /*
        var detailMap: [String: VideoLists] = [:]
        for item in details {
            detailMap[item.name!] = item
        }
        return detailMap
 */
    } // get()
    
    static func reload() {
        
        let youtubeKey = "AIzaSyAnyngdHduskWJ2PdEQTS9MLPq32vwTi78"
        let featuredList = "PLBU3p57owcBqQhncA-sMzfi2Qlvgz9Fej"
        let officialList = "PLC9oZSvXyl1IC-P5ivE6tKJGEsjt90dOj"
        let liveList = "PLC9oZSvXyl1IoFM8KT0IqM4U-GJIzigX6"
        let fanList = "PLBU3p57owcBrbVUGfVDkdkTPgzkK152vQ"

//        var list: [VideoLists] = []
        var updated: [String: VideoLists] = [:]

        
        print("Reload videolist")
        
        // Get Featured References
        print("Load featured")
        if let detailData = DataModelManager.requestJSON(
                    URLString: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(featuredList)&key=\(youtubeKey)&maxResults=50") {
            
            if let parsedData = parseYouTube(name: FEATURED, nsdata: detailData) {
                updated[FEATURED] = parsedData
            } // if
            
        } // if
        
/*
        updated[FEATURED] = VideoLists(n: FEATURED, l: ["_XkJ5u9Dy6E", "uMqmw7t-k34", "15lky1lNKF4", "Jw-WID0xgws", "Jq7sNLR9YW8", "QUrz7g_hWDI"])
        // WINGS: _XkJ5u9Dy6E
        // I KNOW WHAT YOU DID LAST SUMMER: uMqmw7t-k34
        // GIBBERISH: 15lky1lNKF4
        // BANG: Jw-WID0xgws
        // DONT RUN AWAY: Jq7sNLR9YW8
        // DIED: QUrz7g_hWDI
        
        if let detailData = DataModelManager.requestJSON(.GET,
                    URLString: "http://www.eh440.com/video/?format=json-pretty") {
            
            if let parsedData = parseFeatured(FEATURED, nsdata: detailData) {
                updated[FEATURED] = parsedData
            } // if
            
        } // if
*/
        
        // Get Official References
        print("Load official")
        if let detailData = DataModelManager.requestJSON(
                    URLString: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(officialList)&key=\(youtubeKey)&maxResults=50") {
            
            if let parsedData = parseYouTube(name: OFFICIAL, nsdata: detailData) {
                updated[OFFICIAL] = parsedData
            } // if
            
        } // if
        
        
        // Get Live References
        print("Load live")
        if let detailData = DataModelManager.requestJSON(
                    URLString: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(liveList)&key=\(youtubeKey)&maxResults=50") {
            
            if let parsedData = parseYouTube(name: LIVE, nsdata: detailData) {
                updated[LIVE] = parsedData
            } // if
            
        } // if
      
        print("Load fan")
        if let detailData = DataModelManager.requestJSON(
                    URLString: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(fanList)&key=\(youtubeKey)&maxResults=50") {
            
            if let parsedData = parseYouTube(name: LIVE, nsdata: detailData) {
                updated[FAN] = parsedData
            } // if
            
        } // if

        details = updated
        let saveData = NSKeyedArchiver.archivedData(withRootObject: details);
        
        // Save
        print("Save \(FILE)")
////        if saveData.writeToFile(path, atomically: true) {
        do {
          try saveData.write(to: URL(fileURLWithPath: path))
                
            // Refresh date
            let defaults = UserDefaults.standard
            let curr = Int(NSDate().timeIntervalSince1970)
            print("Update \(LAST) \(curr)")
            defaults.set(curr, forKey: LAST)
        } catch {
        } // do
        print("Done save \(FILE)")
        
    } // reload()
    
    static func parseYouTube(name: String, nsdata: Data) -> VideoLists? {
        
        var list: [String] = []
        
        
        var data:JSON = JSON(nsdata)
        let json = data["items"]
        print("Count: \(json.count)")
        for index in 0...(json.count - 1) {
            
            print("OIndex: \(index)")
            
            let videoId = json[index]["snippet"]["resourceId"]["videoId"].string!
            print("Youtube ID \(videoId)")
            list.append(videoId)
            
        } // for
        
        return VideoLists(n: name, l: list)

    }
/*
    static func parseFeatured(name: String, nsdata: NSData) -> VideoLists? {
        
        // WINGS: _XkJ5u9Dy6E
        // I KNOW WHAT YOU DID LAST SUMMER: uMqmw7t-k34
        // GIBBERISH: 15lky1lNKF4
        // BANG: Jw-WID0xgws
        // DONT RUN AWAY: Jq7sNLR9YW8
        // DIED: QUrz7g_hWDI
        
        var list: [String] = []
        
        var data:JSON = JSON(data: nsdata)
        let json = data["items"]
        print("Count: \(json.count)")
        for index in 0...(json.count - 1) {
            
            print("OIndex: \(index)")
            
            let url = json[index]["sourceUrl"].string!
            var videoId = url.substringFromIndex(url.lastIndexOf("/")! + 1)
            if videoId.startsWith("watch?v=") {
                videoId = videoId.substringFromIndex(8)
            }
            print("Featured ID \(videoId)")
            list.append(videoId)
            
        } // for
        
        return VideoLists(n: name, l: list)
        
    }
*/
    
}
