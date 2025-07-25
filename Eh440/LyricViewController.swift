//
//  LyricViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-07-17.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit

class LyricViewController: ContentViewController {
    
    var track: SongDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Header
        let name = UILabel()
        let uppercase = track.trackName.uppercased()
        name.text = "\(track.trackNum)/\(uppercase)"
        name.numberOfLines = 0
        name.font = UIFont(name: "Arial-BoldMT", size: 22)
        name.sizeToFit()
        let credits = UILabel()
        credits.text = track.credits
        credits.numberOfLines = 0
        credits.font = UIFont(name: "Arial-ItalicMT", size: 12)
        credits.addBorderBottom(size: 1.0, color: UIColor.black)
        credits.sizeToFit()
        view.addSubview(name)
        view.addSubview(credits)
        
        // Lyrics Section
        let textView = UITextView()
        textView.text = track.lyrics
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(textView)
        self.view.backgroundColor = UIColor.white

        // AutoLayout
        name.translatesAutoresizingMaskIntoConstraints = false
        credits.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewsDict: [String: AnyObject] = [
            "top" : topLayoutGuide,
            "track" : name,
            "credits" : credits,
            "lyrics" : textView
        ]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[track]-4-|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[credits]-4-|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-4-[lyrics]-4-|", options: [], metrics: nil, views: viewsDict))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[top]-[track(20)][credits(20)]-[lyrics(>=50)]|", options: [], metrics: nil, views: viewsDict))
        
    } // viewDidLoad()
    
    
} // TrackViewController()
