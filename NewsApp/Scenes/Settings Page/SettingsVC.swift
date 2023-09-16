//
//  SettingsVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 14.09.2023.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.bool(forKey: "IsDarkMode") == true {
            darkModeSwitch.isOn = true
        } else {
            darkModeSwitch.isOn = false

        }
    }
  
    @IBAction func darkModeAct(_ sender: UISwitch) {
        if sender.isOn {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .dark
                    UserDefaults.standard.set(sender.isOn, forKey: "IsDarkMode")
                }
            }
        } else {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .light
                    UserDefaults.standard.set(sender.isOn, forKey: "IsDarkMode")
                }
            }
        }

    }
    @IBAction func editAccountAct(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AccountsVC", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "AccountsVC") as? AccountsVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
