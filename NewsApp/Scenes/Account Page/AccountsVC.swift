//
//  AccountsVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 15.09.2023.
//

import UIKit

struct Fields {
    var title: String
    var text: String
}

class AccountsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var profileFields: [Fields] = [
        Fields(title: "Name", text: "Aleyna Aktaş"),
        Fields(title: "Email", text: "aleynaaktas627@gmail.com"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
