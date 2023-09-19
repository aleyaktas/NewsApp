//
//  SettingsVM.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 19.09.2023.
//

import UIKit

enum Language: String {
    case turkish = "tr"
    case english = "en"
}

class SettingsVM {
    var isDarkModeOn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "IsDarkMode")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "IsDarkMode")
            applyDarkMode()
        }
    }

    var selectedLanguage: Language {
        get {
            if let languageCode = UserDefaults.standard.string(forKey: "AppSelectedLanguage"), let language = Language(rawValue: languageCode) {
                return language
            }
            return .english
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "AppSelectedLanguage")
        }
    }

    func applyDarkMode() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = isDarkModeOn ? .dark : .light
            }
        }
    }
}
