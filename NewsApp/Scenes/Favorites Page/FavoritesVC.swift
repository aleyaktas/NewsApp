//
//  FavoritesVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 14.09.2023.
//

import UIKit
import Localize_Swift

class FavoritesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = FavoritesVM()
    
    let homeVC = HomeVC()
    var newsData: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableView()
        prepareNavigation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: NSNotification.Name("changeLanguage"), object: nil)
 
    }
    
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func prepareNavigation() {
        navigationItem.title = "favorites_title".localized()
    }
    
    @objc func languageChanged() {
        navigationItem.title = "favorites_title".localized()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavoritesArticles()
    }
 
    func getFavoritesArticles() {
        viewModel.getFavoritesArticles()
        tableView.reloadData()
    }
}

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell {
            let article = viewModel.cellForRow(at: indexPath)

            if let urlToImage = article?.urlToImage {
                let url = URL(string: urlToImage)
                cell.newImage.kf.setImage(with: url)
            }
            
            let components = article?.author?.components(separatedBy: ",")
            cell.newAuthor.text = components?.first
            

            let date = homeVC.dateFormatter(dateString: article?.publishedAt ?? "")
            cell.date.text = date ?? "Empty"

            cell.titleText.text = article?.title ?? "Empty"

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailVC", bundle: nil)
        
        let article = viewModel.cellForRow(at: indexPath)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {
            if let urlToImage = article?.urlToImage, let url = URL(string: urlToImage) {
                vc.imageUrl = url
            }
            let components = article?.author?.components(separatedBy: ",")
            vc.newAuthor = components?.first
            
            let date = homeVC.dateFormatter(dateString: article?.publishedAt ?? "")
            vc.date = date ?? "Empty"
            vc.newTitle = article?.title ?? "Empty"
            vc.content = article?.content ?? "Empty"
            vc.article = article

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
