//
//  SerilizationManager.swift
//  RSS Reader
//
//  Created by Josip Marković on 20.12.2021..
//

import Foundation

class SerilizationManager{
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
