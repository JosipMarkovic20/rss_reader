//
//  HomeItem.swift
//  RSS Reader
//
//  Created by Josip Marković on 21.12.2021..
//

import Foundation
public class HomeItem: HomeBaseItem{
    let item: News

    init(identity: String, item: News) {
        self.item = item
        super.init(identity: identity)
    }
}
