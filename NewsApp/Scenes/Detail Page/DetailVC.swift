//
//  DetailVC.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 14.09.2023.
//

import UIKit
import Kingfisher

class DetailVC: UIViewController {

    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var contentText: UILabel!
    
    var imageUrl:URL?
    var content:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageUrl, let content {
            detailImage.kf.setImage(with: imageUrl)
            contentText.text = content
        }
        
        contentText.numberOfLines = 0
        contentText.lineBreakMode = .byWordWrapping
        
        detailImage.layer.cornerRadius = 20

    }
}
