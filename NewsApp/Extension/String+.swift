//
//  String+.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 2.10.2023.
//

import Foundation

extension String {
    func dateFormatter() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let userSelectedLanguage = UserDefaults.standard.string(forKey: "AppSelectedLanguage") ?? "en"
        
        if userSelectedLanguage == "en" {
            dateFormatter.locale = Locale(identifier: "en_US")
        } else if userSelectedLanguage == "tr" {
            dateFormatter.locale = Locale(identifier: "tr_TR")
        }
        
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "dd MMM, yyyy"
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        }
        return nil
    }
}

