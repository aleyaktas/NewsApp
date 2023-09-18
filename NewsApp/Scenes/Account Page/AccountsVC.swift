//
//  AccountsVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 15.09.2023.
//

import UIKit
import Localize_Swift

struct Fields {
    var title: String
    var text: String
}

class AccountsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var profileFields: [Fields] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged),name: NSNotification.Name("changeLanguage"), object: nil)
        
        languageChanged()
    }
    
    @objc func languageChanged() {

        editPhotoButton.setTitle("edit_photo_button".localized(), for: .normal)
        profileFields = [
            Fields(title: "username_placeholder".localized(), text: "Aleyna Aktaş"),
            Fields(title: "email_placeholder".localized(), text: "aleynaaktas627@gmail.com"),
        ]
        saveButton.setTitle("save_button".localized(), for: .normal)
    }
}


extension AccountsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell", for: indexPath) as? AccountTableViewCell {
            let profile = profileFields[indexPath.row]

            cell.header.text = profile.title
            cell.textField.text = profile.text

            return cell
        } else {
            return UITableViewCell()
        }
    }
}
