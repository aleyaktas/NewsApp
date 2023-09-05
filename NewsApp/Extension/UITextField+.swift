//
//  UITextField+.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 5.09.2023.
//

import UIKit.UITextField

extension UITextField {
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
                      CGRect(x: 10, y: 5, width: 24, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 20, y: 0, width: 40, height: 30))
        iconContainerView.addSubview(iconView)
        rightView = iconContainerView
        rightView?.tintColor = .gray
        rightViewMode = .always
    }
}
