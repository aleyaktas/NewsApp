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
        getFilterNews(query: searchText) { [weak self] articles in
            DispatchQueue.main.async {
                if let articles {
                    self?.newsData = articles
                    self?.tableView.reloadData()
                } else {
                    print("Data not found")
                }
            }
        }
    }
    
    func getFilterNews(query: String, completion: @escaping ([Article]?) -> Void) {
        if let path = Bundle.main.path(forResource: "EnvironmentVariables", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
            let apiKey = dict["API_KEY"] as? String {

            let language = UserDefaults.standard.string(forKey: "AppSelectedLanguage") ?? "US"

            let newsURL = "https://newsapi.org/v2/top-headlines"
            let parameters: [String: Any] = [
                "q": query,
                "country": language == "en" ? "us" : language,
                "apiKey": apiKey
            ]
            
           
           AF.request(newsURL, method: .get, parameters: parameters).responseData { response in
               switch response.result {
               case .success(let data):
                   do {
                       let decoder = JSONDecoder()
                       let newsResponse = try decoder.decode(NewsResponse.self, from: data)
                       
                       if let articles = newsResponse.articles {
                           completion(articles)
                           print(articles.count)
                       } else {
                           completion([])
                       }
                   } catch {
                       print("Error decoding JSON: \(error.localizedDescription)")
                       completion(nil)
                   }
                   
               case .failure(let error):
                   print("Network request failed: \(error.localizedDescription)")
                   completion(nil)
               }
           }
        } else {
           print("EnvironmentVariables.plist not found or API_KEY not set.")
           completion(nil)
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


