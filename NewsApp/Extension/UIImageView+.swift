//
//  UIImageView.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 6.09.2023.
//

import UIKit.UIImageView

extension UIImageView {
    func load(url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder // Önce bir varsayılan görüntü ata
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        // Eğer bu hücre hala görülebilir ise, resmi ata
                        if let strongSelf = self {
                            strongSelf.image = image
                        }
                    }
                }
            }
        }
    }
}

