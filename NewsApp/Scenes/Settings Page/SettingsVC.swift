//
//  SettingsVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 14.09.2023.
//

import UIKit
import Localize_Swift

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
    var viewModel = SettingsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged),name: NSNotification.Name("changeLanguage"), object: nil)

        languageChanged()

    }
    
    func configureData() {
        darkModeSwitch.isOn = viewModel.isDarkModeOn
        let selectedLanguage = viewModel.selectedLanguage
                segmentedControl.selectedSegmentIndex = (selectedLanguage == .turkish) ? 0 : 1
    }
  
    @IBAction func darkModeAct(_ sender: UISwitch) {
        viewModel.isDarkModeOn = sender.isOn
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
        let selectedLanguage = (sender.selectedSegmentIndex == 0) ? Language.turkish : Language.english

        Localize.setCurrentLanguage(selectedLanguage.rawValue)

            viewModel.selectedLanguage = selectedLanguage
            NotificationCenter.default.post(name: NSNotification.Name("changeLanguage"), object: nil)
    }

    
    @IBAction func editAccountAct(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AccountsVC", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "AccountsVC") as? AccountsVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
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


