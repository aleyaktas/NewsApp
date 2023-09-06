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
//        if let textField = usernameTextField {
//            // textField nil değilse, işlemleri gerçekleştir
//            textField.setIcon(UIImage(systemName: "person.fill")!)
//        } else {
//            // textField nil ise, uygun bir şekilde ele alın
//            print("usernameTextField nil olarak bulundu.")
//        }
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

