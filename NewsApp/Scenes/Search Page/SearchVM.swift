//
//  SearchViewModel.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 19.09.2023.
//

import Foundation

final class SearchVM {
    
    var newsData: [Article] = []
    
    var onSucces: (()->())?
    var onError: ((_ errorStr: String)->())?
    
    init() {
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
                            self?.onError?("No articles found")
                        } else {
                            print(articles)
                            self?.newsData = articles
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
    }

    func cellForRow(at indexPath: IndexPath) -> Article? {
        return newsData[indexPath.row]
    }
    
    func numberOfItems(in section: Int) -> Int {
        return newsData.count
    }
    
    
}
