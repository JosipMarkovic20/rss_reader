//
//  HomeOutput.swift
//  RSS Reader
//
//  Created by Josip Marković on 21.12.2021..
//

import Foundation
import RxDataSources
import RxCocoa

struct HomeOutput{
    var items: [HomeSectionItem]
    var event: HomeOutputEvent?
}

enum HomeOutputEvent{
    case reloadData
    case error(_ message: String)
    case openNewsList(news: News)
}

public struct HomeSectionItem: Equatable{
    public var identity: String
    public var items: [Item]
    
    public static func ==(lhs: HomeSectionItem, rhs: HomeSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }

    public init(identity: String, items: [Item]){
        self.identity = identity
        self.items = items
    }
}

extension HomeSectionItem: AnimatableSectionModelType{
    public typealias Item = HomeBaseItem
    public init(original: HomeSectionItem, items: [Item]) {
        self = original
        self.items = items
    }
}
