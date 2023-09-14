//
//  SearchVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 14.09.2023.
//

import UIKit
import Alamofire

class SearchVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var newsData: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNewsData(searchText: "")
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    func fetchNewsData(searchText: String) {
        getFilterNews(query: searchText) { [weak self] articles in
            DispatchQueue.main.async {
                if let articles = articles {
                    self?.newsData = articles
                    print(articles.count)
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
           
           let newsURL = "https://newsapi.org/v2/top-headlines"
           let parameters: [String: Any] = [
                "q": query,
                "country": "US",
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchNewsTableViewCell", for: indexPath) as? SearchNewsTableViewCell {
            let article = newsData[indexPath.row]

            if let urlToImage = article.urlToImage {
                let url = URL(string: urlToImage)
                cell.searchImage.kf.setImage(with: url)
            }

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


