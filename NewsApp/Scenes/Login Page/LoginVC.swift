//
//  LoginVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 5.09.2023.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
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
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("User login failed: \(error.localizedDescription)")
                self.showAlert(title: "User login failed", message: error.localizedDescription)
            } else {
                print("User logged in successfully!")
                let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
                if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {
                   if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let windowDelegate = windowScene.delegate as? SceneDelegate {
                       windowDelegate.window?.rootViewController = tabBarController
                   }
                }
                
                if let user = Auth.auth().currentUser {
                    let db = Database.database().reference()
                    let userRef = db.child("users").child(user.uid)
                    
                    userRef.getData() { (error, snapshot) in
                        if let error = error {
                            print("Failed to retrieve user data: \(error.localizedDescription)")
                        } else {
                            if let userData = snapshot?.value as? [String: Any],
                               let fullname = userData["fullname"] as? String {
                                print("Full Name: \(fullname)")
                            }
                            
                        }
                    }
                }
                
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
