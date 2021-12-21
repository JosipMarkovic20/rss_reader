//
//  News.swift
//  RSS Reader
//
//  Created by Josip Marković on 20.12.2021..
//

import Foundation

struct News: Equatable {
    let title: String?
    let imageLink: String?
    let items: [NewsItem]
}

struct NewsItem: Equatable {
    let title: String?
    let link: String?
    let imageLink: String?
}
