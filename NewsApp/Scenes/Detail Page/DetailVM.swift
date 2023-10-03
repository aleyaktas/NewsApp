//
//  DetailVM.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 20.09.2023.
//

import UIKit

final class DetailVM {
    
    private var article: Article?
    
    init(article: Article) {
        self.article = article
    }
        
    
    var titleText: String {
        return article?.title ?? ""
    }
    
    var contentText: String {
        return article?.content ?? ""
    }
    
    var authorText: String {
        return article?.author ?? ""
    }
    
    var dateText: String {
        return article?.publishedAt?.dateFormatter() ?? ""
    }
    
    var imageUrl: URL? {
        guard let urlString = article?.urlToImage, let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
    
    var isArticleFavorited: Bool {
        if let unwrappedArticle = article {
            return FavoritesManager.shared.isArticleFavorited(unwrappedArticle)
        } else {
            return false
        }
    }

    func isArticleFavorited(article: Article) -> Bool {
        if FavoritesManager.shared.isArticleFavorited(article) {
            return true
        }
        return false
    }
    
    func favoriteButtonIconAndTintColor() -> (UIImage?, UIColor?) {
       let isFavorite = isArticleFavorited
       let image = UIImage(systemName: isFavorite ? "bookmark.fill" : "bookmark")
       let color = isFavorite ? UIColor(named: "primary") : nil
       return (image, color)
    }
    
    func toggleFavorite() {
            guard let article = article else { return }
            if isArticleFavorited {
                FavoritesManager.shared.removeFavorite(article)
            } else {
                FavoritesManager.shared.addFavorite(article)
            }
        }
 
    
    func removeFavorite(article:Article) {
        FavoritesManager.shared.removeFavorite(article)
    }
    
    func addFavorite(article:Article) {
        FavoritesManager.shared.addFavorite(article)
    }
}

