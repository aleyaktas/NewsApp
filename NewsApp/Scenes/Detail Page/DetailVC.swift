//
//  DetailVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 14.09.2023.
//

import UIKit
import Kingfisher

class DetailVC: UIViewController {

    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var contentText: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var imageUrl:URL?
    var content:String?
    var newTitle:String?
    var article: Article?
    var isCompleted: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageUrl, let content, let titleText {
            detailImage.kf.setImage(with: imageUrl)
            contentText.text = content
            titleText.text = newTitle
        }
        
        if let article {
            updateFavoriteButtonIcon(article)
        }
        
        titleText.numberOfLines = 0
        titleText.lineBreakMode = .byWordWrapping
        
        contentText.numberOfLines = 0
        contentText.lineBreakMode = .byWordWrapping
        
        detailImage.layer.cornerRadius = 20

    }
    
    func updateFavoriteButtonIcon(_ article: Article) {
        if FavoritesManager.shared.isArticleFavorited(article) {
            favoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
    @IBAction func favoriteButtonAct(_ sender: Any) {
        if let article {
            if FavoritesManager.shared.isArticleFavorited(article) {
                FavoritesManager.shared.removeFavorite(article)
                favoriteButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            } else {
                FavoritesManager.shared.addFavorite(article)
                favoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
        }

    }
    
}

