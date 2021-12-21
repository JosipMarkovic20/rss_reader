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
    let link: String?
    let items: [News]
}
