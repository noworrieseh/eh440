//
//  MusicViewController.swift
//  Eh440
//
//  Created by Family iMac on 2016-06-30.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit

class MusicViewController: ContentViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate  {
    
    var collectionView: UICollectionView!
    var albumList : [AlbumDetails] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        let width = UIScreen.main.bounds.size.width
        flowLayout.itemSize = CGSize(width: width/2, height: width/2)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        //collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.backgroundColor = UIColor(red: 230.0/255, green: 230.0/255, blue: 230.0/255, alpha: 1.0)
        collectionView.register(RDCell.self, forCellWithReuseIdentifier: "collectionCell")
        self.view.addSubview(collectionView)
 
        // Load Data
        albumList = AlbumDetails.get()
        
    } // viewDidLoad()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList.count
    } // Collection: Number of Items
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! RDCell
        
        cell.imageView!.image = albumList[indexPath.row].artwork
        
        return cell

    } // Collection: Cell for item
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let collectionID = albumList[indexPath.row].id
        print("Selected: \(collectionID)")
        
        self.title = "Albums"
        let album = albumList[indexPath.row]
        let ctrl = SongViewController()
        ctrl.album = album
        ctrl.back = true
        self.navigationController?.pushViewController(ctrl, animated: true)

    } // Collection: Item Selected
    
} // MusicViewController()

class RDCell: UICollectionViewCell {
    var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        contentView.addSubview(imageView)
        
    } // init()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
} // RDCell()
