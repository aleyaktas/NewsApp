//
//  Categories.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 19.09.2023.
//

import Foundation

struct Category {
    let id: String
    let value: String
}

struct CategoryList {
    var items: [Category] = [
        Category(id: "general", value: "General"),
        Category(id: "business", value: "Business"),
        Category(id: "entertainment", value: "Entertainment"),
        Category(id: "health", value: "Health"),
        Category(id: "science", value: "Science"),
        Category(id: "sports", value: "Sports"),
        Category(id: "technology", value: "Technology")
    ]
}

