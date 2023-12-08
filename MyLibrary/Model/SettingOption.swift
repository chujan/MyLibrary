//
//  SettingOption.swift
//  MyLibrary
//
//  Created by Jennifer Chukwuemeka on 06/12/2023.
//

import Foundation
import UIKit

enum SettingOption: CaseIterable {
    case rateApp
    case contactUs
    case privacy
    case terms
    case apiReference
    case viewSeries
    case viewCode
    case signOut
    
    var targetUrl: URL? {
        switch self {
        case.rateApp:
            return nil
        case.contactUs:
            return URL(string: "https://github.com/chujan")
        case .privacy:
            return URL(string: "https://github.com/chujan")
        case .terms:
            return URL(string: "https://github.com/chujan")
        case .apiReference:
            return URL(string: "https://developers.google.com/books/docs/v1/using")
        case .viewSeries:
            return URL(string: "https://github.com/chujan")
        case .viewCode:
            return URL(string: "https://github.com/chujan")
        case .signOut:
            return nil
        }
    }
    
    var displayTitle: String {
        switch self {
        case.rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .privacy:
            return "Privacy Policy"
        case .terms:
          return  "Terms of Service"
        case .apiReference:
          return  "API Reference"
        case .viewSeries:
            return "View Viedo Series"
        case .viewCode:
            return "View App Code"
        case.signOut:
            return "Sign Out"
        }
    }
    
    var iconContainerColor: UIColor {
        switch self {
            
        case .rateApp:
            return .systemRed
        case .contactUs:
            return .systemBlue
        case .privacy:
            return .systemBrown
        case .terms:
            return .systemTeal
        case .apiReference:
            return.systemPink
        case .viewSeries:
            return.systemPurple
        case .viewCode:
            return.systemOrange
        case .signOut:
            return.yellow
        }
    }
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
                  return UIImage(systemName: "star.fill")
              case .contactUs:
                  return UIImage(systemName: "paperplane")
              case .privacy:
                  return UIImage(systemName: "lock")
              case .terms:
                  return UIImage(systemName: "doc")
              case .apiReference:
                  return UIImage(systemName: "list.clipboard")
              case .viewSeries:
                  return UIImage(systemName: "tv.fill")
              case .viewCode:
                  return UIImage(systemName: "hammer.fill")
            
        case .signOut:
            return UIImage(systemName: "square.and.arrow.up.circle")
        }
    }
}
