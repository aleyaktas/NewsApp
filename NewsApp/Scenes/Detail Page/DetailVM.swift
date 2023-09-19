//
//  DetailVM.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 20.09.2023.
//

import Foundation

class DetailVM {

    func isArticleFavorited(article: Article) -> Bool {
        if FavoritesManager.shared.isArticleFavorited(article) {
            return true
        }
        return false
    }
    
    func removeFavorite(article:Article) {
        FavoritesManager.shared.removeFavorite(article)
    }
    
    func addFavorite(article:Article) {
        FavoritesManager.shared.addFavorite(article)
    }
}
