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
    
    var authManage = AuthenticationManager()
    
    init(items: [String] = ["General", "Business", "Entertainment", "Health", "Science", "Sports", "Technology"], menuDelegate: MenuListDelegate? = nil) {
        self.items = items.map { $0.localized() }
        super.init(style: .plain)
        self.menuDelegate = menuDelegate
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        customNibs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customNibs() {
        let menuHeaderCellNib = UINib(nibName: "MenuHeaderTableView", bundle: nil)
        tableView.register(menuHeaderCellNib, forCellReuseIdentifier: "MenuHeaderTableViewCell")
        let menuItemCellNib = UINib(nibName: "MenuItemTableView", bundle: nil)
        tableView.register(menuItemCellNib, forCellReuseIdentifier: "MenuItemTableViewCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged),name: NSNotification.Name("changeLanguage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fullNameUpdated),name: NSNotification.Name("updateFullName"), object: nil)
        tableView.backgroundColor = .systemGray5
        tableView.separatorStyle = .none
    }
    
    @objc func languageChanged() {
        items = ["General", "Business", "Entertainment", "Health", "Science", "Sports", "Technology"].map { $0.localized() }
        tableView.reloadData()
    }
    @objc func fullNameUpdated() {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuHeaderTableViewCell", for: indexPath) as! MenuHeaderTableViewCell
            cell.headerImage.image = UIImage(systemName: "person.fill")
            cell.fullNameText.text = authManage.getUserFromUserDefaults()?.fullname
            cell.helloText.text = "hello".localized()
            cell.backgroundColor = .systemGray5

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell", for: indexPath) as! MenuItemTableViewCell
            let menuItem = items[indexPath.row - 1]
            cell.categoryName.text = menuItem.localized()
            cell.backgroundColor = .systemGray5
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        } else {
            return 70
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            let selectedCategory = items[indexPath.row - 1]
            menuDelegate?.didSelectCategory(selectedCategory)

        }
    }
}
