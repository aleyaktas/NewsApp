//
//  SearchVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 14.09.2023.
//

import UIKit
import Alamofire
import Localize_Swift

class SearchVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var newsData: [Article] = []
    let homeVC = UIStoryboard(name: "HomeVC", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "search_placeholder".localized()
        
        
        navigationItem.title = "search_title".localized()
        
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: NSNotification.Name("changeLanguage"), object: nil)
        
        fetchNewsData(searchText: "")
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.text = ""
        fetchNewsData(searchText: "")
    }
    
    @objc func languageChanged() {
        navigationItem.title = "search_title".localized()
        fetchNewsData(searchText: "")
    }
    
    func fetchNewsData(searchText: String) {
        NetworkManager.shared.getAllNews(query: searchText, category: "") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newsResponse):
                    if let articles = newsResponse.articles {
                        if articles.isEmpty {
                            self?.newsData = []
                            self?.tableView.reloadData()
                            print("No articles found")
                        } else {
                            self?.newsData = articles
                            self?.tableView.reloadData()
                        }
                    } else {
                        print("Articles key not found in data")
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

}

extension SearchVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell {
            let article = newsData[indexPath.row]

            if let urlToImage = article.urlToImage {
                let url = URL(string: urlToImage)
                cell.newImage.kf.setImage(with: url)
            }
            
            if let author = article.author {
                let components = author.components(separatedBy: ",")
                cell.newAuthor.text = components.first
            }

            let date = homeVC?.dateFormatter(dateString: article.publishedAt ?? "2023-09-15T12:10:00Z")
            cell.date.text = date ?? "Empty"

            cell.titleText.text = article.title ?? "Empty"

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailVC", bundle: nil)
        
        let article = newsData[indexPath.row]
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {
            if let urlToImage = article.urlToImage, let url = URL(string: urlToImage) {
                vc.imageUrl = url
            }
            vc.newTitle = article.title ?? "Empty"
            vc.content = article.content ?? "Empty"
            vc.article = article

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchNewsData(searchText: searchText)
    }
}


