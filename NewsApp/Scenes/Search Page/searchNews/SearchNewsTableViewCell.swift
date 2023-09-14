//
//  SearchNewsTableViewCell.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 14.09.2023.
//

import UIKit

class SearchNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var searchImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchImage.layer.cornerRadius = 20
        
        titleText.numberOfLines = 0
        titleText.lineBreakMode = .byWordWrapping
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        searchImage.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
