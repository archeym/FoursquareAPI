//
//  Cafe.swift
//  FoursquareAPI
//
//  Created by Arkadijs Makarenko on 25/04/2017.
//  Copyright © 2017 ArchieApps. All rights reserved.
//

import Foundation
class Venue {
    var name : String = ""
    var id : String = ""
    var address : String = ""
    var city : String = ""
    var phone : String = ""
    var url : String = ""
    var categoryName : String = ""
    var lat : Double = 0.0
    var lng : Double = 0.0
    
    init(dict: [String : Any]){
        
        name = dict["name"] as? String ?? ""
        id = dict["id"] as? String ?? ""
        url = dict["url"] as? String ?? ""
        if let location = dict["location"] as? [String : Any]{
            address = location["address"] as? String ?? ""
            city = location ["city"] as? String ?? ""
            lat = location["lat"] as? Double ?? 0.0
            lng = location["lng"] as? Double ?? 0.0
            
        }
        if let contact = dict["contact"] as? [String : Any]{
            phone = contact["phone"] as? String ?? ""
        }
        if let categories = dict["categories"] as? [[String : Any]] {
            for category in categories{
                categoryName = category["name"] as? String ?? ""
            }
        }
    }
}
