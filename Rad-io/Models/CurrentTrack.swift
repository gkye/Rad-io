//
//  CurrentTrack.swift
//  Rad-io
//
//  Created by George on 2016-05-19.
//  Copyright © 2016 George. All rights reserved.
//

import Foundation
import UIKit

struct Track {
    var title: String = ""
    var artwork: String = ""
    var artworkCover: String = ""
    var artworkLoaded = false
    var isPlaying: Bool = false
    var itunesSearchTerm: String = ""
    var image: UIImage = UIImage(named: placeHolderImg)!
}