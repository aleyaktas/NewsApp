//
//  MenuVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 15.09.2023.
//

import UIKit

protocol MenuListDelegate {
    func didSelectCategory(_ category: String)
}

class MenuListController: UITableViewController {
    var items = ["General","Business","Entertainment","Health", "Science","Sports","Technology"]
    
    public var menuDelegate: MenuListDelegate?
    
    init(items: [String] = ["General","Business","Entertainment","Health", "Science","Sports","Technology"], menuDelegate: MenuListDelegate? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.items = items
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init(coder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .systemGray4
        tableView.separatorStyle = .none
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
