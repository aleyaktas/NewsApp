//
//  AccountsVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 15.09.2023.
//

import UIKit
import Localize_Swift
import FirebaseStorage
import Firebase
import Kingfisher

class AccountsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var fullNameText: UILabel!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    var auth = AuthenticationManager()
    var viewModel = AccountVM()
    let imagePicker = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureData()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        uploadUserImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged),name: NSNotification.Name("changeLanguage"), object: nil)
    }
    
    
    @objc func languageChanged() {
        configureData()
    }
    
    func uploadUserImage() {
        let url = viewModel.uploadUserImage()
        if let url {
            self.profilePhoto.kf.setImage(with: url)
        }
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
    
    
    @IBAction func editPhotoAct(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                profilePhoto.image = pickedImage
                viewModel.uploadProfilePhoto(image: pickedImage) { (downloadURL) in
                    if let downloadURL {
                        self.showAlert(title: "Success", message: "Profile image updated")
                    } else {
                        self.showAlert(title: "Warning", message: "Profile image not updated")
                    }
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }

    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
          picker.dismiss(animated: true, completion: nil)
      }
    
}



