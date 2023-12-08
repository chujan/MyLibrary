//
//  BookShelfResponse.swift
//  MyLibrary
//
//  Created by Jennifer Chukwuemeka on 03/12/2023.
//

import Foundation
struct BookshelfResponse: Codable {
    let items: [BookshelfItem]?
}

struct BookshelfItem: Codable {
    let id: String
    let volumeInfo: VolumeInfo
    let accessInfo: AccessInfo
}

struct VolumeInfo: Codable {
    let title: String
    let author: String
    // ... other volume information
}

struct AccessInfo: Codable {
    // ... access information
}

