//
//  SettingViewViewModel.swift
//  MyLibrary
//
//  Created by Jennifer Chukwuemeka on 06/12/2023.
//

import Foundation
struct SettingViewViewModel {
    let cellViewModels: [SettingCellViewModel]
    let onTapHandler: (SettingOption) -> Void
}
