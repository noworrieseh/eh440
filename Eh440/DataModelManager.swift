//
//  DataModelManager.swift
//  Eh440
//
//  Created by Family iMac on 2016-07-14.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import Foundation
import Alamofire

class DataModelManager {
    
/*
    // Need to rethink this idea to centralize the data management.
     
    var albumDetails: [AlbumDetails]! = nil
    var albumPath: String! = nil
//    var eventDetails: [EventDetails]! = nil
    
    init() {
        
        // load existing high scores or set up an empty array
        let fileManager = NSFileManager.defaultManager()
        let documentsDirectory = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!

        self.albumPath = documentsDirectory.URLByAppendingPathComponent("albumdata.plist").path!
//        let eventPath = documentsDirectory.URLByAppendingPathComponent("eventdata.plist").path!

        // check if albumdata exists
        if !fileManager.fileExistsAtPath(albumPath) {
            if let bundle = NSBundle.mainBundle().pathForResource("albumdata", ofType: "plist") {
                do {
                    try fileManager.copyItemAtPath(bundle, toPath: albumPath)
                } catch {
                    print("Problem copying albumdata.plist")
                }
            } // if
        } // if
/*
        if !fileManager.fileExistsAtPath(eventPath) {
            if let bundle = NSBundle.mainBundle().pathForResource("eventdata", ofType: "plist") {
                do {
                    try fileManager.copyItemAtPath(bundle, toPath: albumPath)
                } catch {
                    print("Problem copying eventdata.plist")
                }
            } // if
        } // if
*/
        
        print("Load albumdata.plist")
        if let rawData = NSData(contentsOfFile: albumPath) {
            // do we get serialized data back from the attempted path?
            // if so, unarchive it into an AnyObject, and then convert to an array of AlbumDetails, if possible
            let dataArray: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(rawData);
            self.albumDetails = dataArray as? [AlbumDetails] ?? [];
        } else {
            reload()
        } // if
        print("Done load albumdata.plist")
/*
        if let rawData = NSData(contentsOfFile: eventPath) {
            // do we get serialized data back from the attempted path?
            // if so, unarchive it into an AnyObject, and then convert to an array of HighScores, if possible
            let dataArray: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(rawData);
            self.eventDetails = dataArray as? [EventDetails] ?? [];
        } // if
*/
    } // init()
    
    func reload() {
/*
        // Get AlbumDetail Data
        print("Reload albumdata")
        if let albumDetailData = requestJSON(.GET, URLString: "https://itunes.apple.com/lookup?id=875896750&entity=album") {
            albumDetails = AlbumDetails.parseData(albumDetailData)
            save()
        } // if
   */     
        
        
        
    } // reload()
    
    func save() {
        
        let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.albumDetails);
        print("Save albumdata.plist")
        saveData.writeToFile(albumPath, atomically: true);
        print("Done save albumdata.plist")

        
    } // save()
*/
////    static func requestJSON(_ method: Alamofire.Method, URLString: URLConvertible) -> Data? {
    static func requestJSON(URLString: URLConvertible) -> Data? {
        var finishFlag = 0
        var data: Data? = nil
        
////        Alamofire.request(method, URLString).responseJSON { (responseData) -> Void in
        Alamofire.request(URLString).responseJSON { responseData in
            if responseData.result.value != nil {
                data = responseData.data!
                finishFlag = 1
            } else {
                finishFlag = -1
            }
        } // response

        
        while finishFlag == 0 {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date.distantFuture)
        }
        
        return data
    }
    
    
    
} // DataModelManager
