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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var newDate: UILabel!
    
    var imageUrl:URL?
    var content:String?
    var newTitle:String?
    var article: Article?
    var isCompleted: Bool?
    var newAuthor: String?
    var date: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageUrl, let content, let titleText, let newAuthor, let date {
            detailImage.kf.setImage(with: imageUrl)
            contentText.text = content
            titleText.text = newTitle
            author.text = newAuthor
            newDate.text = date
        }
        scrollView.contentSize = detailView.frame.size
        if let article {
            updateFavoriteButtonIcon(article)
        }
        
        titleText.numberOfLines = 0
        titleText.lineBreakMode = .byWordWrapping
        
        contentText.numberOfLines = 0
        contentText.lineBreakMode = .byWordWrapping
        
    }
    
    func updateFavoriteButtonIcon(_ article: Article) {
        if FavoritesManager.shared.isArticleFavorited(article) {
            favoriteButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            favoriteButton.tintColor = UIColor(named: "primary")

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

