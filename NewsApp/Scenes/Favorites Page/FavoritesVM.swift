//
//  FavoritesVM.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 20.09.2023.
//

import Foundation

class FavoritesVM {
    var newsData: [Article] = []
    
    init() {
        getFavoritesArticles()
    }

    func getFavoritesArticles() {
        newsData = FavoritesManager.shared.getFavorites()
    }
    
    func cellForRow(at indexPath: IndexPath) -> Article? {
        return newsData[indexPath.row]
    }
    
    func numberOfItems(in section: Int) -> Int {
        return newsData.count
    }
}
