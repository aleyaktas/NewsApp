//
//  HeaderCollectionView.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 13.09.2023.
//

import UIKit
import Localize_Swift

class HeaderCollectionView: UICollectionReusableView {
    
    @IBOutlet weak var headerLabel: UILabel!
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
    private func commonInit() {
        if let labelText = headerLabel?.text {
            headerLabel?.text = labelText.localized()
        }
    }

    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
    
}
