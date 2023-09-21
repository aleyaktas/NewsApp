//
//  MenuVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 15.09.2023.
//

import UIKit
import Localize_Swift

protocol MenuListDelegate {
    func didSelectCategory(_ category: Category)
}

class MenuListController: UITableViewController {
    
    var items: [Category] = CategoryList().items

    public var menuDelegate: MenuListDelegate?
    var selectedIndexPath: IndexPath?
    
    let viewModel = MenuVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged),name: NSNotification.Name("changeLanguage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fullNameUpdated),name: NSNotification.Name("updateFullName"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(profileUpdated),name: NSNotification.Name("updateProfileImage"), object: nil)

        customNibs()
        languageChanged()
    }
    
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray5
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func customNibs() {
        let menuHeaderCellNib = UINib(nibName: "MenuHeaderTableView", bundle: nil)
        tableView.register(menuHeaderCellNib, forCellReuseIdentifier: "MenuHeaderTableViewCell")
        let menuItemCellNib = UINib(nibName: "MenuItemTableView", bundle: nil)
        tableView.register(menuItemCellNib, forCellReuseIdentifier: "MenuItemTableViewCell")
        selectedIndexPath = IndexPath(row: 1, section: 0)

    }
    
    @objc func languageChanged() {
        tableView.reloadData()
    }
    
    @objc func fullNameUpdated() {
        tableView.reloadData()
    }
    
    @objc func profileUpdated() {
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
    
            if let downloadURL = viewModel.uploadUserImage() {
              cell.headerImage.kf.setImage(with: downloadURL)
            } 
              
            cell.fullNameText.text = viewModel.getFullName()
            cell.helloText.text = "hello".localized()
            cell.backgroundColor = .systemGray5

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell", for: indexPath) as! MenuItemTableViewCell
            let menuItem = items[indexPath.row - 1]
            
            cell.iconImage.image = UIImage(named: menuItem.id.lowercased())
            if indexPath == selectedIndexPath {
                cell.categoryName.textColor = UIColor(named: "primary")
               cell.iconImage.tintColor = UIColor(named: "primary")
           } else {
               cell.categoryName.textColor = .label
               cell.iconImage.tintColor = .label
           }
                       
            cell.categoryName.text = menuItem.value.localized()
            cell.backgroundColor = .systemGray5
           
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        } else {
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            let selectedCategory = items[indexPath.row - 1]
                menuDelegate?.didSelectCategory(selectedCategory)
                selectedIndexPath = indexPath
                tableView.reloadData()
        }
    }
}


