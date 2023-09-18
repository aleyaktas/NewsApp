//
//  Bundle+.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 17.09.2023.
//

import Foundation

extension Bundle {
    private static var bundleKey: UInt8 = 0

    static var currentLanguage: String {
        return objc_getAssociatedObject(self, &bundleKey) as? String ?? "en"
    }

    static func setLanguage(_ language: String) {
        objc_setAssociatedObject(self, &bundleKey, language, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        UserDefaults.standard.set([language], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}
