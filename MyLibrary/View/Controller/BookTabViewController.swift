//
//  BookTabViewController.swift
//  Books
//
//  Created by Jennifer Chukwuemeka on 10/11/2023.
//

import UIKit

class BookTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()

        view.backgroundColor = .systemBackground
    }
    

    private  func setUpTabs() {
        let exploreVC = ExploreViewController()
        let readVC = ProfileViewController()
        let bookmarkVC = BookMarkViewController()
        let myselfVC = SettingViewController()
      
        exploreVC.navigationItem.largeTitleDisplayMode = .automatic
        readVC.navigationItem.largeTitleDisplayMode = .automatic
       bookmarkVC.navigationItem.largeTitleDisplayMode = .automatic
        myselfVC.navigationItem.largeTitleDisplayMode = .automatic
       
        
        let nav1 = UINavigationController(rootViewController: exploreVC)
        let nav2 = UINavigationController(rootViewController: readVC)
        let nav3 = UINavigationController(rootViewController: bookmarkVC)
        let nav4 = UINavigationController(rootViewController: myselfVC)
      
        
        nav1.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "safari"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "BookMark", image: UIImage(systemName: "bookmark.circle"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 4)
       
        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
        
    }
    

}


