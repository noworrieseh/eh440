//
//  AlbumDetails.swift
//  Eh440
//
//  Created by Family iMac on 2016-07-07.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

// Spotify
//  "Turn Me Up": spotify:album:14A9XrlCeGhantBFa9loUZ


import UIKit

class SongDetails: NSObject, NSCoding {
    
    // Data
    var id: Int = 0
    var trackName: String = ""
    var trackNum: Int = 0
    var trackLength: Int = 0
    var credits: String = ""
    var lyrics: String = ""
    
    // NSCoding
    
    override init() {
        self.id = 0
        self.trackName = ""
        self.trackNum = 0
        self.trackLength = 0
        self.credits = ""
        self.lyrics = ""
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! Int
        self.trackName = aDecoder.decodeObject(forKey: "trackName") as! String
        self.trackNum = aDecoder.decodeObject(forKey: "trackNum") as! Int
        self.trackLength = aDecoder.decodeObject(forKey: "trackLength") as! Int
        self.credits = aDecoder.decodeObject(forKey: "credits") as! String
        self.lyrics = aDecoder.decodeObject(forKey: "lyrics") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.trackName, forKey: "trackName")
        aCoder.encode(self.trackNum, forKey: "trackNum")
        aCoder.encode(self.trackLength, forKey: "trackLength")
        aCoder.encode(self.credits, forKey: "credits")
        aCoder.encode(self.lyrics, forKey: "lyrics")
    }

}


class AlbumDetails: NSObject, NSCoding {
    
    // Data
    var id: Int = 0
    var albumName: String = ""
    var artworkURL: String = ""
    var artwork: UIImage = UIImage()
    var releaseDate: Date = Date()
    var genre: String = ""
    var spotifyURI: String = ""
    var tracks: [SongDetails] = []
    
    // NSCoding
    
    override init() {
        self.id = 0
        self.albumName = ""
        self.artworkURL = ""
        self.artwork = UIImage()
        self.releaseDate = Date()
        self.genre = ""
        self.spotifyURI = ""
        self.tracks = []
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! Int
        self.albumName = aDecoder.decodeObject(forKey: "albumName") as! String
        self.artworkURL = aDecoder.decodeObject(forKey: "artworkURL") as! String
        self.artwork = aDecoder.decodeObject(forKey: "artwork") as! UIImage
        self.releaseDate = aDecoder.decodeObject(forKey: "releaseDate") as! Date
        self.genre = aDecoder.decodeObject(forKey: "genre") as! String
        self.spotifyURI = aDecoder.decodeObject(forKey: "spotifyURI") as! String
        self.tracks = aDecoder.decodeObject(forKey: "tracks") as! [SongDetails]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.albumName, forKey: "albumName")
        aCoder.encode(self.artworkURL, forKey: "artworkURL")
        aCoder.encode(self.artwork, forKey: "artwork")
        aCoder.encode(self.releaseDate, forKey: "releaseDate")
        aCoder.encode(self.genre, forKey: "genre")
        aCoder.encode(self.spotifyURI, forKey: "spotifyURI")
        aCoder.encode(self.tracks, forKey: "tracks")
    }
    
    // Data Management
    
    static let LAST = "AlbumDetails.last"
    static let FILE = "albumdata.plist"
    static var albumDetails: [AlbumDetails] = []
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
////        let documentsDirectory = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
////        let resetPath = documentsDirectory.URLByAppendingPathComponent(FILE)!.path!
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
    
    static func get() -> [AlbumDetails] {
        print("AlbumDetails.get()")
    
        // Initialize Data Store
        if path == nil {
            print("Init AlbumDetails")
            let fileManager = FileManager.default
//            let documentsDirectory = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
//            AlbumDetails.path = documentsDirectory.URLByAppendingPathComponent(FILE)!.path!
            AlbumDetails.path = getDocs().appendingFormat("/" + FILE)
            if !fileManager.fileExists(atPath: AlbumDetails.path) {
                if let bundle = Bundle.main.path(forResource: "albumdata", ofType: "plist") {
                    do {
                        print("Copy \(FILE)")
                        try fileManager.copyItem(atPath: bundle, toPath: AlbumDetails.path)
                    } catch {
                        print("Problem copying \(FILE)")
                    }
                } // if
            } // if
            
            //reload()

            // Load Data Store
            print("Load \(FILE)")
            do {
////                if let rawData = NSData(contentsOfFile: AlbumDetails.path) {
                if let rawData = try? Data(contentsOf: URL(fileURLWithPath: AlbumDetails.path)) {
                    // do we get serialized data back from the attempted path?
                    // if so, unarchive it into an AnyObject, and then convert to an array of AlbumDetails, if possible
                    let dataArray: Any? = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rawData);
                    AlbumDetails.albumDetails = dataArray as? [AlbumDetails] ?? [];

                } else {
                    reload()
                } // if
            } catch let ex {
                // Ignore for now
            }
/*
            if let rawData = NSData(contentsOfFile: AlbumDetails.path) {
                // do we get serialized data back from the attempted path?
                // if so, unarchive it into an AnyObject, and then convert to an array of AlbumDetails, if possible
                let dataArray: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(rawData);
                AlbumDetails.albumDetails = dataArray as? [AlbumDetails] ?? [];
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
            } // if
        } else {
            print("Refresh cache (new)...")
            reloadData = true
        } // if
        if reloadData {
////            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            DispatchQueue.global(qos: .userInitiated).async {
                AlbumDetails.reload()
            } // dispatch()
        } // if: reloadData

        print("Return AlbumDetails")
        return albumDetails
        
    }
    
    static var lyrics: [String:Any] = [:]
    
    static func reload() {
        
        // Get Spotify Mappings
        var spotify: [String:String] = [:]
        if let spotifyAlbums = DataModelManager.requestJSON(URLString: "https://api.spotify.com/v1/artists/0VQ2ejs5ftn3V22evrUwcL/albums") {
            spotify = parseSpotify(nsdata: spotifyAlbums)
        } // if
        
        // Get Lyrics
////        let lyricsPath = Bundle.main.path(forResource: "Lyrics", ofType: "plist")
////        lyrics = NSDictionary(contentsOfFile: lyricsPath!)!
       // print("Lyrics: \(lyrics)")
        if let url = Bundle.main.url(forResource:"Lyrics", withExtension: "plist"),
            let dict = NSDictionary(contentsOf: url) as? [String:Any] {
            lyrics = dict
        }
        
        // Get AlbumDetail Data
        print("Reload albumdata")
        if let albumDetailData = DataModelManager.requestJSON(URLString: "https://itunes.apple.com/lookup?id=875896750&entity=album") {
            
            // Parse Album Data
            let details = parseData(nsdata: albumDetailData)
            
            for item in details {
                
                // Get Track Information
                if let songDetailData = DataModelManager.requestJSON(URLString: "https://itunes.apple.com/lookup?id=\(item.id)&entity=song") {
                    item.tracks = parseSongData(nsdata: songDetailData)
                } // if
                
                // Get Spotify Information
                if let uri = spotify[item.albumName] {
                    item.spotifyURI = uri
                } // if
                
            } // for
            
            
            albumDetails = details
        
            // Save
            print("Save \(FILE)")
            let saveData = NSKeyedArchiver.archivedData(withRootObject: AlbumDetails.albumDetails);
            if saveData.writeToFile(AlbumDetails.path, atomically: true) {
                
                // Refresh date
                let defaults = UserDefaults.standard
                let curr = Int(NSDate().timeIntervalSince1970)
                print("Update \(LAST) \(curr)")
                defaults.set(curr, forKey: LAST)
            
            } // if
            print("Done save \(FILE)")

        } // if
        
        lyrics = [:]
        
    } // reload()
    
    static func parseData(nsdata: Data) -> [AlbumDetails] {
        
        var albumList : [AlbumDetails] = []
        
        var data:JSON = JSON(nsdata)
        var json = data["results"]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        print("COunt: \(json.count)")
        for index in 0...(json.count - 1) {
            
            print("Index: \(index)")
            if json[index]["wrapperType"].string == "collection" {
                
                let item = AlbumDetails()
                item.id = json[index]["collectionId"].int!
                item.albumName = json[index]["collectionName"].string!
                item.genre = json[index]["primaryGenreName"].string!
                
                // Get Artwork URL
                let thmb = json[index]["artworkUrl100"].string!
////                item.artworkURL = thmb.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
                item.artworkURL = thmb.replacingOccurrences(of: "100x100", with: "600x600")

                // Get Release Date
                let dateStr = json[index]["releaseDate"].string
                item.releaseDate = formatter.date(from: dateStr!)!
                
                // Get Image
////                let url = NSURL(string: item.artworkURL)
////                if let imageData = NSData(contentsOfURL: url!) {
                let url = URL(string: item.artworkURL)
                if let imageData = try? Data(contentsOf: url!) {
                    item.artwork = UIImage(data: imageData)!
                }
                
                print("Adding \(item.albumName)")
                albumList.append(item)
                
            } // if
        } // for
        
        return albumList
        
    } // parseData()
    
    static func parseSongData(nsdata: Data) -> [SongDetails] {
        
        var songList : [SongDetails] = []
        
        var data:JSON = JSON(nsdata)
        var json = data["results"]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        print("COunt: \(json.count)")
        for index in 0...(json.count - 1) {
            
            print("Index: \(index)")
            if json[index]["wrapperType"].string == "track" {
                
                let item = SongDetails()
                item.id = json[index]["collectionId"].int!
                item.trackName = json[index]["trackName"].string!
                item.trackNum = json[index]["trackNumber"].int!
                item.trackLength = json[index]["trackTimeMillis"].int!

                if let lyricData = lyrics[item.trackName.lowercased()] {
                    let dict: [String:String] = lyricData as! [String:String]
                    item.credits = dict["credits"]!
                    item.lyrics = dict["lyrics"]!
                }
                
                print("Adding \(item.trackName)")
                songList.append(item)
                
            } // if
        } // for
        
        return songList
        
    } // parseSongData()

    static func parseSpotify(nsdata: Data) -> [String:String] {
        
        var spotify: [String:String] = [:]

        var data:JSON = JSON(nsdata)
        var json = data["items"]
        
        print("COunt: \(json.count)")
        for index in 0...(json.count - 1) {
            
            if let name = json[index]["name"].string {
                if let uri = json[index]["uri"].string {
                    spotify[name] = uri
                }
            }

        } // for
        
        return spotify
        
    } // parseSpotify()
    

    
    

    
    // Add Time Check
    /*
     request(.GET, "https://itunes.apple.com/lookup?id=875896750&entity=album").responseJSON { (responseData) -> Void in
     if((responseData.result.value) != nil) {
     print("Received iTunes webdata")
     let result = AlbumDetails.saveWebData(responseData.data!)
     print("Save Result: \(result)")
     self.albumList = AlbumDetails.loadFile()
     self.collectionView.reloadData()
     } else {
     print("Problem with iTunes webdata")
     } // if
     
     } // request
     // Spotify:https://api.spotify.com/v1/artists/0VQ2ejs5ftn3V22evrUwcL/albums
     */
    
    
    
} // AlbumDetails()
