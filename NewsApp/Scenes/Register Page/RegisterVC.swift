//
//  RegisterVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 5.09.2023.
//

import UIKit
import Localize_Swift

final class RegisterVC: UIViewController {
    
    var viewModel = RegisterVM()
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccount: UILabel!
    @IBOutlet weak var registerDescription: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var hasAccountText: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView!
    var loadingOverlay: UIView!
    
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
        registerButton.setTitle("register_button".localized(), for: .normal)
        hasAccountText.text = "has_account_text".localized()
        loginButton.setTitle("login_button".localized(), for: .normal)
        
        fullNameTextField.setupRightImage(imageName: "person.fill")
        emailTextField.setupRightImage(imageName: "envelope.fill")
        passwordTextField.setupRightImage(imageName: "lock.fill")
        
        registerDescription.numberOfLines = 0
        registerDescription.lineBreakMode = .byTruncatingTail
    }
    
    func showLoadingIndicator() {
        loadingOverlay = UIView(frame: view.bounds)
        loadingOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loadingOverlay.center
        loadingOverlay.addSubview(activityIndicator)
        view.addSubview(loadingOverlay)
        activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        loadingOverlay.removeFromSuperview()
    }

    @IBAction func registerAct(_ sender: UIButton) {
        showLoadingIndicator()
           guard let fullname = fullNameTextField.text, !fullname.isEmpty,
                 let email = emailTextField.text, !email.isEmpty,
                 let password = passwordTextField.text, !password.isEmpty else {
                   hideLoadingIndicator()
                   showAlert(title: "Warning", message: "Please fill fullname, email and password fields.")
                   return
           }
           
           viewModel.registerUser(fullname: fullname, email: email, password: password) { success, errorMessage in
               if success {
                   self.handleRegistrationSuccess()
               } else if let errorMessage = errorMessage {
                   self.showAlert(title: "User registration failed", message: errorMessage)
               }
               self.hideLoadingIndicator()
           }
       }
       
       private func handleRegistrationSuccess() {
           let storyboard = UIStoryboard(name: "HomeVC", bundle: nil)
           if let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {
               if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let windowDelegate = windowScene.delegate as? SceneDelegate {
                   windowDelegate.window?.rootViewController = tabBarController
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

