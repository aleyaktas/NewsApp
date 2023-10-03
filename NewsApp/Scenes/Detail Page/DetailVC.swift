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
    
    var article: Article? {
        didSet {
            viewModel = DetailVM(article: article!)
        }
    }
    
    var viewModel: DetailVM!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _ = viewModel else { fatalError("ViewModel should be set") }
        configureData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func configureData() {
        detailImage.kf.setImage(with: viewModel.imageUrl)

        author.text = viewModel.authorText.isEmpty ? nil : viewModel.authorText

        contentText.text = viewModel.contentText
        titleText.text = viewModel.titleText
        newDate.text = viewModel.dateText
        
        scrollView.contentSize = detailView.frame.size
        
        updateFavoriteButtonIcon()
        
        titleText.numberOfLines = 0
        titleText.lineBreakMode = .byWordWrapping
        
        contentText.numberOfLines = 0
        contentText.lineBreakMode = .byWordWrapping
    }
    
    func updateFavoriteButtonIcon() {
        let (image, color) = viewModel.favoriteButtonIconAndTintColor()
        favoriteButton.setImage(image, for: .normal)
        favoriteButton.tintColor = color
    }
    
    @IBAction func favoriteButtonAct(_ sender: Any) {
        viewModel.toggleFavorite()
        updateFavoriteButtonIcon()
    }
}
