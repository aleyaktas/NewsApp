//
//  FavoritesVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 14.09.2023.
//

import UIKit
import Localize_Swift

final class FavoritesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = FavoritesVM()
    var isDataEmpty = false
    
    let homeVC = HomeVC()
    var newsData: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableView()
        prepareNavigation()
        
        customNibs()
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: NSNotification.Name("changeLanguage"), object: nil)
    }
    
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func prepareNavigation() {
        navigationItem.title = "favorites_title".localized()
    }
    
    func customNibs() {
        let emptyCell = UINib(nibName: "EmptyCell", bundle: nil)
        tableView.register(emptyCell, forCellReuseIdentifier: "EmptyCell")
    }
    
    @objc func languageChanged() {
        navigationItem.title = "favorites_title".localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavoritesArticles()
    }
 
    func getFavoritesArticles() {
        viewModel.getFavoritesArticles()
        self.isDataEmpty = self.viewModel.numberOfItems(in: 0) == 0
        tableView.reloadData()
    }
}

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isDataEmpty {
            return 1
        } else {
            return viewModel.numberOfItems(in: section)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isDataEmpty {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as? EmptyCell {
                cell.emptyText.text = "favorites_empty_text".localized()
                cell.emptyImage.image = UIImage(named:"favorites-empty")
                cell.emptyImage.tintColor = .secondaryLabel
                cell.backgroundColor = .systemGray6
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell {
                let article = viewModel.cellForRow(at: indexPath)

                if let urlToImage = article?.urlToImage {
                    let url = URL(string: urlToImage)
                    cell.newImage.kf.setImage(with: url)
                } else {
                    cell.newImage.image = UIImage(named: "no_photo")
                    cell.tintColor = .secondaryLabel
                }
                
                let components = article?.author?.components(separatedBy: ",")
                cell.newAuthor.text = components?.first
                

                let date = article?.publishedAt?.dateFormatter()

                cell.date.text = date ?? "Empty"

                cell.titleText.text = article?.title ?? "Empty"

                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isDataEmpty {
            let storyboard = UIStoryboard(name: "DetailVC", bundle: nil)
            
            let article = viewModel.cellForRow(at: indexPath)
            
            if let vc = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {
              
                vc.article = article
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            }else {
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isDataEmpty {
            return tableView.frame.height
        } else {
            return 150
        }
    }

}
