//
//  SettingViewController.swift
//  MyLibrary
//
//  Created by Jennifer Chukwuemeka on 29/11/2023.
//

import UIKit
import StoreKit
import SwiftUI
import SafariServices

class SettingViewController: UIViewController {
    private var settingsView: UIHostingController<SettingsView>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Setting"
        addSwiftUIController()
        
     
       
        

      
      
    }
    func addSwiftUIController() {
        let settingsView = UIHostingController(rootView: SettingsView(viewModel: SettingViewViewModel(cellViewModels: SettingOption.allCases.map({
            return  SettingCellViewModel(type: $0) { [weak self] option in
                self?.handleTap(option: option)
            }
            
        }), onTapHandler: { option in
            
        })))
        addChild(settingsView)
        settingsView.didMove(toParent: self)
        view.addSubview(settingsView.view)
        settingsView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                      settingsView.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                      
                      settingsView.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                      
                      settingsView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                      
        ])
        self.settingsView = settingsView
    }
    private func handleTap(option: SettingOption) {
            guard Thread.main.isMainThread else {
                return
            }
            if let url = option.targetUrl {
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true)
                
            } else if option == .rateApp {
                if let windowScene = view.window?.windowScene {
                    SKStoreReviewController.requestReview(in: windowScene)
                }
                
            }
            
        }
  
   


    
}




