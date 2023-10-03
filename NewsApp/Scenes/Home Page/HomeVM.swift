//
//  HomeVM.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 20.09.2023.
//

import Foundation

class HomeVM {
    var newsData: [Article] = []
    
    var onSucces: (()->())?
    var onError: ((_ errorStr: String)->())?
    
    init() {
        fetchNewsData(category: "general")
    }
    
    func fetchNewsData(category: String) {
        NetworkManager.shared.getAllNews(query: "", category: category) { [weak self] result in
                switch result {
                case .success(let newsResponse):
                    if let articles = newsResponse.articles {
                        if articles.isEmpty {
                            self?.newsData = []
                            self?.onError?("No articles found")
                        } else {
                            self?.newsData = articles.filter({ $0.title != "[Removed]"})
                            self?.onSucces?()
                        }
                    } else {
                        print("Articles key not found in data")
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
        }
    }

    func cellForRow(at indexPath: IndexPath) -> Article? {
        return newsData[indexPath.row]
    }
    
    func numberOfItems(in section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            print(newsData.count)
            return newsData.count
        }
        return 0
    }
    
    func getTenItems() -> [Article] {
        return Array(newsData.prefix(10))
    }
    
}
