//
//  UIViewController+.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 18.09.2023.
//

import UIKit.UIViewController

extension UIViewController {
    func showAlert(title: String?, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
