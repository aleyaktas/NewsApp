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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged),name: NSNotification.Name("changeLanguage"), object: nil)
        configureData()
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
        
        if let newFullname = fullNameTextField.text, !newFullname.isEmpty{
            let updateUser = User(fullname: newFullname, email: emailTextField.text)
              auth.saveUserToUserDefaults(user: updateUser)
              
              if let user = Auth.auth().currentUser {
                  
                  let db = Database.database().reference()
                  let userRef = db.child("users").child(user.uid)
                  
                  userRef.updateChildValues(["fullname": newFullname]) { (error, _) in
                     if let error = error {
                         print("Failed to update user data: \(error.localizedDescription)")
                     } else {
                         print("User data updated successfully")
                         self.showAlert(title: "Success", message: "Profile successfully updated")
                         let updateUser = User(fullname: newFullname, email: self.emailTextField.text)
                         self.auth.saveUserToUserDefaults(user: updateUser)
                         NotificationCenter.default.post(name: NSNotification.Name("updateFullName"), object: nil)

                     }
                  }
              }
          } else {
              showAlert(title: "Warning", message: "Please fill in fields.")
          }
    }
}



