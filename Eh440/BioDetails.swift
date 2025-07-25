//
//  BioDetails.swift
//  Eh440
//
//  Created by Family iMac on 2016-07-17.
//  Copyright © 2016 Andrew Selkirk. All rights reserved.
//

import UIKit

class BioDetails {

    // Data
    var name: String = ""
    var role: String = ""
    var hometown: String = ""
    var image: String = ""
    var facts: String = ""

    static var details: [BioDetails] = []
    
    static func get() -> [BioDetails] {
        
        if details.count == 0 {
            var bioList: [BioDetails] = []
            
            let bioPath = Bundle.main.path(forResource: "Bio", ofType: "plist")
            let rootDict = NSArray(contentsOfFile: bioPath!)!
            
            for (myvalue) in rootDict {
                let dict = myvalue as! NSDictionary
                let item = BioDetails()
                item.name = dict["name"] as! String
                item.role = dict["role"] as! String
                item.hometown = dict["hometown"] as! String
                item.image = dict["image"] as! String
                item.facts = dict["facts"] as! String
                
                bioList.append(item)
                
            } // if
            
            details = bioList
            
         } // if

        return details
        
    } // get()
    
} // BioDetails()
