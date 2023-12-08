//
//  SettingsView.swift
//  MyLibrary
//
//  Created by Jennifer Chukwuemeka on 06/12/2023.
//

import SwiftUI

struct SettingsView: View {
    let viewModel: SettingViewViewModel

    init(viewModel: SettingViewViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)  // Fix the typo here
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15 , height: 20)
                        .foregroundColor(Color.red)
                        .padding(15)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(6)
                }
                Text(viewModel.title)
                    .padding(.leading, 10)
                Spacer()
            }
            .padding(.bottom, 3)
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: .init(cellViewModels: SettingOption.allCases.compactMap({
            return SettingCellViewModel(type: $0) { option in
                // Add your preview content here
            }
        }), onTapHandler: { option in
            
        }))
    }
}
