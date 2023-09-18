//
//  RegisterVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 5.09.2023.
//

import UIKit
import Localize_Swift
import Firebase
import FirebaseDatabase

class RegisterVC: UIViewController {
    
    var authManager = AuthenticationManager()
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccount: UILabel!
    @IBOutlet weak var registerDescription: UILabel!
    @IBOutlet weak var securityPolicy: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var hasAccountText: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
    }
    
    
    func prepareTextFields() {
        fullNameTextField.attributedPlaceholder = NSAttributedString(string: "fullname_placeholder".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "email_placeholder".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password_placeholder".localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        createAccount.text = "create_account_text".localized()
        registerDescription.text = "register_description".localized()
        securityPolicy.text = "security_policy".localized()
        registerButton.setTitle("register_button".localized(), for: .normal)
        hasAccountText.text = "has_account_text".localized()
        loginButton.setTitle("login_button".localized(), for: .normal)
        
        registerDescription.numberOfLines = 0
        registerDescription.lineBreakMode = .byTruncatingTail
    }

    @IBAction func registerAct(_ sender: UIButton) {
        
        guard let fullname = fullNameTextField.text, !fullname.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            return
        }
            
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    print("User registration failed: \(error.localizedDescription)")
                } else {
                    if let user = Auth.auth().currentUser {
                        let db = Database.database().reference()
                        let userRef = db.child("users").child(user.uid)
                        
                        let userData: [String: Any] = [
                            "fullname": fullname,
                            "email": user.email ?? ""
                        ]
                        
                        userRef.setValue(userData) { (error, ref) in
                            if let error = error {
                                print("User information could not be saved: \(error.localizedDescription)")
                            } else {
                                print("User information has been successfully saved!")
                                let newUser = User(fullname: fullname, email: user.email ?? "")
                                self.authManager.saveUserToUserDefaults(user: newUser)
                                let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
                                if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {
                                   if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                      let windowDelegate = windowScene.delegate as? SceneDelegate {
                                       windowDelegate.window?.rootViewController = tabBarController
                                   }
                                }
                            }
                        }
                    }
                }
            }
    }
    
    @IBAction func loginAct(_ sender: UIButton) {        
        let storyboard = UIStoryboard(name: "LoginVC", bundle: nil)
        let gotoVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        gotoVC.modalTransitionStyle = .flipHorizontal
        gotoVC.modalPresentationStyle = .fullScreen
        self.present(gotoVC, animated: true)
    }
}

