//
//  AccountsVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 15.09.2023.
//

import UIKit
import Localize_Swift
import Firebase

class AccountsVC: UIViewController {

    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var fullNameText: UILabel!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    var auth = AuthenticationManager()
    var viewModel = AccountVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged),name: NSNotification.Name("changeLanguage"), object: nil)
    }
    
    @objc func languageChanged() {
        configureData()
    }
    
    func configureData() {
        fullNameText.text = "fullname_placeholder".localized()
        emailText.text = "email_placeholder".localized()
        emailTextField.isUserInteractionEnabled = false
        if let user = auth.getUserFromUserDefaults() {
            fullNameTextField.text = user.fullname
            emailTextField.text = user.email
        }
        
        editPhotoButton.setTitle("edit_photo_button".localized(), for: .normal)
        saveButton.setTitle("save_button".localized(), for: .normal)
    }
    
    @IBAction func saveButtonAct(_ sender: UIButton) {
        if let newFullname = fullNameTextField.text, !newFullname.isEmpty {
            viewModel.updateUser(fullname: newFullname) { success, message in
                if success {
                    self.showAlert(title: "Success", message: message)
                } else {
                    self.showAlert(title: "Error", message: message)
                }
                }
            
            } else {
                showAlert(title: "Warning", message: "Please fill in fields.")
            }
        }
}



