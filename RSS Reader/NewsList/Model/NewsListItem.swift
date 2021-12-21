//
//  NewsListItem.swift
//  RSS Reader
//
//  Created by Josip Marković on 21.12.2021..
//

import Foundation
public class NewsListItem: NewsListBaseItem{
    let item: News

    init(identity: String, item: News) {
        self.item = item
        super.init(identity: identity)
    }
}
