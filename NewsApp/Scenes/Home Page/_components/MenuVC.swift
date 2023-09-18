//
//  MenuVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 15.09.2023.
//

import UIKit
import Localize_Swift

protocol MenuListDelegate {
    func didSelectCategory(_ category: String)
}

class MenuListController: UITableViewController {
    var items: [String] = []
    public var menuDelegate: MenuListDelegate?
    
    init(items: [String] = ["General", "Business", "Entertainment", "Health", "Science", "Sports", "Technology"], menuDelegate: MenuListDelegate? = nil) {
        self.items = items.map { $0.localized() }
        super.init(style: .plain)
        self.menuDelegate = menuDelegate
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged),name: NSNotification.Name("changeLanguage"), object: nil)
        
        tableView.backgroundColor = .systemGray4
        tableView.separatorStyle = .none
    }
    
    @objc func languageChanged() {
        items = ["General", "Business", "Entertainment", "Health", "Science", "Sports", "Technology"].map { $0.localized() }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = UIColor.darkText
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.backgroundColor = .systemGray4
        cell.imageView?.tintColor = UIColor(named: "primary")
        cell.imageView?.image = UIImage(systemName: "square.fill") 
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = items[indexPath.row]
        menuDelegate?.didSelectCategory(selectedCategory)
    }


}
