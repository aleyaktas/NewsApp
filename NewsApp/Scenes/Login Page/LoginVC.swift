//
//  LoginVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 5.09.2023.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var loginDescription: UILabel!
    @IBOutlet weak var forgotPassword: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var hasAccountText: UILabel!
    @IBOutlet weak var createAccount: UIButton!
        
    let viewModel = LoginVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
    }
    
    func prepareTextFields() {
        emailTextField.attributedPlaceholder = NSAttributedString(string: "email_placeholder".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
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
          guard let email = emailTextField.text, !email.isEmpty,
                let password = passwordTextField.text, !password.isEmpty else {
                  showAlert(title: "Warning", message: "Please fill in both email and password fields.")
                  return
          }
          
          viewModel.loginUser(email: email, password: password) { success, errorMessage in
              if success {
                  self.handleSuccessfulLogin()
              } else if let errorMessage = errorMessage {
                  self.showAlert(title: "User login failed", message: errorMessage)
              }
          }
      }
      
      private func handleSuccessfulLogin() {
          let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
          if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {
              if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let windowDelegate = windowScene.delegate as? SceneDelegate {
                  windowDelegate.window?.rootViewController = tabBarController
              }
          }
      }
    
    
    @IBAction func createAccountAct(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "RegisterVC", bundle: nil)
        let gotoVC = storyboard.instantiateViewController(withIdentifier: "RegisterVC")
        gotoVC.modalTransitionStyle = .flipHorizontal
        gotoVC.modalPresentationStyle = .fullScreen
        self.present(gotoVC, animated: true)
    }
    
}
