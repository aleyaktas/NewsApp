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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
    }
    
    func prepareTextFields() {
        usernameTextField.setIcon(UIImage(systemName: "person.fill")!)
        passwordTextField.setIcon(UIImage(systemName: "lock.fill")!)
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
