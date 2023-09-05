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
        usernameTextField.setIcon(UIImage(systemName: "person.fill")!)
        emailTextField.setIcon(UIImage(systemName: "envelope.fill")!)
        passwordTextField.setIcon(UIImage(systemName: "lock.fill")!)
    }
    
    @IBAction func registerAct(_ sender: UIButton) {
        print("Register user")
    }
    
}

