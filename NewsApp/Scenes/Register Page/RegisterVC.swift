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

    
//   
//
//        usernameTextField.setIcon(UIImage(systemName: "person.fill")!)
//        emailTextField.setIcon(UIImage(systemName: "envelope.fill")!)
//        passwordTextField.setIcon(UIImage(systemName: "lock.fill")!)
    }
    
    @IBAction func registerAct(_ sender: UIButton) {
        print("Register user")
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

