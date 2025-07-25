//
//  SongViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-07-16.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit
import StoreKit
import MediaPlayer

class SongViewController: ContentViewController, UITableViewDelegate, UITableViewDataSource, SKStoreProductViewControllerDelegate {
    
    var tableView: UITableView!
    var album: AlbumDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = album.albumName
        
        // Setup Album View
        let artwork = UIImageView()
        artwork.image = album.artwork
        artwork.layer.borderColor = UIColor.black.cgColor
        artwork.layer.borderWidth = 1.0
        artwork.layer.minificationFilter = kCAFilterTrilinear

        let albumTitle = UILabel()
        albumTitle.font = UIFont.systemFont(ofSize: 25)
        //albumTitle.font = UIFont(name: "Verdana", size: 25)
        albumTitle.text = album.albumName
        print("TEXT: \(album.albumName)")
        
        let genre = UILabel()
        let year = album.releaseDate.year
        genre.text = "\(album.genre) • \(year)"
        genre.font = UIFont.systemFont(ofSize: 12)
        
//        let spotify = UIImageView(image: UIImage(named: "Spotify_Icon_RGB_Green.png"))
        let spotify = UIImageView(image: UIImage(named: "spotify.png"))
        spotify.layer.minificationFilter = kCAFilterTrilinear
        if album.spotifyURI.characters.count > 0 {
            spotify.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(SongViewController.handleSelect))
            spotify.addGestureRecognizer(tap)
            spotify.tag = 0
        } else {
            spotify.isHidden = true
        }

        let itunes = UIImageView(image: UIImage(named: "iTunes-Store-icon.png"))
        itunes.layer.minificationFilter = kCAFilterTrilinear
        itunes.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(SongViewController.handleiTunesSelect))
        itunes.addGestureRecognizer(tap)
        itunes.tag = 0
        
        let soundcloud = UIImageView(image: UIImage(named: "soundcloud.png"))
        soundcloud.layer.minificationFilter = kCAFilterTrilinear
        soundcloud.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(SongViewController.handleSoundCloudSelect))
        soundcloud.addGestureRecognizer(tap2)
        itunes.tag = 0
//        if album.albumName != "Turn Me Up" {
            soundcloud.isHidden = true
//        } // if

        view.addSubview(artwork)
        view.addSubview(albumTitle)
        view.addSubview(genre)
        view.addSubview(spotify)
        view.addSubview(itunes)
        view.addSubview(soundcloud)
       
        
        // Setup Tableview Control
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 50
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = UIColor.white
        self.tableView.register(TrackTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.addBorderTop(size: 1.0, color: UIColor.black)
        view.addSubview(self.tableView)
      
        // Setup View
        self.view.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        
        // Layout View
        artwork.translatesAutoresizingMaskIntoConstraints = false
        albumTitle.translatesAutoresizingMaskIntoConstraints = false
        genre.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        spotify.translatesAutoresizingMaskIntoConstraints = false
        itunes.translatesAutoresizingMaskIntoConstraints = false
        soundcloud.translatesAutoresizingMaskIntoConstraints = false

        let viewsDict: [String: AnyObject] = [
            "artwork" : artwork,
            "title" : albumTitle,
            "genre" : genre,
            "spotify" : spotify,
            "itunes" : itunes,
            "soundcloud": soundcloud,
            "top" : topLayoutGuide,
            "tracks" : tableView
        ]

        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[artwork(100)]-[title]-|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[artwork(100)]-[genre]-|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[artwork(100)]->=10-[soundcloud(25)]-16-[spotify(25)]-16-[itunes(25)]-|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tracks]|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[top]-[artwork(100)]-[tracks]-|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[top]-[title]-4-[genre]->=10-[spotify(25)]-[tracks]-|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[top]-[title]-4-[genre]->=10-[itunes(25)]-[tracks]-|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[top]-[title]-4-[genre]->=10-[soundcloud(25)]-[tracks]-|", options: [], metrics: nil, views: viewsDict))

        self.tableView.reloadData()
        
    } // viewDidLoad()
    
    @objc func handleSelect(sender: UIGestureRecognizer) {
        print("handleSelect")
        UIApplication.shared.openURL(URL(string: album.spotifyURI)!)

    } // handleSelect

    @objc func handleiTunesSelect(sender: UIGestureRecognizer) {
        print("handleiTunesSelect")
        openStoreProductWithiTunesItemIdentifier(identifier: album.id)
    } // handleSelect
    
    @objc func handleSoundCloudSelect(sender: UIGestureRecognizer) {
        print("handleSoundCloudSelect")
        let ctrl = WKViewController()
        ctrl.url = "https://soundcloud.com/eh440/sets/turn-me-up-album-tracks"
        ctrl.back = true
        
        // Navigate to Controller
        self.navigationController?.pushViewController(ctrl, animated: true)

    } // handleSoundCloudSelect()
    
    func openStoreProductWithiTunesItemIdentifier(identifier: Int) {
        print("openStore")
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        print("loadparam")
        storeViewController.loadProduct(withParameters: parameters) { [weak self] (loaded, error) -> Void in
            if loaded {
                print("Loaded...")
                // Parent class of self is UIViewContorller
                //   self?.presentViewController(storeViewController, animated: true, completion: nil)
            } else {
                print("Not loaded...")
            }
        }
        self.present(storeViewController, animated: true, completion: nil)
        print("doneparam")
    }
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.layoutSubviews()
    }

    func contentSizeDidChange(size: String) {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tracks = album.tracks
        return tracks.count
    } // tableView: numberOfRowsInSection()
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TrackTableViewCell! = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! TrackTableViewCell?
        let tracks = album.tracks
        let item = tracks[indexPath.row]
        
        // Set Track Length
        let (hour, min, sec) = secondsToHoursMinutesSeconds(seconds: item.trackLength/1000)
        var formatted = ""
        if hour > 0 {
            formatted = "\(hour):" + String(format: "%02d", min) + ":" + String(format: "%02d", sec)
        } else if min > 0 {
            formatted = "\(min):" + String(format: "%02d", sec)
        } else {
            formatted = "\(sec)"
        } // if
        cell.num.text = "\(item.trackNum)"
        cell.name.text = item.trackName
        cell.time.text = formatted
        cell.name.sizeToFit()
        
        cell.selectionStyle = .none
        
        // Add Lyric Gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(SongViewController.handleLyricsSelect))
        cell.lyrics.addGestureRecognizer(tap)
        cell.lyrics.tag = indexPath.row
        
        return cell
    } // tableView: cellForRowAtIndexPath()

    @objc func handleLyricsSelect(sender: UIGestureRecognizer) {
        print("handleLyricsSelect")

        let trackList = album.tracks
        let track = trackList[sender.view!.tag]

        if track.lyrics == "" {
            return
        } // if

        // Setup Lyric Controller
        let ctrl = LyricViewController()
        ctrl.back = true
        ctrl.track = track
        self.title = album.albumName
        
        // Navigate to Controller
        self.navigationController?.pushViewController(ctrl, animated: true)

    } // handleSelect

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        let trackList = album.tracks
        let track = trackList[indexPath.row]
   
        // Request access to media library
//        MPMediaLibrary.requestAuthorization() { status in
//            print("status \(status.rawValue)")

            // Build Query for song
            let query = MPMediaQuery.songs()
            let artistQ = MPMediaPropertyPredicate(value: "Eh440", forProperty: MPMediaItemPropertyArtist)
            let albumQ = MPMediaPropertyPredicate(value: self.album.albumName, forProperty: MPMediaItemPropertyAlbumTitle)
            let songQ = MPMediaPropertyPredicate(value: track.trackName, forProperty: MPMediaItemPropertyTitle)
            query.addFilterPredicate(artistQ)
            query.addFilterPredicate(albumQ)
            query.addFilterPredicate(songQ)
            if let songs = query.items {
                if songs.count > 0 {
                    let player = MPMusicPlayerController.applicationMusicPlayer
                    if player.nowPlayingItem?.title == songs[0].title {
                        print("Stop playing")
                        player.stop()
                    } else {
                        print("Play \(track.trackName)")
                        player.setQueue(with: query)
                        player.repeatMode = .none
                        player.prepareToPlay()
                        player.play()
                    } // if
                } // if
 
            } // if
 
//        } // Media authorization
    } // didSelectRow()
    
} // SongViewController()

class TrackTableViewCell: UITableViewCell {
    
    let num = UILabel()
    let name = UILabel()
    let time = UILabel()
    let lyrics = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        num.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        lyrics.translatesAutoresizingMaskIntoConstraints = false
        
        num.textAlignment = .center
        time.textAlignment = .right
        name.numberOfLines = 0
        name.lineBreakMode = .byWordWrapping
        lyrics.image = UIImage(named: "document-icon.png")
        lyrics.isUserInteractionEnabled = true
        
        num.font = UIFont.systemFont(ofSize: 15)
        name.font = UIFont.boldSystemFont(ofSize: 20)
        time.font = UIFont.systemFont(ofSize: 15)

        contentView.addSubview(num)
        contentView.addSubview(name)
        contentView.addSubview(time)
        contentView.addSubview(lyrics)
        
        let viewsDict: [String:AnyObject] = [
            "num" : num,
            "name" : name,
            "time" : time,
            "lyrics" : lyrics
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[num(30)]-[name(>=50)][time(>=40)]-8-[lyrics(30)]-4-|", options: [.alignAllCenterY], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[num]|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[name]|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[time]|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|->=4-[lyrics(30)]->=4-|", options: [.alignAllCenterY], metrics: nil, views: viewsDict))
        
    } // init()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
} // TrackTableViewCell()

