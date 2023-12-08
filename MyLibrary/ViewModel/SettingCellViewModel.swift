//
//  SettingCellViewModel.swift
//  MyLibrary
//
//  Created by Jennifer Chukwuemeka on 06/12/2023.
//

import UIKit
struct SettingCellViewModel: Identifiable {
    var id = UUID()
    
  
    public var image: UIImage? {
        return type.iconImage
        
    }
    public var title: String {
        return type.displayTitle
    }
    public let type: SettingOption
       public let onTapHandler: (SettingOption) -> Void
           
       
       
       init(type: SettingOption, onTapHandler: @escaping(SettingOption) -> Void) {
           self.type = type
           self.onTapHandler = onTapHandler
          
       }
       public var iconContainerColor: UIColor {
           return type.iconContainerColor
           
       }
}
