//
//  UserPreferences.swift
//  MyLibrary
//
//  Created by Jennifer Chukwuemeka on 29/11/2023.
//

import Foundation
struct UserPreferences: Codable {
    var fontType: String
    var theme: String
    var fontSize: CGFloat

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fontType = try container.decode(String.self, forKey: .fontType)
        theme = try container.decode(String.self, forKey: .theme)
        fontSize = try container.decode(CGFloat.self, forKey: .fontSize)
    }

    init(fontType: String, theme: String, fontSize: CGFloat) {
        self.fontType = fontType
        self.theme = theme
        self.fontSize = fontSize
    }
}

