//
//  HomeVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 5.09.2023.
//

import UIKit
import Alamofire

class HomeVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureData()
        customNibs()
    }
    
    private func configureData() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func customNibs() {
        let sliderCellNib: UINib = UINib(nibName: "SliderCollectionView", bundle: nil)
        collectionView.register(sliderCellNib, forCellWithReuseIdentifier: "SliderCollectionViewCell")
    }
    
    func configureSliderCell(cell: SliderCollectionViewCell, forItemAt indexPath :IndexPath) {
        getAllNews { [weak self] articles in
            DispatchQueue.main.async {
                if let articles = articles {
                    cell.sliderDataList = articles
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionViewCell", for: indexPath) as? SliderCollectionViewCell {
            getAllNews { articles in
                if let articles = articles {
                    cell.sliderDataList = articles
                } else {
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        
        let cellWidth = collectionViewWidth
        
        let cellHeight: CGFloat = 200.0
        
        return CGSize(width: cellWidth, height: cellHeight)
    }

}
