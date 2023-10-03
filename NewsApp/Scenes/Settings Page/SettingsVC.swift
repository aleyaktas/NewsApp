//
//  SettingsVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 14.09.2023.
//

import UIKit
import Localize_Swift

final class SettingsVC: UIViewController {

    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var darkModeText: UILabel!
    @IBOutlet weak var languageText: UILabel!
    @IBOutlet weak var generalText: UILabel!
    @IBOutlet weak var accountText: UILabel!
    @IBOutlet weak var privacyAndSecurityText: UILabel!
    @IBOutlet weak var editAccountText: UILabel!
    @IBOutlet weak var securityText: UILabel!
    @IBOutlet weak var signOutText: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var editAccountView: UIView!
    @IBOutlet weak var privacyView: UIView!
    
    var auth = AuthenticationManager()
    var viewModel = SettingsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureData()
        languageChanged()
        
        prepareEditAccountAct()
        preparePrivacyAct()

        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged),name: NSNotification.Name("changeLanguage"), object: nil)
    }
    
    func prepareEditAccountAct() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editAccountAct))
        editAccountView.addGestureRecognizer(tapGesture)
    }
    
    func preparePrivacyAct() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(privacyAct))
        privacyView.addGestureRecognizer(tapGesture)
    }
    
    @objc func editAccountAct() {
        let storyboard = UIStoryboard(name: "AccountsVC", bundle: nil)

        if let vc = storyboard.instantiateViewController(withIdentifier: "AccountsVC") as? AccountsVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func privacyAct() {
        
        let storyboard = UIStoryboard(name: "PrivacySecurityDetail", bundle: nil)
        
        if let gotoVC = storyboard.instantiateViewController(withIdentifier: "PrivacySecurityDetailVC") as? PrivacySecurityDetailVC {
            gotoVC.label = "privacy_policy_text".localized()
            self.present(gotoVC, animated: true, completion: nil)
        }
    }
    
    func configureData() {
        self.navigationItem.title = "settings_text".localized()
        darkModeSwitch.isOn = viewModel.isDarkModeOn
        let selectedLanguage = viewModel.selectedLanguage
                segmentedControl.selectedSegmentIndex = (selectedLanguage == .turkish) ? 0 : 1
    }
  
    @IBAction func darkModeAct(_ sender: UISwitch) {
        viewModel.isDarkModeOn = sender.isOn
    }
    
    @objc func languageChanged() {
        self.navigationItem.title = "settings_text".localized()
        generalText.text = "general_text".localized()
        darkModeText.text = "dark_mood".localized()
        languageText.text = "language_text".localized()
        accountText.text = "account_text".localized()
        editAccountText.text = "editAccount_text".localized()
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
    
    @IBAction func signOutAct(_ sender: UIButton) {
        viewModel.signOut { [weak self] success, error in
            if success {
                self?.handleSignOutSuccess()
            } else if let error = error {
                self?.handleSignOutError(error)
            }
        }
    }
    
    private func handleSignOutSuccess() {
        self.tabBarController?.tabBar.isHidden = true
            let storyboard = UIStoryboard(name: "LoginVC", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                vc.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    private func handleSignOutError(_ error: Error) {
        print("Error logging out: \(error.localizedDescription)")
    }
}


