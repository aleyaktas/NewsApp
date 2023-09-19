//
//  MenuHeaderTableViewCell.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 19.09.2023.
//

import UIKit

class MenuHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var helloText: UILabel!
    @IBOutlet weak var fullNameText: UILabel!
    
    var fullName: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        fullNameText.text = fullName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
