//
//  Station.swift
//  Rad-io
//
//  Created by George on 2016-05-19.
//  Copyright © 2016 George. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Station{
    var station_name: String!
    var station_url: String!
    var station_genre: String!
    var station_desc: String?
    
    init(json: JSON){
        station_name = json["station_name"].string
        station_url = json["station_url"].string
        station_genre = json["station_genre"].string
        station_desc = json["station_desc"].string
    }
    
    static func retriveStations(completionHandler: (error: NSError?, stations: [Station]?) -> ()) -> (){
        let url = "https://rawgit.com/gkye/Rad-io/master/Data/stations.json"
        var stationsArray = [Station]()
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    if json != nil{
                        json.forEach(){
                            stationsArray.append(Station.init(json: $0.1))
                            completionHandler(error: nil, stations: stationsArray)
                        }
                    }
                }
            case .Failure(let error):
                print(error)
                completionHandler(error: error, stations: nil)
            }
        }
    }
}