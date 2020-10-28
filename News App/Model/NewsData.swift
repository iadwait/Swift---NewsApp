//
//  NewsData.swift
//  News App
//
//  Created by Adwait Barkale on 28/10/20.
//  Copyright © 2020 Adwait Barkale. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct NewsData: Codable {
    let status: String
    let totalResults: Int
    var articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let author: String?
    let title, articleDescription: String?
    //let url: String
    let urlToImage: String?
    //let publishedAt: Date
    //let content: String?

    enum CodingKeys: String, CodingKey {
        //case source, author, title
        case author , title
        case articleDescription = "description"
        case urlToImage
        //case url, publishedAt, content
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}
