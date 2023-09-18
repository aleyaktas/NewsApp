//
//  LoginVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 5.09.2023.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var loginDescription: UILabel!
    @IBOutlet weak var forgotPassword: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var hasAccountText: UILabel!
    @IBOutlet weak var createAccount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
    }
    
    func prepareTextFields() {
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "username_placeholder".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password_placeholder".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        welcomeText.text = "welcome_text".localized()
        loginDescription.text = "login_description".localized()
        forgotPassword.text = "forgot_password".localized()
        loginButton.setTitle("login_button".localized(), for: .normal)
        hasAccountText.text = "has_account_text".localized()
        createAccount.setTitle("create_account_text".localized(), for: .normal)
        
        loginDescription.numberOfLines = 0
        loginDescription.lineBreakMode = .byTruncatingTail
    }
    
    
    @IBAction func loginAct(_ sender: UIButton) {
        print("Login user")
    }
    
    @IBAction func createAccountAct(_ sender: UIButton) {
        print("Got to create page")
            
        let storyboard = UIStoryboard(name: "RegisterVC", bundle: nil)
        let gotoVC = storyboard.instantiateViewController(withIdentifier: "RegisterVC")
        gotoVC.modalTransitionStyle = .flipHorizontal
        gotoVC.modalPresentationStyle = .fullScreen
        self.present(gotoVC, animated: true)
        
    }
    
}
