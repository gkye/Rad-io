//
//  ItunesAPI.swift
//  Rad-io
//
//  Created by George on 2016-05-19.
//  Copyright © 2016 George. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class ItunesAPI{
    
    
    class func getTrackArtwork(trackTitle: String, completionHandler: (artworkURL: String?) -> ()) -> (){
        let url = "https://itunes.apple.com/search"
        let params = [
            "term": trackTitle,
            "entity": "song"
        ]
        var artworkUrl: String? = nil
        Alamofire.request(.GET, url, parameters: params).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    artworkUrl = json["results"][0]["artworkUrl100"].string
                }
            case .Failure(let error):
                print(error)
            }
            completionHandler(artworkURL: artworkUrl)
        }
    }
    
    class func downloadImage(url: String, completionHandler: (UIImage) -> ()) -> (){
        Alamofire.request(.GET, url)
            .responseImage { response in
                if let image = response.result.value {
                    completionHandler(image)
                }
        }
    }
}