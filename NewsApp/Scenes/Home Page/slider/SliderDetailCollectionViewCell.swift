//
//  SliderDetailCollectionViewCell.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 6.09.2023.
//

import UIKit

class SliderDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var decription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 20
    }
    
}
