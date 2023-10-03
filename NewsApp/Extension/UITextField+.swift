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

    func setupRightImage(imageName:String){
        let imageView = UIImageView(frame: CGRect(x: 25, y: 10, width: 20, height: 18))
        imageView.image = UIImage(systemName: imageName)
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        imageContainerView.addSubview(imageView)
        rightView = imageContainerView
        rightViewMode = .always
        self.tintColor = .lightGray
    }
}
