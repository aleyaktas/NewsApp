//
//  SettingsVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 14.09.2023.
//

import UIKit
import Localize_Swift
import Firebase

class SettingsVC: UIViewController {

    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var darkModeText: UILabel!
    @IBOutlet weak var languageText: UILabel!
    @IBOutlet weak var accountText: UILabel!
    @IBOutlet weak var privacyAndSecurityText: UILabel!
    @IBOutlet weak var editAccountText: UILabel!
    @IBOutlet weak var changePasswordText: UILabel!
    @IBOutlet weak var securityText: UILabel!
    @IBOutlet weak var signOutText: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var auth = AuthenticationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged),name: NSNotification.Name("changeLanguage"), object: nil)
                
        if UserDefaults.standard.bool(forKey: "IsDarkMode") == true {
            darkModeSwitch.isOn = true
        } else {
            darkModeSwitch.isOn = false
        }
        
        languageChanged()
        
        if let selectedLanguage = UserDefaults.standard.string(forKey: "AppSelectedLanguage") {
            segmentedControl.selectedSegmentIndex = (selectedLanguage == "tr") ? 0 : 1
        } else {
            segmentedControl.selectedSegmentIndex = 1
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
    
    @objc func languageChanged() {
        darkModeText.text = "dark_mood".localized()
        languageText.text = "language_text".localized()
        accountText.text = "account_text".localized()
        editAccountText.text = "editAccount_text".localized()
        changePasswordText.text = "change_password_text".localized()
        securityText.text = "security_text".localized()
        signOutText.setTitle("sign_out_text".localized(), for: .normal)
        privacyAndSecurityText.text = "privacyAndSecurity_text".localized()
    }

    
    @IBAction func changeLanguageAct(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
           case 0:
            Localize.setCurrentLanguage("tr")
            UserDefaults.standard.set("tr", forKey: "AppSelectedLanguage")

           case 1:
            Localize.setCurrentLanguage("en")
            UserDefaults.standard.set("en", forKey: "AppSelectedLanguage")

           default:
               break
           }
        NotificationCenter.default.post(name: NSNotification.Name("changeLanguage"), object: nil)
    }
    
    @IBAction func editAccountAct(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AccountsVC", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "AccountsVC") as? AccountsVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func signOutAct(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            auth.deleteUserFromUserDefaults()

            let storyboard = UIStoryboard(name: "LoginVC", bundle: nil)

            if let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
                self.tabBarController?.tabBar.isHidden = true
                vc.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } catch let error as NSError {
            print("Çıkış yaparken hata oluştu: \(error.localizedDescription)")
        }
    }
}
