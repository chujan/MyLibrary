//
//  UserContent.swift
//  MyLibrary
//
//  Created by Jennifer Chukwuemeka on 28/11/2023.
//

import Foundation
//
import Foundation

struct UserContent {
    var authors: [String]
    var audioTracks: [String]
    
    var audioTracksCount: Int {
        return audioTracks.count
    }
    
    var authorsCount: Int {
        return authors.count
    }
}


