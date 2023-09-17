//
//  RegisterVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 5.09.2023.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
    }
    
    func prepareTextFields() {

        if let usernamePlaceholder = usernameTextField.placeholder,
           let emailPlaceholder = emailTextField.placeholder,
           let passwordPlaceholder = passwordTextField.placeholder {
            usernameTextField.attributedPlaceholder = NSAttributedString(string: usernamePlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
            emailTextField.attributedPlaceholder = NSAttributedString(string: emailPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
            passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        }

    }
    
    @IBAction func registerAct(_ sender: UIButton) {
        print("Register user")
        let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
                if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {
                     if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let windowDelegate = windowScene.delegate as? SceneDelegate {
                         windowDelegate.window?.rootViewController = tabBarController
                     }
                 }
    }
    
    @IBAction func loginAct(_ sender: UIButton) {
        print("Go to login page")
        
        let storyboard = UIStoryboard(name: "LoginVC", bundle: nil)
        let gotoVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        gotoVC.modalTransitionStyle = .flipHorizontal
        gotoVC.modalPresentationStyle = .fullScreen
        self.present(gotoVC, animated: true)
    }
}

