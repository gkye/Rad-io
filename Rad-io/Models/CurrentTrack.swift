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
    var artworkURL: String = ""
    var artworkImage = UIImage(named: "albumArt")
    var artworkLoaded = false
    var isPlaying: Bool = false
}