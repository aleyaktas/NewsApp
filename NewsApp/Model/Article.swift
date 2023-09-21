//
//  Article.swift
//  NewsApp
//
//  Created by Aleyna Aktaş on 6.09.2023.
//

import Foundation

struct Article: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}
