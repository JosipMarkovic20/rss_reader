//
//  NewsListBaseItem.swift
//  RSS Reader
//
//  Created by Josip Marković on 21.12.2021..
//

import Foundation
import RxDataSources

public class NewsListBaseItem: IdentifiableType, Equatable{
    public static func ==(lhs: NewsListBaseItem, rhs: NewsListBaseItem) -> Bool {
        lhs.identity == rhs.identity
    }
    
    public let identity: String
    
    
    public init(identity: String){
        self.identity = identity
    }
    
}
