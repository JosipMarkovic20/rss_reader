//
//  NewsListOutput.swift
//  RSS Reader
//
//  Created by Josip Marković on 21.12.2021..
//

import Foundation
import RxDataSources
import RxCocoa

struct NewsListOutput{
    var items: [NewsListSectionItem]
    var event: NewsListOutputEvent?
}

enum NewsListOutputEvent{
    case reloadData(title: String)
    case error(_ message: String)
    case openNews(url: URL)
}

public struct NewsListSectionItem: Equatable{
    public var identity: String
    public var items: [Item]
    
    public static func ==(lhs: NewsListSectionItem, rhs: NewsListSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }

    public init(identity: String, items: [Item]){
        self.identity = identity
        self.items = items
    }
}

extension NewsListSectionItem: AnimatableSectionModelType{
    public typealias Item = NewsListBaseItem
    public init(original: NewsListSectionItem, items: [Item]) {
        self = original
        self.items = items
    }
}
