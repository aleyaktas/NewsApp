//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 14.09.2023.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var newImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newImage.layer.cornerRadius = 20
        
        titleText.numberOfLines = 0
        titleText.lineBreakMode = .byWordWrapping
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        newImage.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

