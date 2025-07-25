//
//  MusicPlayerViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-07-11.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//
import UIKit
import MediaPlayer
import StoreKit

class MusicPlayerViewController: ContentViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var songs: [MPMediaItem]!
    var collection: MPMediaItemCollection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let query = MPMediaQuery.songsQuery()
        let artist = MPMediaPropertyPredicate(value: "Eh440", forProperty: MPMediaItemPropertyArtist)
        let album = MPMediaPropertyPredicate(value: "Turn Me Up", forProperty: MPMediaItemPropertyAlbumTitle)
        query.addFilterPredicate(artist)
        query.addFilterPredicate(album)
        songs = query.items
        collection = query.collections![0]
        print("Count \(collection.count)")
        
        /*
        let result = query.collections
        let count = result?.count
        let songs = result
        print("Count: \(count)")
      //  songs = result![0].items
        songs = result
        
       */
        
        self.tableView = UITableView(frame: self.view.frame, style: .Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //self.tableView.autoresizingMask = [ .FlexibleWidth, .FlexibleHeight ]
        self.tableView.separatorStyle = .None
        //        self.tableView.backgroundColor = UIColor.lightGrayColor()
        self.tableView.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        //        self.tableView.rowHeight = UITableViewAutomaticDimension
        //        self.tableView.estimatedRowHeight = 88
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
        
        self.view.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        
        
        self.tableView.reloadData()
        
    } // viewDidLoad()
    
    func contentSizeDidChange(size: String) {
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Get Count \(songs.count)")
        return songs.count
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 80.0
//    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        print("Get cell")
    //    var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell!
        
        cell.textLabel!.text = songs[indexPath.row].title
        
        print("Done cell")

        
        return cell
    }
    
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        /*
         print("Tapped accessory")
         let push = MapViewController()
         push.back = true
         push.location = CLLocationCoordinate2D(latitude: CLLocationDegrees((Float(self.json[indexPath.row]["venue"]["latitude"].number!))), longitude: CLLocationDegrees((Float(self.json[indexPath.row]["venue"]["longitude"].number!))))
         push.name = self.json[indexPath.row]["venue"]["name"].string!
         push.locationName = self.json[indexPath.row]["venue"]["city"].string! + ", " +
         self.json[indexPath.row]["venue"]["region"].string! + ", " +
         self.json[indexPath.row]["venue"]["country"].string!
         self.navigationController?.pushViewController(push, animated: true)
         */
    }
    
    var q : MPMediaItemCollection!

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        print("\(songs[indexPath.row].title)")

        let player = MPMusicPlayerController.applicationMusicPlayer()

        player.repeatMode = .None
        player.shuffleMode = .Off
        player.stop()
        
        var items:[MPMediaItem] = []
        for item in songs {
            items.append(item)
        }

        let asset = songs[indexPath.row].valueForProperty(MPMediaItemPropertyAssetURL)
        print("Asset: \(asset)")
   
        /*
      //  let id = songs[indexPath.row].persistentID
        //let albumid = songs[indexPath.row].albumPersistentID
   //     print("ID: \(id) Album: \(albumid)")
        MPMediaLibrary.requestAuthorization() { status in
            print("status \(status.rawValue)")
            MPMediaLibrary.defaultMediaLibrary().addItemWithProductID("875896753") { entities, error in
                print("check \(error) \(entities)")
                MPMusicPlayerController.systemMusicPlayer().setQueueWithStoreIDs(["875896753"])
                MPMusicPlayerController.systemMusicPlayer().play()
            }

        }
*/
/*
        MPMediaLibrary.defaultMediaLibrary().addItemWithProductID("875896753") { entities, error in
            print("check \(error) \(entities)")
                                    MPMusicPlayerController.systemMusicPlayer().setQueueWithStoreIDs(["875896753"])
                                    MPMusicPlayerController.systemMusicPlayer().play()
        }
  */
   /*
        SKCloudServiceController.requestAuthorization { status in
            print("1...\(status)")
            let cloudServiceController = SKCloudServiceController()
            cloudServiceController.requestCapabilitiesWithCompletionHandler { cloudServiceCapability, error in
                print("Cap: \(cloudServiceCapability) Error: \(error)")
//                if cloudServiceCapability.contains(.AddToCloudMusicLibrary) {
                    //let productID = self.songs[indexPath.row].valueForProperty(MPMediaItemPropertyPersistentID)?.string
                    let productID = "875896753";
                    print("ID: \(productID)")
                    MPMediaLibrary.defaultMediaLibrary().addItemWithProductID(productID) { entities, error in
                        print("In...\(error) \(entities)")
                        MPMusicPlayerController.systemMusicPlayer().setQueueWithStoreIDs([productID])
                        MPMusicPlayerController.systemMusicPlayer().play()
                    }
                    
//                }
            }
        }
 */
  /*
        q = MPMediaItemCollection(items: items)
        
        player.setQueueWithItemCollection(q)
        player.nowPlayingItem = songs[indexPath.row]
        player.currentPlaybackTime = songs[indexPath.row].bookmarkTime
        
        player.repeatMode = .All
        player.beginGeneratingPlaybackNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changed), name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: player)
        player.prepareToPlay()
        player.play()
        */
    }
    
    func changed(n:NSNotification) {

        let player = MPMusicPlayerController.applicationMusicPlayer()
        guard n.object === player else { return } // just playing safe
        guard let title = player.nowPlayingItem?.title else {return}
        let ix = player.indexOfNowPlayingItem
        guard ix != NSNotFound else {return}
        print("\(ix+1) of \(self.q.count): \(title)")
    }
 
}
