//
//  Station.swift
//  Rad-io
//
//  Created by George on 2016-05-19.
//  Copyright © 2016 George. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Station{
    var station_name: String!
    var station_url: String!
    var station_genre: String!
    var station_desc: String?
    
    init(json: JSON){
        station_name = json["station_name"].string
        station_url = json["stsation_url"].string
        station_genre = json["station_genre"].string
        station_desc = json["station_desc"].string
    }
}