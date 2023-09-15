//
//  TabBarController.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 5.09.2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = UIColor(named: "primary")
        
        let homeVC = UIStoryboard(name: "HomeVC", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let searchVC = UIStoryboard(name: "SearchVC", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        let favoritesVC = UIStoryboard(name: "FavoritesVC", bundle: nil).instantiateViewController(withIdentifier: "FavoritesVC") as! FavoritesVC
        let settingsVC = UIStoryboard(name: "SettingsVC", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC


        let nav1 = UINavigationController(rootViewController: homeVC)
        let nav2 = UINavigationController(rootViewController: searchVC)
        let nav3 = UINavigationController(rootViewController: favoritesVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)


        nav1.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "square.stack.3d.up"), tag: 0)
        nav2.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        nav3.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "bookmark"), tag: 0)
        nav4.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "gearshape.fill"), tag: 0)

        setViewControllers([nav1, nav2, nav3, nav4], animated: false)
    }
}


