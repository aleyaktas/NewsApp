//
//  NewsDetailCollectionViewCell.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 13.09.2023.
//

import UIKit

class NewsDetailCollectionViewCell: UICollectionViewCell {

   
    @IBOutlet weak var newImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

        categoryName.preferredMaxLayoutWidth = contentView.frame.width - newImage.frame.width - 20
        detail.preferredMaxLayoutWidth = contentView.frame.width - newImage.frame.width - 20
        
        categoryName.numberOfLines = 0
        categoryName.lineBreakMode = .byWordWrapping

        detail.numberOfLines = 0
        detail.lineBreakMode = .byWordWrapping
        
        categoryName.adjustsFontSizeToFitWidth = true
        categoryName.minimumScaleFactor = 0.5
        categoryName.lineBreakMode = .byTruncatingTail

        detail.adjustsFontSizeToFitWidth = true
        detail.minimumScaleFactor = 0.5
        detail.lineBreakMode = .byTruncatingTail
        
        newImage.layer.cornerRadius = 20
    }
}

