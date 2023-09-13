//
//  HomeVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 5.09.2023.
//

import UIKit
import Alamofire
import Kingfisher


class HomeVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var newsData: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureData()
        customNibs()
        fetchNewsData()

    }
    
    private func configureData() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func customNibs() {
        let sliderCellNib: UINib = UINib(nibName: "SliderCollectionView", bundle: nil)
        collectionView.register(sliderCellNib, forCellWithReuseIdentifier: "SliderCollectionViewCell")
        
        let newsCellNib: UINib = UINib(nibName: "NewsDetailTableView", bundle: nil)
        collectionView.register(newsCellNib, forCellWithReuseIdentifier: "NewsDetailTableViewCell")
    }
    
    func fetchNewsData() {
        getAllNews { [weak self] articles in
            DispatchQueue.main.async {
                if let articles = articles {
                    self?.newsData = articles
                    self?.collectionView.reloadData()
                } else {
                    print("else")
                }
            }
        }}
    
    func getAllNews(completion: @escaping ([Article]?) -> Void) {
        if let path = Bundle.main.path(forResource: "EnvironmentVariables", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
           let apiKey = dict["API_KEY"] as? String {
           
           let newsURL = "https://newsapi.org/v2/top-headlines"
           let parameters: [String: Any] = [
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

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            print(newsData.count)
            return newsData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionViewCell", for: indexPath) as? SliderCollectionViewCell {
                    cell.sliderDataList = newsData
                
                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsDetailTableViewCell", for: indexPath) as? NewsDetailTableViewCell {
                    let article = newsData[indexPath.row]

                    if let urlToImage = article.urlToImage {
                        let url = URL(string: urlToImage)
                        cell.newImage.kf.setImage(with: url)
                    }
                   
                    cell.categoryName.text = article.author ?? "Empty"
                    cell.detail.text = article.description ?? "Empty"
                
                
                return cell
            }
        }
        return UICollectionViewCell()
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        
        let cellWidth = collectionViewWidth
        
        let cellHeight: CGFloat = 300.0
        
        if indexPath.section == 0 {
            return CGSize(width: cellWidth, height: cellHeight)
        }
        
        return CGSize(width: cellWidth, height: cellHeight - 100)
        
    }
}
