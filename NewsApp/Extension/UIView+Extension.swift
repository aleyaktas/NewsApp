//
//  UIView+Extension.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 15.09.2023.
//

import UIKit.UIView

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return cornerRadius }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
