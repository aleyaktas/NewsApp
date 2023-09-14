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
        
        let newsCellNib: UINib = UINib(nibName: "NewsDetailCollectionView", bundle: nil)
        collectionView.register(newsCellNib, forCellWithReuseIdentifier: "NewsDetailCollectionViewCell")
       
       
    }
    
    func fetchNewsData() {
        getAllNews { [weak self] articles in
            DispatchQueue.main.async {
                if let articles = articles {
                    self?.newsData = articles
                    self?.collectionView.reloadData()
                } else {
                    print("Data not found")
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

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SliderSelectDelegate {
    func didSelectCell(article: Article) {
        let storyboard = UIStoryboard(name: "DetailVC", bundle: nil)

        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {
            if let urlToImage = article.urlToImage, let url = URL(string: urlToImage) {
                vc.imageUrl = url
            }

            vc.content = article.content ?? "Empty"

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
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
                    cell.delegate = self

                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsDetailCollectionViewCell", for: indexPath) as? NewsDetailCollectionViewCell {
                    let article = newsData[indexPath.row]

                    if let urlToImage = article.urlToImage {
                        let url = URL(string: urlToImage)
                        cell.newImage.kf.setImage(with: url)
                    }

                    cell.categoryName.text = article.author ?? "Empty"
                    cell.detail.text = article.title ?? "Empty"
                
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
        let cellHeight: CGFloat = (indexPath.section == 0) ? 300 : 200
        
        return CGSize(width: cellWidth, height: cellHeight)
        }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.size.width, height: 70)
        } else {
            return CGSize(width: collectionView.frame.size.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionView", for: indexPath) as! HeaderCollectionView
            if let headerLabel = cell.headerLabel {
                headerLabel.text = "Latest News"
            } else {
            }
            return cell
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailVC", bundle: nil)
        
        let article = newsData[indexPath.row]
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {
            if let urlToImage = article.urlToImage, let url = URL(string: urlToImage) {
                vc.imageUrl = url
            }

            vc.content = article.content ?? "Empty"

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }



    
}
