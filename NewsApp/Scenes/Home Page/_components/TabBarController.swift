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
        
        let homeVC = UIStoryboard(name: "HomeVC", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
    
        let nav1 = UINavigationController(rootViewController: homeVC)

        nav1.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "square.stack.3d.up"), tag: 0)
        setViewControllers([nav1], animated: false)
      
    }
}


